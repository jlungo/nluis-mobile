import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/module_switchboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/land_use_dashboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/projects_list_page.dart';
import '../../features/land_use/survey/presentation/pages/survey_list_page.dart';
import '../../features/land_use/survey/presentation/pages/survey_edit_page.dart';
import '../../features/land_use/zoning/presentation/pages/zoning_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/drafts/presentation/pages/draft_dodosos_page.dart';
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
      // Read auth state only when redirect is called
      final authState = ref.read(authStateProvider);

      final user = authState.when(
        data: (user) => user,
        loading: () => null,
        error: (_, _) => null,
      );
      final isAuth = user != null;

      final isGoingToSplash = state.matchedLocation == '/splash';
      final isGoingToLogin = state.matchedLocation == '/login';

      if (isGoingToSplash && !authState.isLoading) {
        if (!isAuth) return '/login';
        return '/module-switch';
      }

      // if (isGoingToSplash) return null;

      if (isGoingToLogin) {
        if (isAuth) return '/module-switch';
        return null;
      }

      if (!isAuth) {
        return '/login';
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
          GoRoute(
            path: '/module/land-use/zoning/:projectId',
            name: 'luZoning',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              return ZoningPage(projectId: projectId);
            },
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
            path: '/module/land-use/survey/:projectId/edit/:responseId',
            name: 'luSurveyEdit',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final responseId = state.pathParameters['responseId']!;
              return SurveyEditPage(
                projectId: projectId,
                responseId: responseId,
              );
            },
          ),
          // NOTIFICATIONS
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          // DRAFTS
          GoRoute(
            path: '/drafts',
            name: 'drafts',
            builder: (context, state) => const DraftDodososPage(),
          ),
          // SETTINGS
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});
