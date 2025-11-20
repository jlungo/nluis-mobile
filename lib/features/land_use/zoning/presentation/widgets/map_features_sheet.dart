import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';

class MapFeaturesSheet extends ConsumerStatefulWidget {
  final List<ZoningFeature> features;
  final Function(ZoningFeature) onFeatureTap;
  final Function(ZoningFeature) onFeatureEdit;
  final Function(ZoningFeature) onFeatureDelete;
  final ValueChanged<double>? onSheetSizeChanged;

  const MapFeaturesSheet({
    super.key,
    required this.features,
    required this.onFeatureTap,
    required this.onFeatureEdit,
    required this.onFeatureDelete,
    this.onSheetSizeChanged,
  });

  @override
  ConsumerState<MapFeaturesSheet> createState() => _MapFeaturesSheetState();
}

class _MapFeaturesSheetState extends ConsumerState<MapFeaturesSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _sheetSize = 0.3;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.isAttached) {
        setState(() {
          _sheetSize = _controller.size;
        });
        widget.onSheetSizeChanged?.call(_controller.size);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.1, 0.3, 0.6, 0.9],
      snapAnimationDuration: const Duration(milliseconds: 300),
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              _buildDragHandle(isDark),

              // Header
              _buildHeader(),

              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),

              // Features list
              Expanded(
                child:
                    widget.features.isEmpty
                        ? _buildEmptyState(scrollController)
                        : _buildFeaturesList(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkDivider : AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (!_controller.isAttached) return;

        final height = MediaQuery.of(context).size.height;
        final delta = -details.primaryDelta! / height; // to drag up expands
        final next = (_controller.size + delta).clamp(0.1, 0.9);
        _controller.jumpTo(next);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        child: Row(
          children: [
            Icon(Icons.layers, color: isDark ? AppColors.darkPrimary : AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary
                    ),
                  ),
                  Text(
                    '${widget.features.length} feature${widget.features.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (_sheetSize > 0.5)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (_controller.isAttached) {
                    _controller.animateTo(
                      0.3,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.layers_clear, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No features yet',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to create your first feature',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(ScrollController scrollController) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      itemCount: widget.features.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final feature = widget.features[index];
        return _buildFeatureCard(feature);
      },
    );
  }

  Widget _buildFeatureCard(ZoningFeature feature) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final landUseMap = ref.watch(landUseMapProvider);
    final landUseColors = ref.watch(landUseColorMapProvider);
    
    // Get land use entity and color
    final landUse = feature.landUseId != null ? landUseMap[feature.landUseId!] : null;
    final color =
        feature.landUseId != null
            ? (landUseColors[feature.landUseId!] ?? Colors.grey)
            : Colors.grey;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: color,
              width: 4,
            ),
          ),
        ),
        child: InkWell(
          onTap: () => widget.onFeatureTap(feature),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getFeatureTypeIcon(feature.featureType),
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.plotName?.isNotEmpty == true
                                ? feature.plotName!
                                : feature.plotId ??
                                    'Feature ${feature.clientUuid.substring(0, 8)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          if (landUse != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              landUse.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (feature.isDraft)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Draft',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (feature.needsSync)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.sync_problem,
                                    size: 16,
                                    color: AppColors.warning,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFeatureTypeIcon(ZoningFeatureType featureType) {
    switch (featureType) {
      case ZoningFeatureType.point:
        return Icons.place;
      case ZoningFeatureType.lineString:
        return Icons.timeline;
      case ZoningFeatureType.polygon:
        return Icons.crop_free;
    }
  }
}
