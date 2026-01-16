import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/zoning_map.dart';
import '../widgets/map_features_sheet.dart';
import '../widgets/feature_details_sheet.dart';
import '../providers/zoning_providers.dart';
import '../widgets/basemap_download_dialog.dart';
import '../widgets/input_method_selection_sheet.dart';
import '../../../../../shared/features/spatial/presentation/widgets/location_permission_dialog.dart';
import '../../../../../shared/widgets/page_empty_state.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
// import '../../../../../shared/widgets/offline_banner.dart';
import '../../domain/entities/zoning_feature.dart';

class ZoningPage extends ConsumerStatefulWidget {
  final String projectId;
  final String localityId;

  const ZoningPage({
    super.key,
    required this.projectId,
    required this.localityId,
  });

  @override
  ConsumerState<ZoningPage> createState() => _ZoningPageState();
}

class _ZoningPageState extends ConsumerState<ZoningPage> {
  bool _isCreatingFeature = false;
  double _sheetSize = 0.1;
  bool _fabExpanded = false;
  ZoningFeatureType? _activeFeatureType;
  InputMethod? _selectedInputMethod;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeZoning();
    });
  }

  Future<void> _initializeZoning() async {
    // Preload land-uses from API when online
    final onlineStatus = ref.read(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => false,
    );

    if (isOnline) {
      // Trigger land-use fetch (this will be cached by Riverpod)
      ref.read(landUsesProvider);
    }

    // Check if basemap is downloaded
    final isDownloaded = await ref.read(
      basemapDownloadStatusProvider(widget.localityId).future,
    );

    if (!isDownloaded) {
      if (mounted) {
        _showBasemapDownloadDialog();
      }
      return;
    }

    // Check location permissions
    final hasPermission = await ref.read(locationPermissionProvider.future);
    if (!hasPermission) {
      if (mounted) {
        _showLocationPermissionDialog();
      }
    }
  }

  void _showBasemapDownloadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => BasemapDownloadDialog(
            projectId: widget.projectId,
            localityId: widget.localityId,
            onDownloadComplete: () {
              Navigator.of(context).pop();
              _checkLocationPermissions();
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => LocationPermissionDialog(
            onPermissionGranted: () {
              Navigator.of(context).pop();
            },
            onPermissionDenied: () {
              Navigator.of(context).pop();
              SnackBarUtils.showWarning(
                context,
                'Ruhusa za mahali zimeshindwa. Utaweza kuongeza vipengele kwa mikono tu.',
              );
            },
          ),
    );
  }

  Future<void> _checkLocationPermissions() async {
    final hasPermission = await ref.read(locationPermissionProvider.future);
    if (!hasPermission && mounted) {
      _showLocationPermissionDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final onlineStatus = ref.watch(onlineStatusProvider);
    // final isOnline = onlineStatus.maybeWhen(
    //   data: (value) => value,
    //   orElse: () => true,
    // );

    final basemapAsync = ref.watch(basemapProvider(widget.localityId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: basemapAsync.when(
          data: (basemap) {
            if (basemap == null) {
              return EmptyPageState(
                context: context,
                isDark: isDark,
                heading: 'Ramani haijapakuliwa',
                description:
                    'Tafadhali pakua ramani ya mradi huu ili kuanza kazi ya zoning.',
                actionButton: ElevatedButton.icon(
                  onPressed: _showBasemapDownloadDialog,
                  icon: const Icon(Icons.download),
                  label: const Text('Pakua Ramani'),
                ),
              );
            }
            // Watch the features for this project
            final featuresAsync = ref.watch(
              zoningFeaturesProvider(widget.projectId),
            );
            
            return featuresAsync.when(
              data:
                  (features) => Stack(
                    children: [
                      // Map layer
                      ZoningMap(
                        projectId: widget.projectId,
                        basemap: basemap,
                        startFeatureCreation: _activeFeatureType,
                        inputMethod: _selectedInputMethod?.name,
                        onCreatingFeatureChanged: (isCreating) {
                          setState(() {
                            _isCreatingFeature = isCreating;
                            if (!isCreating) {
                              _activeFeatureType = null;
                              _selectedInputMethod = null;
                            }
                          });
                        },
                      ),
            
                      // bottom sheet - only show when NOT creating/editing feature
                      if (!_isCreatingFeature)
                        MapFeaturesSheet(
                          features: features,
                          onSheetSizeChanged: (size) {
                            setState(() {
                              _sheetSize = size;
                            });
                          },
                          onFeatureTap: (feature) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (context) => FeatureDetailsSheet(
                                    feature: feature,
                                    onEdit: (updatedFeature) {
                                      ref
                                          .read(
                                            zoningStateProvider.notifier,
                                          )
                                          .updateFeature(updatedFeature);
                                      ref.invalidate(
                                        zoningFeaturesProvider(
                                          widget.projectId,
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      ref
                                          .read(
                                            zoningStateProvider.notifier,
                                          )
                                          .deleteFeature(
                                            feature.clientUuid,
                                          );
                                      ref.invalidate(
                                        zoningFeaturesProvider(
                                          widget.projectId,
                                        ),
                                      );
                                    },
                                  ),
                            );
                          },
                          onFeatureEdit: (feature) {
                            // Editing is handled in the feature details sheet
                          },
                          onFeatureDelete: (feature) {
                            ref
                                .read(zoningStateProvider.notifier)
                                .deleteFeature(feature.clientUuid);
                            ref.invalidate(
                              zoningFeaturesProvider(widget.projectId),
                            );
                            SnackBarUtils.showSuccess(
                              context,
                              'Feature deleted',
                            );
                          },
                        ),
            
                      // FAB positioned based on bottom sheet
                      if (!_isCreatingFeature)
                        _buildNewFeatureFAB(basemap),
                    ],
                  ),
              loading:
                  () => ZoningMap(
                    projectId: widget.projectId,
                    basemap: basemap,
                  ),
              error:
                  (error, stack) => ZoningMap(
                    projectId: widget.projectId,
                    basemap: basemap,
                  ),
            );
          },
          loading: () => _buildLoadingState(theme, isDark),
          error:
              (error, stack) => EmptyPageState(
                context: context,
                isError: true,
                isDark: isDark,
                heading: 'Hitilafu imetokea',
                description: error.toString(),
                actionButton: ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(basemapProvider(widget.projectId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Jaribu Tena'),
                ),
              ),
        ),
      );
  }

  Widget _buildLoadingState(ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Inapakia ramani...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewFeatureFAB(dynamic basemap) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeightPx = screenHeight * _sheetSize;

    // Hide FAB when sheet is at center or higher
    final shouldHideFAB = _sheetSize >= 0.5;

    // Calculate bottom position: above the sheet with some padding
    final bottomPosition = sheetHeightPx + AppConstants.spacingMd;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      bottom: bottomPosition,
      right: AppConstants.spacingMd,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: shouldHideFAB ? 0.0 : 1.0,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: shouldHideFAB ? 0.0 : 1.0,
          child: _buildExpandableFab(basemap),
        ),
      ),
    );
  }

  Widget _buildExpandableFab(dynamic basemap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          _buildSmallFab(
            icon: Icons.place,
            label: 'Point',
            onTap: () {
              setState(() => _fabExpanded = false);
              _showInputMethodSelection(ZoningFeatureType.point);
            },
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _buildSmallFab(
            icon: Icons.timeline,
            label: 'Line',
            onTap: () {
              setState(() => _fabExpanded = false);
              _showInputMethodSelection(ZoningFeatureType.lineString);
            },
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _buildSmallFab(
            icon: Icons.crop_free,
            label: 'Polygon',
            onTap: () {
              setState(() => _fabExpanded = false);
              _showInputMethodSelection(ZoningFeatureType.polygon);
            },
          ),
          const SizedBox(height: 12),
        ],
        FloatingActionButton(
          onPressed: () => setState(() => _fabExpanded = !_fabExpanded),
          foregroundColor: isDark ? AppColors.darkPrimary : AppColors.surfaceVariant,
          backgroundColor:
              isDark ? AppColors.darkSurfaceVariant : AppColors.primary,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: _fabExpanded ? 0.125 : 0.0,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallFab({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FloatingActionButton.extended(
      heroTag: '${label}_fab',
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      elevation: 2,
      foregroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
      backgroundColor:
          isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
    );
  }

  void _showInputMethodSelection(ZoningFeatureType featureType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => InputMethodSelectionSheet(
        featureType: featureType,
        onMethodSelected: (inputMethod) {
          setState(() {
            _selectedInputMethod = inputMethod;
            _activeFeatureType = featureType;
          });
        },
      ),
    );
  }
}
