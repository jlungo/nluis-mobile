import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nluis_app/core/env/env.dart';
import '../../../../shared/constants/app_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2000));
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
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
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
                              color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
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
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
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

                  // Loading indicator
                  SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          minHeight: 3,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),

                  const SizedBox(height: AppConstants.spacing2xl * 2),

                  // Version
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      border: Border.all(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Version ${Env.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
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
