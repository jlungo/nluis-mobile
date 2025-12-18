import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/module_switchboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/land_use_dashboard_page.dart';
import '../../features/land_use/survey/presentation/pages/survey_list_page.dart';
import '../../features/land_use/survey/presentation/pages/survey_form_page.dart';
import '../../features/adjudication/dashboard/presentation/pages/adjudication_dashboard_page.dart';
import '../../features/adjudication/survey/presentation/pages/survey_list_page.dart'
    as adjudication_survey;
import '../../features/adjudication/survey/presentation/pages/survey_form_page.dart'
    as adjudication_form;
import '../../features/monitoring_evaluation/dashboard/presentation/pages/me_dashboard_page.dart';
import '../../features/monitoring_evaluation/survey/presentation/pages/survey_list_page.dart'
    as me_survey;
import '../../features/monitoring_evaluation/survey/presentation/pages/survey_form_page.dart'
    as me_form;
import '../../features/compliance/dashboard/presentation/pages/compliance_dashboard_page.dart';
import '../../features/compliance/survey/presentation/pages/survey_list_page.dart'
    as compliance_survey;
import '../../features/compliance/survey/presentation/pages/survey_form_page.dart'
    as compliance_form;
import '../../features/land_use/zoning/presentation/pages/zoning_page_wrapper.dart';
import '../../features/adjudication/zoning/presentation/pages/zoning_page_wrapper.dart'
    as adjudication_zoning;
import '../../features/monitoring_evaluation/zoning/presentation/pages/zoning_page_wrapper.dart'
    as me_zoning;
import '../../features/compliance/zoning/presentation/pages/zoning_page_wrapper.dart'
    as compliance_zoning;
import '../../features/settings/presentation/pages/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/module-switchboard',
      name: 'moduleSwitch',
      builder: (context, state) => const ModuleSwitchboardPage(),
    ),
    GoRoute(
      path: '/land-use',
      name: 'luDashboard',
      builder: (context, state) => const LandUseDashboardPage(),
    ),
    GoRoute(
      path: '/land-use/projects/:projectId/surveys',
      name: 'luSurveys',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return SurveyListPage(projectId: projectId, projectName: projectName);
      },
      routes: [
        GoRoute(
          path: 'new',
          name: 'luSurveyNew',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final projectName = state.uri.queryParameters['projectName'];
            final questionnaireSlug =
                state.uri.queryParameters['questionnaireSlug']!;
            final surveyId = state.uri.queryParameters['surveyId'];
            return SurveyFormPage(
              projectId: projectId,
              projectName: projectName,
              questionnaireSlug: questionnaireSlug,
              surveyId: surveyId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/land-use/projects/:projectId/zoning',
      name: 'luZoning',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return ZoningPageWrapper(
          projectId: projectId,
          // projectName: projectName,
        );
      },
    ),
    GoRoute(
      path: '/adjudication',
      name: 'adjudicationDashboard',
      builder: (context, state) => const AdjudicationDashboardPage(),
    ),
    GoRoute(
      path: '/adjudication/projects/:projectId/surveys',
      name: 'adjudicationSurveys',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return adjudication_survey.SurveyListPage(
          projectId: projectId,
          projectName: projectName,
        );
      },
      routes: [
        GoRoute(
          path: 'new',
          name: 'adjudicationSurveyNew',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final projectName = state.uri.queryParameters['projectName'];
            final questionnaireSlug =
                state.uri.queryParameters['questionnaireSlug']!;
            final surveyId = state.uri.queryParameters['surveyId'];
            return adjudication_form.SurveyFormPage(
              projectId: projectId,
              projectName: projectName,
              questionnaireSlug: questionnaireSlug,
              surveyId: surveyId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/adjudication/projects/:projectId/zoning',
      name: 'adjudicationZoning',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return adjudication_zoning.ZoningPageWrapper(
          projectId: projectId,
          // projectName: projectName,
        );
      },
    ),
    GoRoute(
      path: '/monitoring-evaluation',
      name: 'meDashboard',
      builder: (context, state) => const MEDashboardPage(),
    ),
    GoRoute(
      path: '/monitoring-evaluation/projects/:projectId/surveys',
      name: 'meSurveys',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return me_survey.SurveyListPage(
          projectId: projectId,
          projectName: projectName,
        );
      },
      routes: [
        GoRoute(
          path: 'new',
          name: 'meSurveyNew',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final projectName = state.uri.queryParameters['projectName'];
            final questionnaireSlug =
                state.uri.queryParameters['questionnaireSlug']!;
            final surveyId = state.uri.queryParameters['surveyId'];
            return me_form.SurveyFormPage(
              projectId: projectId,
              projectName: projectName,
              questionnaireSlug: questionnaireSlug,
              surveyId: surveyId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/monitoring-evaluation/projects/:projectId/zoning',
      name: 'meZoning',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return me_zoning.ZoningPageWrapper(
          projectId: projectId,
          // projectName: projectName,
        );
      },
    ),
    GoRoute(
      path: '/compliance',
      name: 'complianceDashboard',
      builder: (context, state) => const ComplianceDashboardPage(),
    ),
    GoRoute(
      path: '/compliance/projects/:projectId/surveys',
      name: 'complianceSurveys',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return compliance_survey.SurveyListPage(
          projectId: projectId,
          projectName: projectName,
        );
      },
      routes: [
        GoRoute(
          path: 'new',
          name: 'complianceSurveyNew',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final projectName = state.uri.queryParameters['projectName'];
            final questionnaireSlug =
                state.uri.queryParameters['questionnaireSlug']!;
            final surveyId = state.uri.queryParameters['surveyId'];
            return compliance_form.SurveyFormPage(
              projectId: projectId,
              projectName: projectName,
              questionnaireSlug: questionnaireSlug,
              surveyId: surveyId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/compliance/projects/:projectId/zoning',
      name: 'complianceZoning',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        final projectName = state.uri.queryParameters['projectName'];
        return compliance_zoning.ZoningPageWrapper(
          projectId: projectId,
          // projectName: projectName,
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
