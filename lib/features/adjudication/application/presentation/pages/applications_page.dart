import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplicationsPage extends ConsumerStatefulWidget {
  const ApplicationsPage({super.key});

  @override
  ConsumerState<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends ConsumerState<ApplicationsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(filteredApplicationsProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true, title: 'Applications'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tafuta ombi...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Zote',
                        isSelected: selectedFilter == ApplicationFilter.all,
                        onTap: () {
                          ref.read(selectedFilterProvider.notifier).state =
                              ApplicationFilter.all;
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Rasimu',
                        isSelected: selectedFilter == ApplicationFilter.draft,
                        onTap: () {
                          ref.read(selectedFilterProvider.notifier).state =
                              ApplicationFilter.draft;
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Zimekamilika',
                        isSelected:
                            selectedFilter == ApplicationFilter.completed,
                        onTap: () {
                          ref.read(selectedFilterProvider.notifier).state =
                              ApplicationFilter.completed;
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Zimepakiwa',
                        isSelected:
                            selectedFilter == ApplicationFilter.uploaded,
                        onTap: () {
                          ref.read(selectedFilterProvider.notifier).state =
                              ApplicationFilter.uploaded;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(filteredApplicationsProvider);
              },
              child: applicationsAsync.when(
                data:
                    (applications) =>
                        applications.isEmpty
                            ? _EmptyState(filter: selectedFilter)
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: applications.length,
                              itemBuilder: (context, index) {
                                final application = applications[index];
                                return ApplicationCard(
                                  application: application,
                                  onTap: () {
                                    context.push(
                                      '/module/adjudication/application/${application.id}',
                                    );
                                  },
                                );
                              },
                            ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, _) => Center(
                      child: EmptyStateWidget(
                        icon: Icons.error_outline,
                        title: 'Hitilafu imetokea',
                        subtitle: error.toString(),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ApplicationFilter filter;

  const _EmptyState({required this.filter});

  String get _getMessage {
    switch (filter) {
      case ApplicationFilter.all:
        return 'Hakuna maombi';
      case ApplicationFilter.draft:
        return 'Hakuna maombi ya rasimu';
      case ApplicationFilter.completed:
        return 'Hakuna maombi yaliyokamilika';
      case ApplicationFilter.uploaded:
        return 'Hakuna maombi yaliyopakiwa';
    }
  }

  String get _getSubtitle {
    switch (filter) {
      case ApplicationFilter.all:
        return 'Maombi yako yataonekana hapa';
      case ApplicationFilter.draft:
        return 'Maombi ya rasimu yataonekana hapa';
      case ApplicationFilter.completed:
        return 'Maombi yaliyokamilika yataonekana hapa';
      case ApplicationFilter.uploaded:
        return 'Maombi yaliyopakiwa yataonekana hapa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.description_outlined,
      title: _getMessage,
      subtitle: _getSubtitle,
    );
  }
}
