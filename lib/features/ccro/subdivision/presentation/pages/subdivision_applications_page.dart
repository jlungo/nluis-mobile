import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../../data/local/database.dart' as db;
import '../../../../../data/local/draft_provider.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/page_empty_state.dart';
import '../../../../../shared/widgets/questionnaire_list_bottom_sheet.dart';
import '../../../../../shared/models/questionnaire.dart';
import '../widgets/subdivision_application_card.dart';
import 'modern_subdivision_stepper_page.dart';

class SubdivisionApplicationsPage extends ConsumerStatefulWidget {
  final String projectId;
  final String zoneId;
  final int localityId;
  final String projectName;

  const SubdivisionApplicationsPage({
    super.key,
    required this.projectId,
    required this.zoneId,
    required this.localityId,
    required this.projectName,
  });

  @override
  ConsumerState<SubdivisionApplicationsPage> createState() =>
      _SubdivisionApplicationsPageState();
}

class _SubdivisionApplicationsPageState
    extends ConsumerState<SubdivisionApplicationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<db.SubdivisionApplication> _draftApplications = [];
  List<db.SubdivisionApplication> _completedApplications = [];
  List<db.SubdivisionApplication> _uploadedApplications = [];
  Map<String, String> _applicantNames = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadApplications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);

      // Get all applications for this zone
      final applications =
          await (database.select(database.subdivisionApplications)
                ..where(
                  (tbl) =>
                      tbl.zoneId.equals(int.parse(widget.zoneId)) &
                      tbl.localityId.equals(widget.localityId),
                )
                ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)]))
              .get();

      // Load applicant names
      final applicantNames = <String, String>{};
      for (final app in applications) {
        // Get party for this application using applicantId
        final party =
            await (database.select(database.parties)
                  ..where((tbl) => tbl.clientId.equals(app.applicantId))
                  ..limit(1))
                .getSingleOrNull();

        if (party != null) {
          applicantNames[app.clientId] = '${party.firstName} ${party.lastName}';
        }
      }

      if (mounted) {
        setState(() {
          _draftApplications =
              applications.where((app) => app.status == 'draft').toList();
          _completedApplications =
              applications.where((app) => app.status == 'completed').toList();
          _uploadedApplications =
              applications.where((app) => app.status == 'uploaded').toList();
          _applicantNames = applicantNames;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadApplications();
  }

  void _showQuestionnaireListSheet({String? applicationId}) {
    // Hardcoded CCRO Adjudication Forms
    final ccroForms = <Questionnaire>[
      Questionnaire(
        name: 'Fomu 18A',
        slug: 'fomu-18a',
        category: 1,
        version: 1,
        isActive: true,
        moduleSlug: 'land-sub-divisions',
        moduleName: 'Adjudication',
        questionnaireSectionsCount: 1,
        description: 'Fomu ya Maombi ya Ardhi ya Kijiji kwa Mtu Binafsi',
      ),
      Questionnaire(
        name: 'Fomu 18B',
        slug: 'fomu-18b',
        category: 1,
        version: 1,
        isActive: true,
        moduleSlug: 'land-sub-divisions',
        moduleName: 'Adjudication',
        questionnaireSectionsCount: 1,
        description: 'Fomu ya Maombi ya Ardhi ya Kijiji kwa Kundi la Watu',
      ),
      Questionnaire(
        name: 'Fomu 18C',
        slug: 'fomu-18c',
        category: 1,
        version: 1,
        isActive: true,
        moduleSlug: 'land-sub-divisions',
        moduleName: 'Adjudication',
        questionnaireSectionsCount: 1,
        description:
            'Fomu ya Maombi ya Ardhi ya Kijiji kwa Kundi la Watu wasio Wakazi',
      ),
      Questionnaire(
        name: 'Fomu 18D',
        slug: 'fomu-18d',
        category: 1,
        version: 1,
        isActive: true,
        moduleSlug: 'land-sub-divisions',
        moduleName: 'Adjudication',
        questionnaireSectionsCount: 1,
        description: 'Fomu ya Maombi ya Ardhi ya Kijiji kwa Taasisi',
      ),
    ];

    QuestionnaireListBottomSheet.show(
      context,
      projectId: widget.projectId,
      projectName: widget.projectName,
      module: 'land-sub-divisions',
      hardcodedQuestionnaires: ccroForms,
      onQuestionnaireSelected: (questionnaireSlug) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (_) => ModernSubdivisionStepperPage(
                      projectId: widget.projectId,
                      zoneId: widget.zoneId,
                      localityId: widget.localityId,
                      projectName: widget.projectName,
                      applicationId: applicationId,
                    ),
              ),
            )
            .then((_) => _loadApplications()); // Refresh when returning
      },
    );
  }

  void _openApplicationStepper({String? applicationId}) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder:
                (_) => ModernSubdivisionStepperPage(
                  projectId: widget.projectId,
                  zoneId: widget.zoneId,
                  localityId: widget.localityId,
                  projectName: widget.projectName,
                  applicationId: applicationId,
                ),
          ),
        )
        .then((_) => _loadApplications());
  }

  Widget _buildApplicationsList(
    List<db.SubdivisionApplication> applications,
    bool isDark,
  ) {
    if (applications.isEmpty) {
      return EmptyPageState(
        context: context,
        isDark: isDark,
        heading: 'Hakuna Maombi',
        description: 'Maombi yataonyeshwa hapa',
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final application = applications[index];
          return SubdivisionApplicationCard(
            application: application,
            projectName: widget.projectName,
            applicantName: _applicantNames[application.clientId],
            isDark: isDark,
            onTap:
                () => _openApplicationStepper(
                  applicationId: application.clientId,
                ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.projectName,
        subtitle: 'Maombi ya Mgawanyo',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
              ),
            ),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabAlignment: TabAlignment.center,
              labelColor: isDark ? AppColors.darkPrimary : AppColors.primary,
              unselectedLabelColor:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
              dividerColor: isDark ? AppColors.darkDivider : AppColors.divider,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSm,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit_note, size: 18),
                      const SizedBox(width: AppConstants.spacingXs),
                      const Text('Rasimu'),
                      if (_draftApplications.isNotEmpty) ...[
                        const SizedBox(width: AppConstants.spacingXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(
                              alpha: isDark ? 0.2 : 0.12,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSm,
                            ),
                          ),
                          child: Text(
                            '${_draftApplications.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, size: 18),
                      const SizedBox(width: AppConstants.spacingXs),
                      const Text('Zimekamilika'),
                      if (_completedApplications.isNotEmpty) ...[
                        const SizedBox(width: AppConstants.spacingXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(
                              alpha: isDark ? 0.2 : 0.12,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSm,
                            ),
                          ),
                          child: Text(
                            '${_completedApplications.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_done, size: 18),
                      const SizedBox(width: AppConstants.spacingXs),
                      const Text('Zimepakiwa'),
                      if (_uploadedApplications.isNotEmpty) ...[
                        const SizedBox(width: AppConstants.spacingXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(
                              alpha: isDark ? 0.2 : 0.12,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSm,
                            ),
                          ),
                          child: Text(
                            '${_uploadedApplications.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildApplicationsList(_draftApplications, isDark),
                        _buildApplicationsList(_completedApplications, isDark),
                        _buildApplicationsList(_uploadedApplications, isDark),
                      ],
                    ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                    : [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.4)
                      : AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showQuestionnaireListSheet(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(
            Icons.add,
            color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
          ),
          label: Text(
            'Ombi Jipya',
            style: TextStyle(
              color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
