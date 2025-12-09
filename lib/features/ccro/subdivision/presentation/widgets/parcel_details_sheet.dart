import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/form/form_fields/text_form_field_widget.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../data/local/database.dart' as db;
import '../../../dashboard/presentation/providers/ccro_providers.dart';

/// Full-screen bottom sheet for entering parcel details (Majirani)
/// NO land use type selection - zone IS the land use
class ParcelDetailsSheet extends ConsumerStatefulWidget {
  final List<LatLng> coordinates;
  final int zoneId;
  final int localityId;
  final String? applicationId;
  final Function(db.Parcel, String) onSave;
  final VoidCallback onCancel;

  const ParcelDetailsSheet({
    super.key,
    required this.coordinates,
    required this.zoneId,
    required this.localityId,
    this.applicationId,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<ParcelDetailsSheet> createState() => _ParcelDetailsSheetState();
}

class _ParcelDetailsSheetState extends ConsumerState<ParcelDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _northController = TextEditingController();
  final _southController = TextEditingController();
  final _eastController = TextEditingController();
  final _westController = TextEditingController();
  bool _isDraft = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _northController.dispose();
    _southController.dispose();
    _eastController.dispose();
    _westController.dispose();
    super.dispose();
  }

  String _coordinatesToGeoJson() {
    final coordList =
        widget.coordinates.map((c) => [c.longitude, c.latitude]).toList();

    // Close the polygon if not already closed
    if (coordList.first[0] != coordList.last[0] ||
        coordList.first[1] != coordList.last[1]) {
      coordList.add(coordList.first);
    }

    final geoJson = {
      'type': 'Polygon',
      'coordinates': [coordList],
      'srid': 4326,
    };

    return jsonEncode(geoJson);
  }

  double _calculateArea() {
    final coords = widget.coordinates;
    if (coords.length < 3) return 0.0;

    double area = 0.0;
    for (int i = 0; i < coords.length; i++) {
      final j = (i + 1) % coords.length;
      area += coords[i].longitude * coords[j].latitude;
      area -= coords[j].longitude * coords[i].latitude;
    }
    area = (area.abs() / 2.0);

    // Convert to square meters (rough approximation)
    // 1 degree ≈ 111,320 meters at equator
    return area * 111320 * 111320;
  }

  Future<void> _saveParcel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ccroRepositoryProvider);
      final clientId = const Uuid().v4();
      final geometry = _coordinatesToGeoJson();

      // Create or get application ID
      String appId = widget.applicationId ?? '';

      if (appId.isEmpty) {
        // Create a new application if none exists
        appId = const Uuid().v4();
        final applicationData = {
          'client_id': appId,
          'zone_snapshot': widget.zoneId,
          'locality': widget.localityId,
          'applicant': '', // Will be filled in applicant step
          'status': 'draft',
        };

        final appResult = await repository.saveLocalApplication(
          applicationData,
        );

        await appResult.fold(
          (failure) {
            throw Exception(failure.message);
          },
          (_) async {
            // Application saved successfully
          },
        );
      }

      // Parse geometry string to Map for repository
      final geometryMap = <String, dynamic>{};
      try {
        final parsed = jsonDecode(geometry);
        if (parsed is Map<String, dynamic>) {
          geometryMap.addAll(parsed);
        }
      } catch (e) {
        // If parsing fails, use empty map
      }

      // Create parcel data map
      final parcelData = {
        'client_id': clientId,
        'subdivision_application': appId,
        'land_use_zone': widget.zoneId,
        'locality': widget.localityId,
        'geom': geometryMap,
        'north':
            _northController.text.isNotEmpty ? _northController.text : null,
        'south':
            _southController.text.isNotEmpty ? _southController.text : null,
        'east': _eastController.text.isNotEmpty ? _eastController.text : null,
        'west': _westController.text.isNotEmpty ? _westController.text : null,
        'stage': _isDraft ? 'draft' : 'registered',
      };

      final result = await repository.saveLocalParcel(parcelData);

      await result.fold(
        (failure) {
          if (mounted) {
            SnackBarUtils.showError(context, failure.message);
          }
        },
        (_) {
          if (mounted) {
            // Fetch the saved parcel from database
            _fetchAndReturnParcel(clientId, appId);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchAndReturnParcel(String clientId, String appId) async {
    try {
      final repository = ref.read(ccroRepositoryProvider);
      final parcelsResult = await repository.getLocalParcels();

      parcelsResult.fold(
        (failure) {
          SnackBarUtils.showError(context, failure.message);
        },
        (parcels) {
          final parcel = parcels.firstWhere(
            (p) => p.clientId == clientId,
            orElse: () => throw Exception('Parcel not found'),
          );
          SnackBarUtils.showSuccess(context, 'Kipande kimehifadhiwa');
          widget.onSave(parcel, appId);
        },
      );
    } catch (e) {
      SnackBarUtils.showError(context, 'Hitilafu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final areaSqm = _calculateArea();
    final areaHa = areaSqm / 10000;

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
                    'Maelezo ya Kipande',
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
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    children: [
                      // Area display
                      Card(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.spacingMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Eneo la Kipande',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingXs),
                              Text(
                                '${areaSqm.toStringAsFixed(2)} m² (${areaHa.toStringAsFixed(4)} ha)',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Boundary descriptions
                      Text(
                        'Majirani (Mipaka)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      TextFormFieldWidget(
                        controller: _northController,
                        label: 'Kaskazini',
                        placeholder: 'Mfano: Barabara',
                        maxLength: 100,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      TextFormFieldWidget(
                        controller: _southController,
                        label: 'Kusini',
                        placeholder: 'Mfano: Kipande cha John',
                        maxLength: 100,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      TextFormFieldWidget(
                        controller: _eastController,
                        label: 'Mashariki',
                        placeholder: 'Mfano: Mto',
                        maxLength: 100,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      TextFormFieldWidget(
                        controller: _westController,
                        label: 'Magharibi',
                        placeholder: 'Mfano: Shule',
                        maxLength: 100,
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Save as draft toggle
                      Card(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        child: SwitchListTile(
                          value: _isDraft,
                          onChanged: (value) {
                            setState(() => _isDraft = value);
                          },
                          title: const Text('Hifadhi kama rasimu'),
                          subtitle: Text(
                            _isDraft
                                ? 'Itahifadhiwa kama rasimu ili ubadilishe baadaye'
                                : 'Itahifadhiwa kama iliyokamilika',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Save button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveParcel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                        ),
                        child: const Text('Hifadhi Kipande'),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Cancel button
                      OutlinedButton(
                        onPressed: _isLoading ? null : widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                        ),
                        child: const Text('Ghairi'),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
