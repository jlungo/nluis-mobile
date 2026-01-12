import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';
import '../../domain/entities/land_use.dart';

/// API Service for fetching land use types and their styling
class LandUseApiService {
  final DioClient _dioClient;

  LandUseApiService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Fetch all land use types with colors and styles
  /// 
  /// Expected Response example:
  /// ```json
  /// [
  ///   {
  ///     "id": 1,
  ///     "name": "Agricultural",
  ///     "description": "Agricultural",
  ///     "color": "#3CAA0C",
  ///     "style": { "layers": [] }
  ///   },
  ///   ...
  /// ]
  /// ```
  Future<List<LandUse>> fetchLandUses() async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        '/setup/land-uses',
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map((json) => LandUse.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Endpoint not found, return empty list
        return [];
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Get a specific land use by ID
  Future<LandUse?> fetchLandUseById(int id) async {
    try {
      final landUses = await fetchLandUses();
      return landUses.where((lu) => lu.id == id).firstOrNull;
    } catch (e) {
      rethrow;
    }
  }
}
