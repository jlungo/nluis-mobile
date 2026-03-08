import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import './photo_capture_page.dart';

final applicationDetailsProvider = FutureProvider.family<LandApplication, int>((
  ref,
  applicationId,
) async {
  final repository = ref.watch(adjudicationRepositoryProvider);
  final result = await repository.getApplicationDetails(applicationId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (application) => application,
  );
});

class ApplicationDetailsPage extends ConsumerWidget {
  final int applicationId;

  const ApplicationDetailsPage({super.key, required this.applicationId});

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'assigned':
  //       return AppColors.info;
  //     case 'surveying':
  //       return AppColors.warning;
  //     case 'survey_complete':
  //       return AppColors.success;
  //     default:
  //       return AppColors.textSecondary;
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(
      applicationDetailsProvider(applicationId),
    );

    return applicationAsync.when(
      data:
          (application) => _ApplicationDetailsView(
            application: application,
            ref: ref,
            onViewMap:
                application.hasParcel
                    ? () {
                      // Navigate to parcel map view
                      context.push(
                        '/module/adjudication/parcel-map/${application.id}',
                      );
                    }
                    : null,
            onStartSurvey: () {
              _showSurveyOptionsSheet(context, ref, application);
            },
            onStartSurveyAction: () async {
              await _startSurvey(context, ref, application);
            },
          ),
      loading:
          () => const Scaffold(
            appBar: CustomAppBar(
              title: 'Maelezo ya Ombi',
              showBackButton: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, _) => Scaffold(
            appBar: const CustomAppBar(
              title: 'Maelezo ya Ombi',
              showBackButton: true,
            ),
            body: Center(
              child: EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Hitilafu imetokea',
                subtitle: error.toString(),
              ),
            ),
          ),
    );
  }

  void _showSurveyOptionsSheet(
    BuildContext context,
    WidgetRef ref,
    LandApplication application,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chagua Hatua',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: const Text('Ongeza/Hariri Majirani'),
                  subtitle: const Text('Thibitisha au ongeza majirani'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to neighbors management
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: const Text('Rekodi Eneo la Kiwanja'),
                  subtitle: const Text('Chora mipaka ya kiwanja'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(
                      '/module/adjudication/parcel-mapping/${application.id}',
                    );
                  },
                ),
                if (application.hasParcel) ...[
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text('Piga Picha za Kiwanja'),
                    subtitle: const Text('Hadi picha 4'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/module/adjudication/photo-capture/${application.id}/${Uri.encodeComponent(application.claimNumber)}',
                      );
                    },
                  ),
                  Divider(color: AppColors.divider),
                  ListTile(
                    leading: Icon(Icons.check_circle, color: AppColors.success),
                    title: const Text('Kamilisha Uchunguzi'),
                    subtitle: const Text('Wasilisha ombi'),
                    onTap: () {
                      Navigator.pop(context);
                      _showCompleteSurveyDialog(context, ref, application);
                    },
                  ),
                ],
              ],
            ),
          ),
    );
  }

  void _showCompleteSurveyDialog(
    BuildContext context,
    WidgetRef ref,
    LandApplication application,
  ) {
    final photos = ref.read(photoListProvider(application.id));

    // Validation
    final List<String> errors = [];
    if (!application.hasParcel) {
      errors.add('Hujachora mipaka ya kiwanja');
    }
    if (photos.isEmpty) {
      errors.add('Hujapiga picha za kiwanja');
    }
    // TODO: Add neighbor verification check
    // if (!application.hasVerifiedNeighbors) {
    //   errors.add('Majirani hawajathibitishwa');
    // }

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Uchunguzi Haujakamilika'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tafadhali kamilisha hatua zifuatazo:'),
                  const SizedBox(height: 12),
                  ...errors.map(
                    (error) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(error)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Sawa'),
                ),
              ],
            ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Kamilisha Uchunguzi'),
            content: const Text(
              'Je, una uhakika unataka kukamilisha uchunguzi wa ombi hili? Hatua hii haiwezi kutenduliwa.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ghairi'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _completeSurvey(context, ref, application.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('Kamilisha'),
              ),
            ],
          ),
    );
  }

  Future<void> _completeSurvey(
    BuildContext context,
    WidgetRef ref,
    int applicationId,
  ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final repository = ref.read(adjudicationRepositoryProvider);
    final result = await repository.completeSurvey(applicationId);

    if (!context.mounted) return;
    Navigator.pop(context); // Close loading

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu: ${failure.message}'),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (application) {
        // Invalidate providers to refresh data
        ref.invalidate(applicationDetailsProvider(applicationId));
        ref.invalidate(myApplicationsProvider);
        ref.invalidate(adjudicationStatsProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uchunguzi umekamilishwa!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  Future<void> _startSurvey(
    BuildContext context,
    WidgetRef ref,
    LandApplication application,
  ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final repository = ref.read(adjudicationRepositoryProvider);
    final result = await repository.startSurvey(application.id);

    if (!context.mounted) return;
    Navigator.pop(context); // Close loading

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu: ${failure.message}'),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (updatedApplication) {
        // Invalidate provider to refresh data
        ref.invalidate(applicationDetailsProvider(application.id));
        ref.invalidate(myApplicationsProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uchunguzi umeanza!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }
}

class _ApplicationDetailsView extends StatefulWidget {
  final LandApplication application;
  final WidgetRef ref;
  final VoidCallback? onViewMap;
  final VoidCallback onStartSurvey;
  final VoidCallback onStartSurveyAction;

  const _ApplicationDetailsView({
    required this.application,
    required this.ref,
    this.onViewMap,
    required this.onStartSurvey,
    required this.onStartSurveyAction,
  });

  @override
  State<_ApplicationDetailsView> createState() =>
      _ApplicationDetailsViewState();
}

class _ApplicationDetailsViewState extends State<_ApplicationDetailsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Show parties in a full-screen bottom sheet
  void _showPartiesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMd),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        AppConstants.spacingSm,
                      ),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.all(AppConstants.spacingSm),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline, color: AppColors.primary),
                      SizedBox(width: AppConstants.spacingMd),
                      Text(
                        'Wahusika',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: AppConstants.spacingSm,
                  color: AppColors.divider,
                ),
                // Content
                Expanded(
                  child: PartiesTab(parties: widget.application.parties),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show neighbors in a full-screen bottom sheet
  void _showNeighborsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Padding(
                  padding: EdgeInsets.all(AppConstants.spacingSm),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        AppConstants.spacingSm,
                      ),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMd),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_pin_circle_outlined,
                        color: AppColors.info,
                      ),
                      SizedBox(width: AppConstants.spacingMd),
                      Text(
                        'Majirani',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: AppConstants.spacingSm,
                  color: AppColors.divider,
                ),
                // Content
                Expanded(
                  child: NeighborsTab(
                    neighbors: widget.application.neighbors,
                    onEdit: (neighbor) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (_) => NeighborFormBottomSheet(
                              applicationId: widget.application.id,
                              neighbor: neighbor,
                            ),
                      );
                    },
                    onVerify: (neighbor) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (_) => VerifyNeighborBottomSheet(
                              applicationId: widget.application.id,
                              neighbor: neighbor,
                            ),
                      );
                    },
                    onAdd: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (_) => NeighborFormBottomSheet(
                              applicationId: widget.application.id,
                            ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'assigned':
        return AppColors.info;
      case 'surveying':
        return AppColors.warning;
      case 'survey_complete':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final application = widget.application;

    return Scaffold(
      appBar: CustomAppBar(
        title: application.claimNumber,
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        application.registrationNumber,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSm,
                        vertical: AppConstants.spacingSm,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          application.status,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        application.statusDisplay,
                        style: TextStyle(
                          color: _getStatusColor(application.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.spacingMd),
                _InfoRow(
                  icon: Icons.business_outlined,
                  label: 'Aina ya Umiliki',
                  value: application.ownershipTypeDisplay,
                ),
                SizedBox(height: AppConstants.spacingSm),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Eneo',
                  value: application.localityName,
                ),
                if (application.estimatedAreaAcres != null) ...[
                  SizedBox(height: AppConstants.spacingSm),
                  _InfoRow(
                    icon: Icons.crop_square_outlined,
                    label: 'Ukubwa',
                    value:
                        '${application.estimatedAreaAcres!.toStringAsFixed(2)} ekari',
                  ),
                ],
                if (application.currentLandUse != null) ...[
                  SizedBox(height: AppConstants.spacingSm),
                  _InfoRow(
                    icon: Icons.eco_outlined,
                    label: 'Matumizi ya Sasa',
                    value: application.currentLandUse!,
                  ),
                ],
                if (application.tenureTypeDisplay != null) ...[
                  SizedBox(height: AppConstants.spacingSm),
                  _InfoRow(
                    icon: Icons.description_outlined,
                    label: 'Aina ya Hati',
                    value: application.tenureTypeDisplay!,
                  ),
                ],
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: _ActionButton(
          //           icon: Icons.people_outline,
          //           label: 'Wahusika',
          //           color: AppColors.primary,
          //           onTap: () => _showPartiesSheet(context),
          //         ),
          //       ),
          //       const SizedBox(width: 16),
          //       Expanded(
          //         child: _ActionButton(
          //           icon: Icons.person_pin_circle_outlined,
          //           label: 'Majirani',
          //           color: AppColors.info,
          //           onTap: () => _showNeighborsSheet(context),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Application details summary
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Maelezo ya Ziada',
                  //           style: Theme.of(context).textTheme.titleMedium
                  //               ?.copyWith(fontWeight: FontWeight.bold),
                  //         ),
                  //         SizedBox(height: AppConstants.spacingMd),
                  //         if (application.notes != null &&
                  //             application.notes!.isNotEmpty) ...[
                  //           Text(
                  //             application.notes!,
                  //             style: Theme.of(context).textTheme.bodyMedium,
                  //           ),
                  //         ] else ...[
                  //           Text(
                  //             'Hakuna maelezo ya ziada',
                  //             style: Theme.of(
                  //               context,
                  //             ).textTheme.bodyMedium?.copyWith(
                  //               color: AppColors.textSecondary,
                  //               fontStyle: FontStyle.italic,
                  //             ),
                  //           ),
                  //         ],
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  _SummaryCard(
                    title: 'Wahusika',
                    count: application.parties.length,
                    icon: Icons.people_outline,
                    color: AppColors.primary,
                    onTap: () => _showPartiesSheet(context),
                  ),
                  _SummaryCard(
                    title: 'Majirani',
                    count: application.neighbors.length,
                    icon: Icons.person_pin_circle_outlined,
                    color: AppColors.info,
                    onTap: () => _showNeighborsSheet(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (widget.onViewMap != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onViewMap,
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Angalia Ramani'),
                ),
              ),
            if (widget.onViewMap != null) const SizedBox(width: 12),
            Expanded(
              flex: widget.onViewMap != null ? 1 : 2,
              child: ElevatedButton.icon(
                onPressed:
                    application.status == 'assigned'
                        ? widget.onStartSurveyAction
                        : widget.onStartSurvey,
                icon: Icon(
                  application.status == 'assigned'
                      ? Icons.start
                      : Icons.play_arrow,
                ),
                label: Text(
                  application.status == 'assigned'
                      ? 'Anza Uchunguzi'
                      : 'Endelea',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New widget for action buttons
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: color.withValues(alpha: 0.1),
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: color),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TextStyle(color: color, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// New widget for summary cards
class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
