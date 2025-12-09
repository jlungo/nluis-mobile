import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/error_state_widget.dart';
import '../../../dashboard/presentation/providers/ccro_providers.dart';

class SubdivisionZonesPage extends ConsumerWidget {
  final String projectId;
  final int localityId;
  final String projectName;

  const SubdivisionZonesPage({
    super.key,
    required this.projectId,
    required this.localityId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final zonesAsync = ref.watch(subdivisionZonesProvider(localityId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: CustomAppBar(
        title: 'Maeneo ya Mgawanyiko',
        subtitle: projectName,
        showBackButton: true,
        showProfile: false,
      ),
      body: zonesAsync.when(
        data: (zones) {
          if (zones.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.location_city_outlined,
              title: 'Hakuna Maeneo',
              subtitle: 'Hakuna maeneo yanayopatikana kwa eneo hili',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            itemCount: zones.length,
            itemBuilder: (context, index) {
              final zone = zones[index];
              final canBeSubdivided =
                  zone['can_be_subdivided'] as bool? ?? true;
              final zoneName = zone['zone_name'] as String? ?? 'Unknown';
              final landUseName = zone['land_use_name'] as String?;
              // API returns area_sqm as String, need to parse it
              final areaSqm =
                  zone['area_sqm'] != null
                      ? double.tryParse(zone['area_sqm'].toString())
                      : null;
              final zoneId = zone['id'] as int;

              return Card(
                margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        canBeSubdivided
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.2),
                    child: Icon(
                      canBeSubdivided
                          ? Icons.check_circle_outline
                          : Icons.block_outlined,
                      color:
                          canBeSubdivided ? AppColors.success : AppColors.error,
                    ),
                  ),
                  title: Text(
                    zoneName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (landUseName != null) Text('Matumizi: $landUseName'),
                      if (areaSqm != null)
                        Text(
                          'Eneo: ${(areaSqm / 10000).toStringAsFixed(2)} ha',
                        ),
                    ],
                  ),
                  trailing:
                      canBeSubdivided
                          ? const Icon(Icons.arrow_forward_ios, size: 16)
                          : null,
                  enabled: canBeSubdivided,
                  onTap:
                      canBeSubdivided
                          ? () {
                            context.pushNamed(
                              'subdivisionApplications',
                              pathParameters: {
                                'projectId': projectId,
                                'zoneId': zoneId.toString(),
                                'localityId': localityId.toString(),
                              },
                              queryParameters: {'projectName': projectName},
                            );
                          }
                          : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => ErrorStateWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(subdivisionZonesProvider(localityId)),
            ),
      ),
    );
  }
}
