import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nluis_app/core/env/env.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../core/network/network_info.dart';
import '../providers/auth_providers.dart';
import '../../../settings/presentation/providers/setup_providers.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  String _statusMessage = 'Initializing...';
  bool _isCheckingAuth = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initial delay for splash animation
    await Future.delayed(const Duration(milliseconds: 3000));

    setState(() {
      _statusMessage = 'Checking network connection...';
    });

    // Check network connectivity
    final networkInfo = ref.read(networkInfoProvider);
    final hasConnection = await networkInfo.isConnected;
    final hasInternet =
        hasConnection ? await networkInfo.hasInternetConnection : false;

    if (hasInternet) {
      setState(() {
        _statusMessage = 'Validating session...';
        _isCheckingAuth = true;
      });

      // Only check authentication when online
      await _validateSession();
    } else {
      setState(() {
        _statusMessage =
            hasConnection
                ? 'No internet connection. Working offline...'
                : 'No network connection. Working offline...';
      });

      // Delay to show offline message, then proceed to offline mode
      await Future.delayed(const Duration(milliseconds: 1000));
      _navigateToOfflineMode();
    }
  }

  Future<void> _validateSession() async {
    try {
      // Force refresh auth state to validate session by reading current user
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.getCurrentUser();

      result.fold(
        (failure) {
          setState(() {
            _statusMessage = 'Session expired. Please login...';
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) context.go('/login');
          });
        },
        (user) async {
          if (user != null) {
            setState(() {
              _statusMessage = 'Session valid. Loading configurations...';
            });
            
            // Fetch land uses and other setup data in background
            ref.read(setupStateProvider.notifier).fetchLandUses().catchError((_) {
              // Silently fail - user can manually refresh from settings
            });
            
            await Future.delayed(const Duration(milliseconds: 800));
            setState(() {
              _statusMessage = 'Redirecting...';
            });
            
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) context.go('/module-switch');
            });
          } else {
            setState(() {
              _statusMessage = 'No active session. Please login...';
            });
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) context.go('/login');
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Authentication error. Please login...';
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) context.go('/login');
      });
    }
  }

  void _navigateToOfflineMode() {
    // In offline mode, check if user was previously logged in locally
    final authState = ref.read(authStateProvider);
    authState.when(
      data: (user) {
        if (user != null) {
          // User has local session, proceed to app
          if (mounted) context.go('/module-switch');
        } else {
          // No local session, require login
          if (mounted) context.go('/login');
        }
      },
      loading: () {
        // Wait for auth state to load
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _navigateToOfflineMode();
        });
      },
      error: (_, _) {
        // Error in auth state, require login
        if (mounted) context.go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                    width: 300,
                    height: 300,
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
              bottom: -50,
              left: -50,
              child: Container(
                    width: 200,
                    height: 200,
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
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow effect
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
                          width: 120,
                          height: 120,
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

                  // Status message
                  Text(
                    _statusMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Loading indicator
                  if (_isCheckingAuth) ...[
                    SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            backgroundColor: theme.colorScheme.onPrimary
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            minHeight: 3,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                  ] else ...[
                    SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            backgroundColor: theme.colorScheme.onPrimary
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            minHeight: 3,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                  ],

                  const SizedBox(height: AppConstants.spacing2xl),

                  // Version
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
