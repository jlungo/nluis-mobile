import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/module_switchboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/land_use_dashboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/projects_list_page.dart';
import '../../features/land_use/survey/presentation/pages/survey_list_page.dart';
import '../../features/land_use/zoning/presentation/pages/zoning_page_wrapper.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/app_configurations_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/madodoso/presentation/pages/madodoso_page.dart';
import '../../features/land_use/survey/presentation/pages/questionnaire_form_page.dart';
import '../../features/land_use/zoning/presentation/pages/zoning_manager_page.dart';
import '../../shared/widgets/app_shell.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/domain/entities/user.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      // Only notify on successful login
      // Don't notify on login failure
      final wasError = previous?.hasError ?? false;
      final wasLoading = previous?.isLoading ?? false;
      final isNowData = next.hasValue && next.value != null;
      final isNowError = next.hasError;

      // Refresh router when user becomes authenticated
      if ((wasError || wasLoading) && isNowData) {
        notifyListeners();
      }
      // Also refresh when user logout
      else if (previous?.value != null && next.value == null && !isNowError) {
        notifyListeners();
      }
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshNotifier(ref),
    redirect: (context, state) {
      // Let splash page handle all authentication logic
      // Only redirect authenticated users away from login page
      final authState = ref.read(authStateProvider);
      final isGoingToLogin = state.matchedLocation == '/login';
      
      if (isGoingToLogin) {
        final user = authState.when(
          data: (user) => user,
          loading: () => null,
          error: (_, _) => null,
        );
        
        // If user is already authenticated, redirect to module switch
        if (user != null) {
          return '/module-switch';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/module-switch',
        name: 'moduleSwitch',
        builder: (context, state) => const ModuleSwitchboardPage(),
      ),
      // ROUTES WITH APP SHELL ( Bottom Navigation )
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // LAND USE MODULE
          GoRoute(
            path: '/module/land-use/dashboard',
            name: 'luDashboard',
            builder: (context, state) => const LandUseDashboardPage(),
          ),
          GoRoute(
            path: '/module/land-use/projects',
            name: 'luProjects',
            builder: (context, state) => const ProjectsListPage(),
          ),
          // DODOSO HUB
          GoRoute(
            path: '/madodoso',
            name: 'madodoso',
            builder: (context, state) => const MadodosoPage(),
          ),
          // ZONING MANAGER
          GoRoute(
            path: '/zoning-manager',
            name: 'zoningManager',
            builder: (context, state) => const ZoningManagerPage(),
          ),
          // SETTINGS
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      // APP CONFIGURATIONS
      GoRoute(
        path: '/app-configurations',
        name: 'appConfigurations',
        builder: (context, state) => const AppConfigurationsPage(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/module/land-use/survey/:projectId',
        name: 'luSurveyList',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return SurveyListPage(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/module/land-use/zoning/:projectId',
        name: 'luZoning',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return ZoningPageWrapper(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/questionnaire/:questionnaireSlug/:projectId/:projectName',
        name: 'questionnaireForm',
        builder: (context, state) {
          final questionnaireSlug = state.pathParameters['questionnaireSlug']!;
          final projectId = state.pathParameters['projectId']!;
          final projectName = state.pathParameters['projectName']!;
          final surveyId = state.uri.queryParameters['surveyId'];
          final isReadOnly = state.uri.queryParameters['isReadOnly'] == 'true';
          
          return QuestionnaireFormPage(
            questionnaireSlug: questionnaireSlug,
            projectId: projectId,
            projectName: projectName,
            surveyId: surveyId,
            isReadOnly: isReadOnly,
          );
        },
      ),
    ],
  );
});
