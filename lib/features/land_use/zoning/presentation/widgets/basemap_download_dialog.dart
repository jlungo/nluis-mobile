import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/zoning_providers.dart';
import '../providers/mvt_providers.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';

class BasemapDownloadDialog extends ConsumerStatefulWidget {
  final String projectId;
  final String localityId;
  final VoidCallback onDownloadComplete;
  final VoidCallback onCancel;

  const BasemapDownloadDialog({
    super.key,
    required this.projectId,
    required this.localityId,
    required this.onDownloadComplete,
    required this.onCancel,
  });

  @override
  ConsumerState<BasemapDownloadDialog> createState() =>
      _BasemapDownloadDialogState();
}

class _BasemapDownloadDialogState extends ConsumerState<BasemapDownloadDialog> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _errorMessage;
  bool _downloadMvtTiles = true;
  bool _isDownloadingMvt = false;
  double _mvtProgress = 0.0;
  String _currentStep = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen to zoning state changes
    ref.listen<ZoningState>(zoningStateProvider, (previous, next) {
      if (next is ZoningDownloadingBasemap) {
        if (mounted) {
          setState(() {
            _isDownloading = true;
            _downloadProgress = next.progress ?? 0.0;
            _errorMessage = null;
          });
        }
      } else if (next is ZoningBasemapReady) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _downloadProgress = 1.0;
            _errorMessage = null;
          });
        }
        // Invalidate basemap provider to force reload
        ref.invalidate(basemapProvider(widget.localityId));
        
        // If MVT download is enabled, start it now
        if (_downloadMvtTiles && mounted) {
          _startMvtDownload();
        } else {
          // Small delay to ensure provider refresh completes
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              widget.onDownloadComplete();
            }
          });
        }
      } else if (next is ZoningError) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = next.message;
          });
        }
      }
    });
    
    // Listen to MVT download progress
    ref.listen(
      mvtDownloadStateProvider(widget.localityId),
      (previous, next) {
        if (!mounted) return;
        
        setState(() {
          _mvtProgress = next.progress;
          
          if (next.isComplete) {
            _isDownloadingMvt = false;
            _currentStep = 'Imekamilika!';
            
            // Complete the download after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                widget.onDownloadComplete();
              }
            });
          } else if (next.error != null) {
            _isDownloadingMvt = false;
            _errorMessage = 'Hitilafu ya zoni zilizopo: ${next.error}';
          }
        });
      },
    );

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      title: Row(
        children: [
          Icon(Icons.map_outlined, color: AppColors.primary),
          const SizedBox(width: AppConstants.spacingSm),
          Text(
            'Pakua Ramani',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ramani ya mradi huu haijateremshwa. Unahitaji kuiunganisha kwenye mtandao ili kuipakua.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          
          // MVT tiles download checkbox
          if (!_isDownloading)
            CheckboxListTile(
              value: _downloadMvtTiles,
              onChanged: (value) {
                setState(() {
                  _downloadMvtTiles = value ?? true;
                });
              },
              title: Text(
                'Pakua Zoni zilizopo',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Pakua zoni zilizopiwa kwenye ramani kwa matumizi ya nje ya mtandao.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primary,
            ),

          if (_isDownloading || _isDownloadingMvt) ...[
            const SizedBox(height: AppConstants.spacingLg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current step indicator
                if (_currentStep.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
                    child: Text(
                      _currentStep,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                
                // Basemap progress
                if (_isDownloading) ...[
                  Text(
                    'Ramani: ${(_downloadProgress * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  LinearProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor:
                        isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ],
                
                // MVT progress
                if (_isDownloadingMvt) ...[
                  if (_isDownloading) const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Vipimo: ${(_mvtProgress * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  LinearProgressIndicator(
                    value: _mvtProgress,
                    backgroundColor:
                        isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                  ),
                ],
              ],
            ),
          ],

          if (_errorMessage != null) ...[
            const SizedBox(height: AppConstants.spacingLg),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!_isDownloading) ...[
          TextButton(
            onPressed: widget.onCancel,
            child: Text(
              'Ghairi',
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _errorMessage != null ? _retryDownload : _startDownload,
            icon: Icon(_errorMessage != null ? Icons.refresh : Icons.download),
            label: Text(_errorMessage != null ? 'Jaribu Tena' : 'Pakua'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  void _startDownload() async {
    setState(() {
      _currentStep = 'Inaanza kupakua...';
    });
    
    // Get access token from secure storage
    final authLocalDataSource = ref.read(authLocalDataSourceProvider);
    final accessToken = await authLocalDataSource.getAccessToken();

    // Start basemap download
    setState(() {
      _currentStep = 'Inapakua ramani...';
    });
    
    ref.read(zoningStateProvider.notifier).downloadBasemap(
      localityId: widget.localityId,
      accessToken: accessToken,
    );
  }

  void _retryDownload() {
    setState(() {
      _errorMessage = null;
    });
    _startDownload();
  }
  
  void _startMvtDownload() async {
    try {
      setState(() {
        _currentStep = 'Inapakua zone zilizopo...';
        _isDownloadingMvt = true;
        _mvtProgress = 0.0;
      });
      
      // Get the basemap to extract boundaries
      final basemapAsync = ref.read(basemapProvider(widget.localityId));
      
      await basemapAsync.when(
        data: (basemap) async {
          if (basemap == null || basemap.boundary.isEmpty) {
            throw Exception('Ramani haina mipaka, Jaribu tena.');
          }
          
          // Calculate bounds from boundary points
          double minLat = basemap.boundary[0].latitude;
          double maxLat = basemap.boundary[0].latitude;
          double minLng = basemap.boundary[0].longitude;
          double maxLng = basemap.boundary[0].longitude;
          
          for (final point in basemap.boundary) {
            if (point.latitude < minLat) minLat = point.latitude;
            if (point.latitude > maxLat) maxLat = point.latitude;
            if (point.longitude < minLng) minLng = point.longitude;
            if (point.longitude > maxLng) maxLng = point.longitude;
          }
          
          // Create LatLngBounds for MVT download
          final bounds = LatLngBounds(
            LatLng(minLat, minLng),
            LatLng(maxLat, maxLng),
          );
          
          debugPrint('===MVT Dialog: Starting download for bounds: $bounds');
          debugPrint('===MVT Dialog: Project ID: ${widget.projectId}');
          
          // Start MVT download
          final mvtNotifier = ref.read(
            mvtDownloadStateProvider(widget.localityId).notifier,
          );
          
          mvtNotifier.downloadTiles(
            projectId: widget.projectId,
            bounds: bounds,
            minZoom: 14,
            maxZoom: 16,
            isProposed: false,
          );
        },
        loading: () {
          throw Exception('Inasubiri ramani...');
        },
        error: (error, stack) {
          throw Exception('Hitilafu ya ramani: $error');
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloadingMvt = false;
          _errorMessage = 'Hitilafu ya kupakua zoni zilizopo: $e';
        });
      }
    }
  }
}
