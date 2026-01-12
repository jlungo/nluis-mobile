import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/toggle_card_widget.dart';
import '../../../../../shared/features/spatial/data/services/coordinate_converter.dart';
import '../../domain/entities/zoning_feature.dart';

/// Fullscreen bottom sheet for manual coordinate entry
class ManualCoordinateEntrySheet extends StatefulWidget {
  final ZoningFeatureType featureType;
  final Function(
    String zoneName,
    int srid,
    List<List<double>> coordinates,
    bool isDraft,
  )
  onSave;
  final VoidCallback onCancel;

  const ManualCoordinateEntrySheet({
    super.key,
    required this.featureType,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<ManualCoordinateEntrySheet> createState() =>
      _ManualCoordinateEntrySheetState();
}

class _ManualCoordinateEntrySheetState
    extends State<ManualCoordinateEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _zoneNameController = TextEditingController();
  final MapController _mapController = MapController();

  int _selectedSrid = 4326;
  final List<List<double>> _coordinates = [];
  bool _showMap = false;
  bool _isDraft = false;

  @override
  void initState() {
    super.initState();
    CoordinateConverter.initialize();
  }

  @override
  void dispose() {
    _zoneNameController.dispose();
    super.dispose();
  }

  int get _minPointsRequired {
    switch (widget.featureType) {
      case ZoningFeatureType.point:
        return 1;
      case ZoningFeatureType.lineString:
        return 2;
      case ZoningFeatureType.polygon:
        return 3;
    }
  }

  bool get _hasMinPoints => _coordinates.length >= _minPointsRequired;

  String _getFeatureTypeName() {
    switch (widget.featureType) {
      case ZoningFeatureType.point:
        return 'Point';
      case ZoningFeatureType.lineString:
        return 'Line';
      case ZoningFeatureType.polygon:
        return 'Polygon';
    }
  }

  void _addCoordinate() async {
    final result = await showDialog<Map<String, double>>(
      context: context,
      builder:
          (context) => _CoordinateInputDialog(
            srid: _selectedSrid,
            pointNumber: _coordinates.length + 1,
          ),
    );

    if (result != null) {
      setState(() {
        _coordinates.add([result['x']!, result['y']!]);
      });
      _updateMapView();
    }
  }

  void _editCoordinate(int index) async {
    final coord = _coordinates[index];
    final result = await showDialog<Map<String, double>>(
      context: context,
      builder:
          (context) => _CoordinateInputDialog(
            srid: _selectedSrid,
            pointNumber: index + 1,
            initialX: coord[0],
            initialY: coord[1],
          ),
    );

    if (result != null) {
      setState(() {
        _coordinates[index] = [result['x']!, result['y']!];
      });
      _updateMapView();
    }
  }

  void _deleteCoordinate(int index) {
    setState(() {
      _coordinates.removeAt(index);
    });
    _updateMapView();
  }

  void _reorderCoordinates(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _coordinates.removeAt(oldIndex);
      _coordinates.insert(newIndex, item);
    });
    _updateMapView();
  }

  void _updateMapView() {
    if (_coordinates.isEmpty || !_showMap) return;

    try {
      final wgs84Points =
          _coordinates.map((point) {
            return CoordinateConverter.toWGS84(
              x: point[0],
              y: point[1],
              fromSrid: _selectedSrid,
            );
          }).toList();

      if (wgs84Points.isNotEmpty) {
        final lats = wgs84Points.map((p) => p.latitude).toList();
        final lngs = wgs84Points.map((p) => p.longitude).toList();

        final bounds = LatLngBounds(
          LatLng(
            lats.reduce((a, b) => a < b ? a : b),
            lngs.reduce((a, b) => a < b ? a : b),
          ),
          LatLng(
            lats.reduce((a, b) => a > b ? a : b),
            lngs.reduce((a, b) => a > b ? a : b),
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _mapController.fitCamera(
              CameraFit.bounds(
                bounds: bounds,
                padding: const EdgeInsets.all(50),
              ),
            );
          }
        });
      }
    } catch (e) {
      // Error converting coordinates
    }
  }

  void _handleSave() {
    if (!_hasMinPoints) return;

    final zoneName = _zoneNameController.text.trim();
    widget.onSave(
      zoneName.isEmpty ? 'Zone ${_coordinates.length}' : zoneName,
      _selectedSrid,
      List.from(_coordinates),
      _isDraft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBottomSheet(
      title: 'Ingiza Coordinate - ${_getFeatureTypeName()}',
      titleIcon: Icons.add_location_alt,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.zero,
      actions: [
        // View toggle
        IconButton(
          icon: Icon(_showMap ? Icons.list : Icons.map),
          onPressed: () {
            setState(() => _showMap = !_showMap);
            if (_showMap) _updateMapView();
          },
          tooltip: _showMap ? 'Orodha' : 'Ramani',
        ),
      ],
      child: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            color:
                _hasMinPoints
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  _hasMinPoints ? Icons.check_circle : Icons.info_outline,
                  size: 20,
                  color: _hasMinPoints ? AppColors.success : AppColors.warning,
                ),
                const SizedBox(width: AppConstants.spacingXs),
                Text(
                  'Coordinates: ${_coordinates.length} / $_minPointsRequired ${_hasMinPoints ? "✓" : ""}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        _hasMinPoints ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child:
                _showMap
                    ? _buildMapView(isDark)
                    : _buildFormView(theme, isDark),
          ),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Draft toggle
                ToggleCardWidget(
                  value: _isDraft,
                  onChanged: (v) => setState(() => _isDraft = v),
                  title: 'Save as Draft',
                  activeSubtitle: 'Will be saved as draft for later editing',
                  inactiveSubtitle: 'Will be marked as final',
                  activeIcon: Icons.edit_note,
                  inactiveIcon: Icons.check_circle_outline,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addCoordinate,
                        icon: const Icon(Icons.add_location),
                        label: const Text('Ongeza'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        label: 'Hifadhi',
                        icon: Icons.save,
                        onPressed: _handleSave,
                        gradientColors: [
                          isDark ? AppColors.darkPrimary : AppColors.primary,
                          (isDark ? AppColors.darkPrimary : AppColors.primary)
                              .withValues(alpha: 0.8),
                        ],
                        height: 50,
                        isDisabled: !_hasMinPoints,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(ThemeData theme, bool isDark) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone Name
            TextFormField(
              controller: _zoneNameController,
              decoration: InputDecoration(
                labelText: 'Jina la eneo (optional)',
                hintText: 'Andika jina la eneo',
                prefixIcon: const Icon(Icons.label),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // SRID Selector - Custom Dropdown
            DropdownButtonFormField<int>(
              initialValue: _selectedSrid,
              decoration: InputDecoration(
                labelText: 'Coordinate System',
                prefixIcon: const Icon(Icons.public),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                enabled: _coordinates.isEmpty,
              ),
              isExpanded: true,
              menuMaxHeight: 300,
              items:
                  CoordinateConverter.getSupportedSrids().map((sridInfo) {
                    return DropdownMenuItem<int>(
                      value: sridInfo.srid,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              sridInfo.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            // Text(
                            //   sridInfo.description,
                            //   style: theme.textTheme.bodySmall?.copyWith(
                            //     color: isDark
                            //         ? AppColors.darkTextSecondary
                            //         : AppColors.textSecondary,
                            //     fontSize: 11,
                            //   ),
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: 1,
                            // ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
              onChanged:
                  _coordinates.isEmpty
                      ? (value) {
                        if (value != null) {
                          setState(() => _selectedSrid = value);
                        }
                      }
                      : null,
              hint: const Text('Chagua mfumo wa coordinate'),
            ),
            if (_coordinates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.spacingSm,
                  top: AppConstants.spacingXs,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: AppConstants.spacingXs),
                    Expanded(
                      child: Text(
                        'Hauwezi kubadilisha mfumo wa coordinate baada ya kuingiza coordinates',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppConstants.spacingLg),

            // Coordinates List
            Text(
              'Coordinates',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            if (_coordinates.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_location_alt_outlined,
                        size: 48,
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Text(
                        'Hakuna coordinates zilizoongezwa',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Bonyeza "Ingiza Coordinates" kuanza',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _coordinates.length,
                onReorder: _reorderCoordinates,
                itemBuilder: (context, index) {
                  final coord = _coordinates[index];
                  final isMetric = _selectedSrid != 4326;
                  return Card(
                    key: ValueKey(index),
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.spacingSm,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        isMetric
                            ? 'E: ${coord[0].toStringAsFixed(2)}  N: ${coord[1].toStringAsFixed(2)}'
                            : 'Lng: ${coord[0].toStringAsFixed(6)}  Lat: ${coord[1].toStringAsFixed(6)}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      subtitle: Text(
                        isMetric
                            ? 'Easting / Northing'
                            : 'Longitude / Latitude',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editCoordinate(index),
                            color:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () => _deleteCoordinate(index),
                            color: Colors.red,
                          ),
                          const Icon(Icons.drag_handle),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(bool isDark) {
    if (_coordinates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            const Text('Ongeza coordinates kuona kwenye ramani'),
          ],
        ),
      );
    }

    try {
      final wgs84Points =
          _coordinates.map((point) {
            return CoordinateConverter.toWGS84(
              x: point[0],
              y: point[1],
              fromSrid: _selectedSrid,
            );
          }).toList();

      return FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: wgs84Points.first, initialZoom: 15),
        children: [
          TileLayer(
            urlTemplate: AppConstants.mapTileStandard,
            userAgentPackageName: 'com.nluis.app',
          ),
          if (widget.featureType == ZoningFeatureType.polygon &&
              wgs84Points.length >= 3)
            PolygonLayer(
              polygons: [
                Polygon(
                  points: [...wgs84Points, wgs84Points.first],
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: 0.3),
                  borderColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  borderStrokeWidth: 3,
                ),
              ],
            ),
          if (widget.featureType == ZoningFeatureType.lineString &&
              wgs84Points.length >= 2)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: wgs84Points,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  strokeWidth: 3,
                ),
              ],
            ),
          MarkerLayer(
            markers:
                wgs84Points.asMap().entries.map((entry) {
                  return Marker(
                    point: entry.value,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      );
    } catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppConstants.spacingMd),
            Text('Hitilafu kuonyesha ramani: $e'),
          ],
        ),
      );
    }
  }
}

/// Dialog for entering a single coordinate
class _CoordinateInputDialog extends StatefulWidget {
  final int srid;
  final int pointNumber;
  final double? initialX;
  final double? initialY;

  const _CoordinateInputDialog({
    required this.srid,
    required this.pointNumber,
    this.initialX,
    this.initialY,
  });

  @override
  State<_CoordinateInputDialog> createState() => _CoordinateInputDialogState();
}

class _CoordinateInputDialogState extends State<_CoordinateInputDialog> {
  late final TextEditingController _xController;
  late final TextEditingController _yController;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _xController = TextEditingController(
      text: widget.initialX?.toStringAsFixed(6) ?? '',
    );
    _yController = TextEditingController(
      text: widget.initialY?.toStringAsFixed(6) ?? '',
    );
    _xController.addListener(_validateCoordinates);
    _yController.addListener(_validateCoordinates);
    _validateCoordinates();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  void _validateCoordinates() {
    final xText = _xController.text.trim();
    final yText = _yController.text.trim();

    if (xText.isEmpty || yText.isEmpty) {
      setState(() => _isValid = false);
      return;
    }

    final x = double.tryParse(xText);
    final y = double.tryParse(yText);

    if (x == null || y == null) {
      setState(() => _isValid = false);
      return;
    }

    // Validate X coordinate
    final xError = CoordinateConverter.validateCoordinate(
      x,
      widget.srid,
      false,
    );
    // Validate Y coordinate
    final yError = CoordinateConverter.validateCoordinate(y, widget.srid, true);

    setState(() => _isValid = xError == null && yError == null);
  }

  String _getCoordinateLabel(String axis) {
    if (widget.srid == 4326) {
      return axis == 'X' ? 'Longitude' : 'Latitude';
    } else {
      return axis == 'X' ? 'Easting (X)' : 'Northing (Y)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Coordinate #${widget.pointNumber}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextFormField(
              controller: _xController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: _getCoordinateLabel('X'),
                border: const OutlineInputBorder(),
              ),
              inputFormatters: [
                // Allow digits, decimal point, and minus sign (for negative numbers)
                FilteringTextInputFormatter.allow(
                  RegExp(r'^-?[0-9]*\.?[0-9]*'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
            TextFormField(
              controller: _yController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: _getCoordinateLabel('Y'),
                border: const OutlineInputBorder(),
              ),
              inputFormatters: [
                // Allow digits, decimal point, and minus sign (for negative numbers)
                FilteringTextInputFormatter.allow(
                  RegExp(r'^-?[0-9]*\.?[0-9]*'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            if (!_isValid &&
                _xController.text.isNotEmpty &&
                _yController.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: AppConstants.spacingSm),
                    const Expanded(
                      child: Text(
                        'Coordinates sio sahihi',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppConstants.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ghairi'),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                ElevatedButton(
                  onPressed:
                      _isValid
                          ? () {
                            final x = double.parse(_xController.text.trim());
                            final y = double.parse(_yController.text.trim());
                            Navigator.pop(context, {'x': x, 'y': y});
                          }
                          : null,
                  child: const Text('Ongeza'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
