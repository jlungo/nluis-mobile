import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/zoning_providers.dart';
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
        // Small delay to ensure provider refresh completes
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            widget.onDownloadComplete();
          }
        });
      } else if (next is ZoningError) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = next.message;
          });
        }
      }
    });

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

          if (_isDownloading) ...[
            const SizedBox(height: AppConstants.spacingLg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inapakua... ${(_downloadProgress * 100).toStringAsFixed(0)}%',
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
    // Get access token from secure storage
    final authLocalDataSource = ref.read(authLocalDataSourceProvider);
    final accessToken = await authLocalDataSource.getAccessToken();

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
}
