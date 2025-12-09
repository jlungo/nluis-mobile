import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';

/// Manual coordinate entry sheet for CCRO parcels (polygon only)
/// Simplified version using standard Flutter widgets
class ManualParcelEntrySheet extends StatefulWidget {
  final Function(List<LatLng> coordinates) onSave;
  final VoidCallback onCancel;

  const ManualParcelEntrySheet({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<ManualParcelEntrySheet> createState() =>
      _ManualParcelEntrySheetState();
}

class _ManualParcelEntrySheetState extends State<ManualParcelEntrySheet> {
  final List<LatLng> _coordinates = [];

  int get _minPointsRequired => 3; // Parcels are always polygons

  bool get _hasMinPoints => _coordinates.length >= _minPointsRequired;

  void _addCoordinate() async {
    final result = await showDialog<LatLng>(
      context: context,
      builder: (context) => _CoordinateInputDialog(
        pointNumber: _coordinates.length + 1,
      ),
    );

    if (result != null) {
      setState(() {
        _coordinates.add(result);
      });
    }
  }

  void _editCoordinate(int index) async {
    final coord = _coordinates[index];
    final result = await showDialog<LatLng>(
      context: context,
      builder: (context) => _CoordinateInputDialog(
        pointNumber: index + 1,
        initialCoord: coord,
      ),
    );

    if (result != null) {
      setState(() {
        _coordinates[index] = result;
      });
    }
  }

  void _removeCoordinate(int index) {
    setState(() {
      _coordinates.removeAt(index);
    });
  }

  void _saveCoordinates() {
    if (!_hasMinPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parcel must have at least 3 points'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.onSave(_coordinates);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLg),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingSm,
            ),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancel,
                ),
                Expanded(
                  child: Text(
                    'Ingiza Kuratibu za Kipande',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              children: [
                // Info card
                Card(
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.primary,
                        ),
                        const SizedBox(width: AppConstants.spacingSm),
                        Expanded(
                          child: Text(
                            'Ingiza kuratibu angalau 3 kuunda kipande. Coordinates zinatakiwa ziwe WGS84 (lat/lng).',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Coordinates list header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coordinates (${_coordinates.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_coordinates.isNotEmpty)
                      Text(
                        'Min: $_minPointsRequired',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _hasMinPoints
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingSm),

                // Coordinates list
                if (_coordinates.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingXl),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant)
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(
                        color: isDark ? AppColors.darkDivider : AppColors.divider,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Hakuna kuratibu. Bofya "Ongeza Coordinate" kuanza.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ..._coordinates.asMap().entries.map((entry) {
                    final index = entry.key;
                    final coord = entry.value;
                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: AppConstants.spacingSm),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary)
                              .withValues(alpha: 0.1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          'Lat: ${coord.latitude.toStringAsFixed(6)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                        subtitle: Text(
                          'Lng: ${coord.longitude.toStringAsFixed(6)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _editCoordinate(index),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _removeCoordinate(index),
                              tooltip: 'Delete',
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: AppConstants.spacingMd),

                // Add coordinate button
                OutlinedButton.icon(
                  onPressed: _addCoordinate,
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text('Ongeza Coordinate'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Save button
                ElevatedButton(
                  onPressed: _hasMinPoints ? _saveCoordinates : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Hifadhi'),
                ),

                const SizedBox(height: AppConstants.spacingSm),

                // Cancel button
                OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Ghairi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for inputting a single coordinate
class _CoordinateInputDialog extends StatefulWidget {
  final int pointNumber;
  final LatLng? initialCoord;

  const _CoordinateInputDialog({
    required this.pointNumber,
    this.initialCoord,
  });

  @override
  State<_CoordinateInputDialog> createState() => _CoordinateInputDialogState();
}

class _CoordinateInputDialogState extends State<_CoordinateInputDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _latController;
  late final TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController(
      text: widget.initialCoord?.latitude.toStringAsFixed(6) ?? '',
    );
    _lngController = TextEditingController(
      text: widget.initialCoord?.longitude.toStringAsFixed(6) ?? '',
    );
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  String? _validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }

    if (number < -90 || number > 90) {
      return 'Latitude must be between -90 and 90';
    }

    return null;
  }

  String? _validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }

    if (number < -180 || number > 180) {
      return 'Longitude must be between -180 and 180';
    }

    return null;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final lat = double.parse(_latController.text);
      final lng = double.parse(_lngController.text);
      Navigator.pop(context, LatLng(lat, lng));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Coordinate ${widget.pointNumber}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: '-6.xxxxxx',
                prefixIcon: Icon(Icons.north),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              ],
              validator: _validateLatitude,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextFormField(
              controller: _lngController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: '39.xxxxxx',
                prefixIcon: Icon(Icons.east),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              ],
              validator: _validateLongitude,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ghairi'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Hifadhi'),
        ),
      ],
    );
  }
}
