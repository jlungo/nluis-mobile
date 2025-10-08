import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/questionnaire_list_bottom_sheet.dart';
import 'questionnaire_form_page.dart';

class SurveyListPage extends StatelessWidget {
  final String projectId;
  final String? projectName;

  const SurveyListPage({super.key, required this.projectId, this.projectName});

  void _showQuestionnaireListSheet(BuildContext context) {
    QuestionnaireListBottomSheet.show(
      context,
      projectId: projectId,
      projectName: projectName ?? 'Project',
      module: 'land-uses',
      onQuestionnaireSelected: (questionnaireSlug) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => QuestionnaireFormPage(
                  questionnaireSlug: questionnaireSlug,
                  projectId: projectId,
                  projectName: projectName ?? 'Project',
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.info.withValues(alpha: 0.1),
                      AppColors.info.withValues(alpha: 0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.info.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.assignment_late_outlined,
                  size: 80,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Hakuna Dodoso Lililojazwa',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dodoso zitaonyeshwa hapa',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
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
          onPressed: () => _showQuestionnaireListSheet(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(
            Icons.add,
            color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
          ),
          label: Text(
            'Jaza Dodoso',
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
