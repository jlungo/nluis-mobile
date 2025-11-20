import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/overlay_loader.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/error_state_widget.dart';
import '../../../../../shared/widgets/grid_selector_widget.dart';
import '../../../../../shared/widgets/toggle_card_widget.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';
import '../../../../settings/presentation/providers/setup_providers.dart';

class FeatureMetadataSheet extends ConsumerStatefulWidget {
  final ZoningFeatureType featureType;
  final List<LatLng> coordinates;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;
  final Map<String, dynamic>? initialData; // For editing mode
  final VoidCallback? onEditCoordinates; // Callback to open coordinate editor

  const FeatureMetadataSheet({
    super.key,
    required this.featureType,
    required this.coordinates,
    required this.onSave,
    required this.onCancel,
    this.initialData,
    this.onEditCoordinates,
  });

  @override
  ConsumerState<FeatureMetadataSheet> createState() =>
      _FeatureMetadataSheetState();
}

class _FeatureMetadataSheetState extends ConsumerState<FeatureMetadataSheet> {
  final _formKey = GlobalKey<FormState>();
  final _plotNameController = TextEditingController();
  final _bufferController = TextEditingController();
  bool _isDraft = false;
  bool _isProposed = false;
  int? _selectedLandUseId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.initialData != null) {
      // Editing mode - load existing data
      final data = widget.initialData!;
      _plotNameController.text = data['plotName'] as String? ?? '';
      _bufferController.text = (data['buffer'] as double?)?.toString() ?? '0.0';
      _isDraft = data['isDraft'] as bool? ?? false;
      _isProposed = data['isProposed'] as bool? ?? false;
      _selectedLandUseId = data['landUseId'] as int?;
    } else {
      // New feature - load default buffer
      _loadBufferDefault();
    }
  }

  @override
  void dispose() {
    _plotNameController.dispose();
    _bufferController.dispose();
    super.dispose();
  }

  Future<void> _loadBufferDefault() async {
    final bufferDefaults = await ref.read(bufferDefaultsProvider.future);
    final featureTypeKey =
        widget.featureType.name == 'lineString'
            ? 'lineString'
            : widget.featureType.name;
    final defaultBuffer = bufferDefaults[featureTypeKey] ?? 0.0;
    _bufferController.text = defaultBuffer.toString();
  }

  Future<void> _handleSave() async {
    if (_selectedLandUseId == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      widget.onSave({
        'landUseId': _selectedLandUseId,
        'plotName':
            _plotNameController.text.trim().isEmpty
                ? null
                : _plotNameController.text.trim(),
        'buffer': double.tryParse(_bufferController.text) ?? 0.0,
        'isDraft': _isDraft,
        'isProposed': _isProposed,
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final landUsesAsync = ref.watch(landUsesProvider);
    final colors = ref.watch(landUseColorMapProvider);

    return OverlayLoader(
      isLoading: _isLoading,
      child: AppBottomSheet(
        title: widget.initialData != null ? 'Edit Feature' : '${_getFeatureTypeName(widget.featureType)} Details',
        titleIcon: widget.initialData != null ? Icons.edit_outlined : _iconFor(widget.featureType),
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.zero,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Land Use Selection Section
                Text(
                  'Select Land Use Type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Choose the land use classification for this zone',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Land Use Cards Grid
                landUsesAsync.when(
                  data: (landUses) {
                    if (landUses.isEmpty) {
                      return const EmptyStateWidget(
                        icon: Icons.inbox_outlined,
                        title: 'No land uses available',
                        subtitle: 'Please configure land uses in settings',
                      );
                    }
                    return GridSelectorWidget<int>(
                      items:
                          landUses
                              .map(
                                (lu) => GridSelectorItem<int>(
                                  value: lu.id,
                                  title: lu.name,
                                  subtitle: lu.description,
                                  color: colors[lu.id],
                                ),
                              )
                              .toList(),
                      selectedValue: _selectedLandUseId,
                      onSelected:
                          (value) => setState(() => _selectedLandUseId = value),
                    );
                  },
                  loading:
                      () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppConstants.spacingXl),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  error: (err, _) => ErrorStateWidget(message: err.toString()),
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Zone Name Input
                TextFormField(
                  controller: _plotNameController,
                  decoration: InputDecoration(
                    labelText: 'Zone Name',
                    hintText: 'Enter zone name (optional)',
                    prefixIcon: const Icon(Icons.label_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Buffer Input
                TextFormField(
                  controller: _bufferController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Buffer Distance (meters)',
                    hintText: 'Enter buffer in meters',
                    prefixIcon: const Icon(Icons.straighten),
                    suffixText: 'm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                    helperText: 'Default value loaded from settings',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Buffer is required';
                    }
                    final buffer = double.tryParse(value);
                    if (buffer == null) return 'Enter a valid number';
                    if (buffer < 0) return 'Buffer cannot be negative';
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Proposed Feature Toggle Card
                ToggleCardWidget(
                  value: _isProposed,
                  onChanged: (v) => setState(() => _isProposed = v),
                  title: 'Proposed Feature',
                  activeSubtitle: 'This is a proposed/future feature',
                  inactiveSubtitle: 'This is an existing feature',
                  activeIcon: Icons.upcoming_outlined,
                  inactiveIcon: Icons.check_box_outlined,
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Draft Toggle Card
                ToggleCardWidget(
                  value: _isDraft,
                  onChanged: (v) => setState(() => _isDraft = v),
                  title: 'Save as Draft',
                  activeSubtitle: 'Will be saved as draft for later editing',
                  inactiveSubtitle: 'Will be marked as final',
                  activeIcon: Icons.edit_note,
                  inactiveIcon: Icons.check_circle_outline,
                ),

                // Edit Coordinates button (only in edit mode)
                if (widget.initialData != null && widget.onEditCoordinates != null)
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: widget.onEditCoordinates,
                        icon: const Icon(Icons.edit_location_outlined),
                        label: const Text('Edit Coordinates'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: AppConstants.spacingMd,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                          side: BorderSide(
                            color: isDark ? AppColors.darkPrimary : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                    ],
                  ),

                const SizedBox(height: AppConstants.spacingLg),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        label: widget.initialData != null ? 'Update Feature' : 'Save Feature',
                        icon: widget.initialData != null ? Icons.update : Icons.check,
                        onPressed: _handleSave,
                        gradientColors: [
                          isDark ? AppColors.darkPrimary : AppColors.primary,
                          (isDark ? AppColors.darkPrimary : AppColors.primary)
                              .withValues(alpha: 0.8),
                        ],
                        height: 50,
                        isDisabled: _selectedLandUseId == null || _isLoading,
                      ),
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

  String _getFeatureTypeName(ZoningFeatureType type) {
    switch (type) {
      case ZoningFeatureType.point:
        return 'Point';
      case ZoningFeatureType.lineString:
        return 'Line';
      case ZoningFeatureType.polygon:
        return 'Polygon';
    }
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
