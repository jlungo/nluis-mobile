import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/env/env.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/states/page_state.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../../domain/entities/user.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PageState _pageState = PageState.loading;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  void _startInitialization() async {
    // Reduced delay for faster startup
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _statusMessage = 'Checking authentication...';
      });
      context.read<AuthBloc>().add(const AppStarted());
    }
  }

  void _handleAuthState(AuthState state) async {
    debugPrint('🔍 Auth state received: ${state.runtimeType}');

    if (state is Authenticated) {
      debugPrint('✅ User authenticated: ${state.user.firstName}');
      debugPrint('📦 Modules: ${state.user.mobileModules}');

      if (!mounted) {
        debugPrint('❌ Widget not mounted, cannot navigate');
        return;
      }

      setState(() {
        _pageState = PageState.success;
        _statusMessage = 'Welcome back!';
      });

      // Reduced delay for faster navigation
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) {
        debugPrint('❌ Widget not mounted after delay, cannot navigate');
        return;
      }

      final destination = _getRedirectDestination(state.user);
      debugPrint('🔄 Attempting navigation to: $destination');

      try {
        context.go(destination);
        debugPrint('✅ Navigation called successfully');
      } catch (e) {
        debugPrint('❌ Navigation error: $e');
      }
    } else if (state is Unauthenticated) {
      debugPrint('🚫 User not authenticated, going to login');

      setState(() {
        _pageState = PageState.success;
        _statusMessage = 'Redirecting to login...';
      });

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.go('/login');
      }
    } else if (state is SessionExpiredState) {
      debugPrint('⏰ Session expired');

      setState(() {
        _pageState = PageState.loadFailed;
        _statusMessage = 'Session expired. Please login...';
      });

      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        context.go('/login');
      }
    } else {
      debugPrint('❓ Unknown auth state: ${state.runtimeType}');
    }
  }

  String _getRedirectDestination(User user) {
    final modules = user.mobileModules;
    debugPrint('📊 Total modules: ${modules.length}');

    if (modules.isEmpty) {
      debugPrint('⚠️ No modules found, going to switchboard');
      return '/module-switchboard';
    }

    if (modules.length == 1) {
      final module = modules.first;
      final moduleId = module['module_id'] as int;
      debugPrint('🎯 Single module detected: $moduleId');

      switch (moduleId) {
        case 1:
          debugPrint('🌍 Navigating to Land Use');
          return '/land-use';
        case 2:
          debugPrint('📋 Navigating to Adjudication');
          return '/adjudication';
        case 3:
          debugPrint('📊 Navigating to M&E');
          return '/monitoring-evaluation';
        case 4:
          debugPrint('✅ Navigating to Compliance');
          return '/compliance';
        default:
          debugPrint('❓ Unknown module, going to switchboard');
          return '/module-switchboard';
      }
    }

    debugPrint('🔀 Multiple modules, going to switchboard');
    return '/module-switchboard';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _handleAuthState(state);
      },
      child: _buildSplashContent(theme),
    );
  }

  Widget _buildSplashContent(ThemeData theme) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 1.2),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: ResponsiveUtils.spacing(context, -100),
              right: ResponsiveUtils.spacing(context, -100),
              child: Container(
                    width: ResponsiveUtils.spacing(context, 300),
                    height: ResponsiveUtils.spacing(context, 300),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 3000.ms,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.2, 1.2),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: 3000.ms,
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(0.8, 0.8),
                    curve: Curves.easeInOut,
                  ),
            ),
            Positioned(
              bottom: ResponsiveUtils.spacing(context, -50),
              left: ResponsiveUtils.spacing(context, -50),
              child: Container(
                    width: ResponsiveUtils.spacing(context, 200),
                    height: ResponsiveUtils.spacing(context, 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onPrimary.withValues(
                        alpha: 0.05,
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 4000.ms,
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.3, 1.3),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: 4000.ms,
                    begin: const Offset(1.3, 1.3),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeInOut,
                  ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                        padding: const EdgeInsets.all(AppConstants.spacingLg),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.onPrimary.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo/nlupc_logo.png',
                          width: ResponsiveUtils.iconSize(context, 120),
                          height: ResponsiveUtils.iconSize(context, 120),
                          fit: BoxFit.cover,
                        ),
                      )
                      .animate()
                      .scale(duration: 800.ms, curve: Curves.elasticOut)
                      .fadeIn(duration: 600.ms)
                      .then()
                      .shimmer(
                        duration: 2000.ms,
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.3,
                        ),
                      ),

                  const SizedBox(height: AppConstants.spacingXl),

                  Text(
                        Env.appName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                  const SizedBox(height: AppConstants.spacingMd),

                  Text(
                    _statusMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                  const SizedBox(height: AppConstants.spacingLg),

                  SizedBox(
                        width: ResponsiveUtils.spacing(context, 200),
                        child: LinearProgressIndicator(
                          backgroundColor: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          minHeight: 3,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),

                  const SizedBox(height: AppConstants.spacing2xl),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLg,
                      ),
                      border: Border.all(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.2,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Version ${Env.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 1000.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
