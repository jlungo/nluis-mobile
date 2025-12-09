import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../data/local/database.dart';

class ParcelDrawingStep extends ConsumerWidget {
  final String projectId;
  final int zoneId;
  final int localityId;
  final String? applicationId;
  final Parcel? parcel;
  final Function(Parcel, String) onParcelCreated;

  const ParcelDrawingStep({
    super.key,
    required this.projectId,
    required this.zoneId,
    required this.localityId,
    this.applicationId,
    this.parcel,
    required this.onParcelCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (parcel != null) {
      return _buildParcelSummary(context, theme, isDark);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekodi Kipande cha Ardhi',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),

        Card(
          color: isDark ? AppColors.darkSurface : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            side: BorderSide(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
          ),
          child: Container(
            height: 300,
            alignment: Alignment.center,
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
                Text(
                  'Ramani ya kuchora kipande',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Bonyeza hapo chini kuanza kuchora',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate directly to parcel mapping page
              // Input method will be selected on the mapping page when "Rekodi Kipande" is clicked
              context.pushNamed(
                'parcelMapping',
                pathParameters: {
                  'projectId': projectId,
                  'zoneId': zoneId.toString(),
                  'localityId': localityId.toString(),
                },
                queryParameters: {
                  if (applicationId != null) 'applicationId': applicationId!,
                },
              ).then((result) {
                // Handle returned data
                if (result != null && result is Map<String, dynamic>) {
                  final parcel = result['parcel'] as Parcel;
                  final appId = result['applicationId'] as String;
                  onParcelCreated(parcel, appId);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkPrimary : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
            ),
            icon: const Icon(Icons.map),
            label: const Text('Rekodi Kipande'),
          ),
        ),
      ],
    );
  }

  Widget _buildParcelSummary(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final areaSqm = parcel!.areaSqm ?? 0;
    final areaHa = areaSqm / 10000;

    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate directly to parcel mapping page for editing
          // Input method will be selected on the mapping page when "Rekodi Kipande" is clicked
          context.pushNamed(
            'parcelMapping',
            pathParameters: {
              'projectId': projectId,
              'zoneId': zoneId.toString(),
              'localityId': localityId.toString(),
            },
            queryParameters: {
              if (applicationId != null) 'applicationId': applicationId!,
            },
          ).then((result) {
            // Handle returned updated data
            if (result != null && result is Map<String, dynamic>) {
              final updatedParcel = result['parcel'] as Parcel;
              final appId = result['applicationId'] as String;
              onParcelCreated(updatedParcel, appId);
            }
          });
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                    child: Icon(
                      Icons.landscape,
                      size: 32,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kipande cha Ardhi',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Eneo: ${areaHa.toStringAsFixed(2)} ha',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bofya kurekebisha',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                ],
              ),
              if (parcel!.north != null || parcel!.south != null) ...[
                const SizedBox(height: AppConstants.spacingMd),
                const Divider(),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Mipaka:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                if (parcel!.north != null)
                  _buildBoundaryItem('Kaskazini', parcel!.north!, theme),
                if (parcel!.south != null)
                  _buildBoundaryItem('Kusini', parcel!.south!, theme),
                if (parcel!.east != null)
                  _buildBoundaryItem('Mashariki', parcel!.east!, theme),
                if (parcel!.west != null)
                  _buildBoundaryItem('Magharibi', parcel!.west!, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoundaryItem(
    String direction,
    String description,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$direction:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(description, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
