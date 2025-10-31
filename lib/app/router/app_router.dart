import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/module_switchboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/land_use_dashboard_page.dart';
import '../../features/land_use/dashboard/presentation/pages/projects_list_page.dart';
import '../../features/land_use/survey/presentation/pages/survey_list_page.dart';
import '../../features/land_use/zoning/presentation/pages/zoning_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/madodoso/presentation/pages/madodoso_page.dart';
import '../../features/land_use/survey/presentation/pages/questionnaire_form_page.dart';
import '../../shared/widgets/app_shell.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/land_use/dashboard/presentation/providers/project_providers.dart';

/// Wrapper widget that fetches project data and navigates to ZoningPage
class ZoningPageWrapper extends ConsumerWidget {
  final String projectId;

  const ZoningPageWrapper({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectProvider(projectId));

    return projectAsync.when(
      data: (project) => ZoningPage(
        projectId: projectId,
        localityId: project.localityId,
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: const Text('Hitilafu'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Imeshindikana kupakia data ya mradi',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Rudi Nyuma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          // SETTINGS
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
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
