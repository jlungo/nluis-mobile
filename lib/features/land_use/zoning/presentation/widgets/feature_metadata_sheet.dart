import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';

class FeatureMetadataSheet extends ConsumerStatefulWidget {
  final ZoningFeatureType featureType;
  final List<LatLng> coordinates;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const FeatureMetadataSheet({
    super.key,
    required this.featureType,
    required this.coordinates,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<FeatureMetadataSheet> createState() => _FeatureMetadataSheetState();
}

class _FeatureMetadataSheetState extends ConsumerState<FeatureMetadataSheet> {
  final _formKey = GlobalKey<FormState>();
  final _plotIdController = TextEditingController();
  bool _isDraft = true;
  int? _selectedLandUseId;

  @override
  void dispose() {
    _plotIdController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_selectedLandUseId == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    widget.onSave({
      'landUseId': _selectedLandUseId,
      'plotId': _plotIdController.text.trim().isEmpty ? null : _plotIdController.text.trim(),
      'isDraft': _isDraft,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final landUsesAsync = ref.watch(landUsesProvider);
    final colors = ref.watch(landUseColorMapProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXl),
          topRight: Radius.circular(AppConstants.radiusXl),
        ),
      ),
      child: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Row(
                    children: [
                      Icon(
                        _iconFor(widget.featureType),
                        color: isDark ? AppColors.darkPrimary : AppColors.primary,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Add ${widget.featureType.name.toUpperCase()} Details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Land Uses list
                landUsesAsync.when(
                  data: (landUses) {
                    if (landUses.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(AppConstants.spacingMd),
                        child: Text('No land uses available'),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: landUses.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final lu = landUses[index];
                        final color = colors[lu.id] ?? Colors.grey;
                        return RadioListTile<int>(
                          value: lu.id,
                          groupValue: _selectedLandUseId,
                          onChanged: (val) => setState(() => _selectedLandUseId = val),
                          title: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(right: AppConstants.spacingSm),
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                              Expanded(child: Text(lu.name)),
                            ],
                          ),
                          subtitle: lu.description.isNotEmpty ? Text(lu.description) : null,
                        );
                      },
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppConstants.spacingMd),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    child: Text('Failed to load land uses: $err'),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Plot ID optional
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
                  child: TextFormField(
                    controller: _plotIdController,
                    decoration: const InputDecoration(
                      labelText: 'Plot ID (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Draft toggle
                SwitchListTile(
                  value: _isDraft,
                  onChanged: (v) => setState(() => _isDraft = v),
                  title: const Text('Save as draft'),
                ),

                // Actions
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedLandUseId == null ? null : _handleSave,
                          child: const Text('Save Feature'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  IconData _iconFor(ZoningFeatureType featureType) {
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
