import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'application_details_page.dart';
import 'parcel_mapping_page.dart';

class ParcelMappingWrapper extends ConsumerWidget {
  final int applicationId;

  const ParcelMappingWrapper({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(
      applicationDetailsProvider(applicationId),
    );

    return applicationAsync.when(
      data: (application) {
        // return const Scaffold(
        //   appBar: CustomAppBar(
        //     title: 'Ramani ya Kiwanja',
        //     showBackButton: true,
        //   ),
        //   body: Center(child: Text('Coming soon')),
        // );
        return ParcelMappingPage(
          applicationId: application.id,
          // localityId: application.localityProject,
          localityId: 6628,
          applicationNumber: application.claimNumber,
        );
      },
      loading:
          () => const Scaffold(
            appBar: CustomAppBar(title: 'Ramani ya Kiwanja'),
            body: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, _) => Scaffold(
            appBar: const CustomAppBar(title: 'Ramani ya Kiwanja'),
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
}
