import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';

class MyApplicationsPage extends ConsumerStatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  ConsumerState<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends ConsumerState<MyApplicationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: 'Kazi Zangu',
        hasNotification: false,
        bottom: TabBar(
          // isScrollable: true,
          controller: _tabController,
          // tabAlignment: TabAlignment.center,
          labelColor: isDark ? AppColors.darkPrimary : AppColors.primary,
          unselectedLabelColor:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          dividerColor: isDark ? AppColors.darkDivider : AppColors.divider,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSm,
          ),
          tabs: const [
            Tab(text: 'Rasimu'),
            Tab(text: 'Zimekamilika'),
            Tab(text: 'Zimepakiwa'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDraftTab(theme, isDark),
          _buildCompletedTab(theme, isDark),
          _buildUploadedTab(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildDraftTab(ThemeData theme, bool isDark) {
    // TODO: Replace with actual data from providers
    return _buildEmptyState(
      theme,
      isDark,
      icon: Icons.edit_note_outlined,
      title: 'Hakuna maombi ya rasimu',
      subtitle: 'Maombi ambayo hayajakamilika yataonekana hapa',
    );
  }

  Widget _buildCompletedTab(ThemeData theme, bool isDark) {
    // TODO: Replace with actual data from providers
    return _buildEmptyState(
      theme,
      isDark,
      icon: Icons.check_circle_outline,
      title: 'Hakuna maombi yaliyokamilika',
      subtitle: 'Maombi yaliyokamilika yataonekana hapa',
    );
  }

  Widget _buildUploadedTab(ThemeData theme, bool isDark) {
    // TODO: Replace with actual data from providers
    return _buildEmptyState(
      theme,
      isDark,
      icon: Icons.cloud_upload_outlined,
      title: 'Hakuna kazi zilizopakiwa',
      subtitle: 'Kazi zilizopakiwa zataonekana hapa',
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
