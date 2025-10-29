import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/zoning_feature.dart';
import 'zoning_api_service.dart';

/// Upload status for individual features
enum UploadStatus {
  pending,
  uploading,
  success,
  error,
  duplicate,
}

/// Upload result for a feature
class UploadResult {
  final String clientUuid;
  final UploadStatus status;
  final String? serverId;
  final String? error;
  final DateTime? uploadedAt;

  UploadResult({
    required this.clientUuid,
    required this.status,
    this.serverId,
    this.error,
    this.uploadedAt,
  });
}

/// Service to manage upload queue with idempotency and retry logic
class UploadQueueService {
  final ZoningApiService _apiService;
  final NetworkInfo _networkInfo;

  // Retry configuration
  static const int maxRetries = 3;
  static const int baseDelaySeconds = 2;
  static const int maxDelaySeconds = 60;

  // Track retry attempts per feature
  final Map<String, int> _retryAttempts = {};
  
  // Track upload status
  final StreamController<Map<String, UploadResult>> _uploadStatusController =
      StreamController<Map<String, UploadResult>>.broadcast();

  Stream<Map<String, UploadResult>> get uploadStatusStream =>
      _uploadStatusController.stream;

  UploadQueueService({
    required ZoningApiService apiService,
    required NetworkInfo networkInfo,
  })  : _apiService = apiService,
        _networkInfo = networkInfo;

  /// Upload a single feature with retry logic
  Future<UploadResult> uploadFeature(ZoningFeature feature) async {
    final clientUuid = feature.clientUuid;

    // Check if already uploaded
    if (feature.uploaded) {
      AppLogger.info('Feature $clientUuid already uploaded, skipping');
      return UploadResult(
        clientUuid: clientUuid,
        status: UploadStatus.duplicate,
        serverId: feature.serverId,
      );
    }

    // Check network connectivity
    final isOnline = await _networkInfo.hasInternetConnection;
    if (!isOnline) {
      return UploadResult(
        clientUuid: clientUuid,
        status: UploadStatus.error,
        error: 'No internet connection',
      );
    }

    // Attempt upload with retry
    return _uploadWithRetry(feature);
  }

  /// Bulk upload all unuploaded features for a locality
  Future<List<UploadResult>> bulkUpload({
    required String localityId,
    required List<ZoningFeature> features,
    int? planId,
    bool uploadReadyOnly = false,
  }) async {
    // Filter out already uploaded features
    final unuploadedFeatures = features.where((f) => !f.uploaded).toList();

    if (unuploadedFeatures.isEmpty) {
      AppLogger.info('No features to upload');
      return [];
    }

    // Check network
    final isOnline = await _networkInfo.hasInternetConnection;
    if (!isOnline) {
      return unuploadedFeatures
          .map((f) => UploadResult(
                clientUuid: f.clientUuid,
                status: UploadStatus.error,
                error: 'No internet connection',
              ))
          .toList();
    }

    try {
      AppLogger.info('Bulk uploading ${unuploadedFeatures.length} features');

      final response = await _apiService.bulkUploadZones(
        planId: planId,
        features: unuploadedFeatures,
      );

      return _processBulkResponse(response, unuploadedFeatures);
    } catch (e) {
      AppLogger.error('Bulk upload failed', e);
      
      // Fall back to individual uploads
      AppLogger.info('Falling back to individual uploads');
      return _fallbackIndividualUploads(unuploadedFeatures);
    }
  }

  /// Process bulk upload response
  List<UploadResult> _processBulkResponse(
    Map<String, dynamic> response,
    List<ZoningFeature> features,
  ) {
    final results = <UploadResult>[];
    final responseResults = response['results'] as List? ?? [];
    final errors = response['errors'] as List? ?? [];

    // Process successful uploads
    for (final result in responseResults) {
      final clientUuid = result['client_uuid'] as String;
      final serverId = result['server_id']?.toString();
      final status = result['status'] as String;

      results.add(UploadResult(
        clientUuid: clientUuid,
        status: status == 'duplicate'
            ? UploadStatus.duplicate
            : UploadStatus.success,
        serverId: serverId,
        uploadedAt: DateTime.now(),
      ));
    }

    // Process errors
    for (final error in errors) {
      final clientUuid = error['client_uuid'] as String;
      final errorMessage = error['error'] as String?;

      results.add(UploadResult(
        clientUuid: clientUuid,
        status: UploadStatus.error,
        error: errorMessage,
      ));
    }

    return results;
  }

  /// Fallback to individual uploads if bulk fails
  Future<List<UploadResult>> _fallbackIndividualUploads(
    List<ZoningFeature> features,
  ) async {
    final results = <UploadResult>[];

    for (final feature in features) {
      try {
        final result = await _uploadWithRetry(feature);
        results.add(result);
        
        // Small delay between uploads to avoid overwhelming server
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        results.add(UploadResult(
          clientUuid: feature.clientUuid,
          status: UploadStatus.error,
          error: e.toString(),
        ));
      }
    }

    return results;
  }

  /// Upload with exponential backoff retry
  Future<UploadResult> _uploadWithRetry(ZoningFeature feature) async {
    final clientUuid = feature.clientUuid;
    int attempts = _retryAttempts[clientUuid] ?? 0;

    while (attempts < maxRetries) {
      try {
        // Attempt upload
        final response = feature.serverId != null
            ? await _apiService.updateZone(feature)
            : await _apiService.createZone(feature);

        // Success
        _retryAttempts.remove(clientUuid);
        
        return UploadResult(
          clientUuid: clientUuid,
          status: UploadStatus.success,
          serverId: response['id']?.toString() ?? response['server_id']?.toString(),
          uploadedAt: DateTime.now(),
        );
      } on DioException catch (e) {
        // Handle 409 Conflict as duplicate (already uploaded)
        if (e.response?.statusCode == 409) {
          _retryAttempts.remove(clientUuid);
          
          return UploadResult(
            clientUuid: clientUuid,
            status: UploadStatus.duplicate,
            serverId: e.response?.data['id']?.toString(),
          );
        }

        // Handle other errors with retry
        attempts++;
        _retryAttempts[clientUuid] = attempts;

        if (attempts < maxRetries) {
          final delay = _calculateBackoff(attempts);
          AppLogger.warning(
            'Upload failed for $clientUuid (attempt $attempts/$maxRetries), '
            'retrying in ${delay}s',
          );
          await Future.delayed(Duration(seconds: delay));
        } else {
          _retryAttempts.remove(clientUuid);
          
          return UploadResult(
            clientUuid: clientUuid,
            status: UploadStatus.error,
            error: 'Max retries exceeded: ${e.message}',
          );
        }
      } catch (e) {
        attempts++;
        _retryAttempts[clientUuid] = attempts;

        if (attempts >= maxRetries) {
          _retryAttempts.remove(clientUuid);
          
          return UploadResult(
            clientUuid: clientUuid,
            status: UploadStatus.error,
            error: e.toString(),
          );
        }

        final delay = _calculateBackoff(attempts);
        await Future.delayed(Duration(seconds: delay));
      }
    }

    // Should never reach here, but just in case itoe error hii
    return UploadResult(
      clientUuid: clientUuid,
      status: UploadStatus.error,
      error: 'Upload failed after retries',
    );
  }

  /// Calculate exponential backoff delay
  int _calculateBackoff(int attempt) {
    final delay = baseDelaySeconds * pow(2, attempt - 1);
    return min(delay.toInt(), maxDelaySeconds);
  }

  /// Reset retry attempts for a feature
  void resetRetries(String clientUuid) {
    _retryAttempts.remove(clientUuid);
  }

  /// Get current retry count for a feature
  int getRetryCount(String clientUuid) {
    return _retryAttempts[clientUuid] ?? 0;
  }

  /// Check if feature can be retried
  bool canRetry(String clientUuid) {
    return (_retryAttempts[clientUuid] ?? 0) < maxRetries;
  }

  void dispose() {
    _uploadStatusController.close();
  }
}
