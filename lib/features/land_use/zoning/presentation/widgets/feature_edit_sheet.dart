import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';
import 'coordinate_editor_map.dart';

class FeatureEditSheet extends ConsumerStatefulWidget {
  final ZoningFeature feature;
  final Function(ZoningFeature) onSave;

  const FeatureEditSheet({
    super.key,
    required this.feature,
    required this.onSave,
  });

  @override
  ConsumerState<FeatureEditSheet> createState() => _FeatureEditSheetState();
}

class _FeatureEditSheetState extends ConsumerState<FeatureEditSheet> {
  late TextEditingController _plotIdController;
  late TextEditingController _plotNameController;
  late TextEditingController _notesController;
  late int? _selectedLandUseId;
  late bool _isProposed;
  late bool _isDraft;
  late List<LatLng> _coordinates;

  @override
  void initState() {
    super.initState();
    _plotIdController = TextEditingController(text: widget.feature.plotId);
    _plotNameController = TextEditingController(text: widget.feature.plotName);
    _notesController = TextEditingController(text: widget.feature.notes);
    _selectedLandUseId = widget.feature.landUseId;
    _isProposed = widget.feature.isProposed;
    _isDraft = widget.feature.isDraft;
    _coordinates = List.from(widget.feature.coordinates);
  }

  @override
  void dispose() {
    _plotIdController.dispose();
    _plotNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedFeature = widget.feature.copyWith(
      plotId: _plotIdController.text.isEmpty ? null : _plotIdController.text,
      plotName: _plotNameController.text.isEmpty ? null : _plotNameController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      landUseId: _selectedLandUseId,
      isProposed: _isProposed,
      isDraft: _isDraft,
      coordinates: _coordinates,
      updatedAt: DateTime.now(),
      needsSync: true,
    );

    widget.onSave(updatedFeature);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final landUseAsync = ref.watch(landUsesProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXl),
          topRight: Radius.circular(AppConstants.radiusXl),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: AppConstants.spacingLg,
              right: AppConstants.spacingLg,
              top: AppConstants.spacingMd,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.spacingLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkDivider : AppColors.divider,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Header
                Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Text(
                        'Edit Feature',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Plot ID
                TextField(
                  controller: _plotIdController,
                  decoration: InputDecoration(
                    labelText: 'Plot ID',
                    hintText: 'Enter plot ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Plot Name
                TextField(
                  controller: _plotNameController,
                  decoration: InputDecoration(
                    labelText: 'Plot Name',
                    hintText: 'Enter plot name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),


                // Land Use Dropdown
                landUseAsync.when(
                  data: (landUses) {
                    return DropdownButtonFormField<int>(
                      value: _selectedLandUseId,
                      decoration: InputDecoration(
                        labelText: 'Land Use',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                      ),
                      items: landUses.map((landUse) {
                        return DropdownMenuItem<int>(
                          value: landUse.id,
                          child: Text(landUse.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLandUseId = value;
                        });
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, _) => const Text('Error loading land uses'),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Notes
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Enter notes',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Is Proposed Toggle
                SwitchListTile(
                  title: Text(
                    'Proposed Feature',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Mark as proposed or existing',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  value: _isProposed,
                  onChanged: (value) {
                    setState(() {
                      _isProposed = value;
                    });
                  },
                ),

                const SizedBox(height: AppConstants.spacingSm),

                // Is Draft Toggle
                SwitchListTile(
                  title: Text(
                    'Draft',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Keep as draft (not ready to save)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  value: _isDraft,
                  onChanged: widget.feature.uploaded ? null : (value) {
                    setState(() {
                      _isDraft = value;
                    });
                  },
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Coordinates Section - Simple card with button
                Card(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: isDark ? AppColors.darkPrimary : AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppConstants.spacingSm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coordinates',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_coordinates.length} ${_coordinates.length == 1 ? 'point' : 'points'}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        SizedBox(
                          width: double.infinity,
                          child: Opacity(
                            opacity: widget.feature.uploaded ? 0.5 : 1.0,
                            child: AbsorbPointer(
                              absorbing: widget.feature.uploaded,
                              child: AppButton(
                                label: 'Edit Coordinates',
                                onPressed: () {
                                  _openCoordinateEditor();
                                },
                                gradientColors: [
                                  AppColors.primary.withValues(alpha: 0.1),
                                  AppColors.primary.withValues(alpha: 0.2),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: AppButton(
                        label: 'Save Changes',
                        onPressed: _saveChanges,
                        gradientColors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
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

  Future<void> _openCoordinateEditor() async {
    final result = await Navigator.of(context).push<List<LatLng>>(
      MaterialPageRoute(
        builder: (context) => CoordinateEditorMap(
          feature: widget.feature.copyWith(
            coordinates: _coordinates,
          ),
          onSave: (updatedCoordinates) {
            Navigator.of(context).pop(updatedCoordinates);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _coordinates = result;
      });
    }
  }
}
