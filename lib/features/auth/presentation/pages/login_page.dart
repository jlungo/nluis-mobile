import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nluis_app/core/env/env.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input_field.dart';
import '../../../../shared/widgets/overlay_loader.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authStateProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      if (!mounted) return;

      final authState = ref.read(authStateProvider);

      authState.when(
        data: (user) {
          if (user != null && mounted) {
            context.goNamed('moduleSwitch');
          }
        },
        loading: () {},
        error: (error, stack) {
          if (mounted) {
            SnackBarUtils.showError(context, error.toString());
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(
      authStateProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      body: OverlayLoader(
        isLoading: isLoading,
        child: Container(
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
              // Decorative circles
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                        theme.colorScheme.onPrimary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.onPrimary.withValues(alpha: 0.08),
                        theme.colorScheme.onPrimary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Main content
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/logo/nlupc_logo.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),

                          const SizedBox(height: AppConstants.spacingMd),

                          Text(
                            Env.appName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: AppConstants.spacingSm),

                          Text(
                            Env.appDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary.withValues(
                                alpha: 0.9,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppConstants.spacing2xl),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppConstants.spacingLg,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors:
                                        theme.brightness == Brightness.dark
                                            ? [
                                              AppColors.darkGlassBackground
                                                  .withValues(alpha: 0.8),
                                              AppColors.darkSurface.withValues(
                                                alpha: 0.6,
                                              ),
                                            ]
                                            : [
                                              Colors.white.withValues(
                                                alpha: 0.25,
                                              ),
                                              Colors.white.withValues(
                                                alpha: 0.15,
                                              ),
                                            ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color:
                                        theme.brightness == Brightness.dark
                                            ? AppColors.darkDivider.withValues(
                                              alpha: 0.5,
                                            )
                                            : Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          theme.brightness == Brightness.dark
                                              ? AppColors.darkShadow
                                              : Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Ingia NLUIS',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              color:
                                                  theme.brightness ==
                                                          Brightness.dark
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: AppConstants.spacingXl,
                                      ),

                                      // Email Field
                                      AppInputField(
                                        useFormField: true,
                                        controller: _emailController,
                                        labelText: 'Barua pepe',
                                        hintText: 'Ingiza barua pepe yako',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon: Icons.email_outlined,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Tafadhali ingiza barua pepe';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Barua pepe si sahihi';
                                          }
                                          return null;
                                        },
                                        fillColor:
                                            theme.brightness == Brightness.dark
                                                ? AppColors.darkSurfaceVariant
                                                    .withValues(alpha: 0.5)
                                                : Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                        borderColor:
                                            theme.brightness == Brightness.dark
                                                ? AppColors.darkDivider
                                                : Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                      ),

                                      const SizedBox(
                                        height: AppConstants.spacingMd,
                                      ),

                                      // Password Field
                                      AppInputField(
                                        useFormField: true,
                                        controller: _passwordController,
                                        labelText: 'Neno la siri',
                                        hintText: 'Ingiza neno la siri',
                                        obscureText: _obscurePassword,
                                        prefixIcon: Icons.lock_outlined,
                                        suffixIcon:
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                        onSuffixTap: () {
                                          setState(
                                            () =>
                                                _obscurePassword =
                                                    !_obscurePassword,
                                          );
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Tafadhali ingiza neno la siri';
                                          }
                                          if (value.length < 4) {
                                            return 'Neno la siri linatakiwa liwe na herufi 6 au zaidi';
                                          }
                                          return null;
                                        },
                                        fillColor:
                                            theme.brightness == Brightness.dark
                                                ? AppColors.darkSurfaceVariant
                                                    .withValues(alpha: 0.5)
                                                : Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                        borderColor:
                                            theme.brightness == Brightness.dark
                                                ? AppColors.darkDivider
                                                : Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                      ),

                                      const SizedBox(
                                        height: AppConstants.spacingMd,
                                      ),

                                      AppButton(
                                        label: 'Ingia',
                                        onPressed: _handleLogin,
                                        gradientColors:
                                            theme.brightness == Brightness.dark
                                                ? [
                                                  AppColors.darkPrimary,
                                                  AppColors.darkPrimaryDark,
                                                ]
                                                : [
                                                  AppColors.primary,
                                                  AppColors.primaryDark,
                                                ],
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              theme.brightness ==
                                                      Brightness.dark
                                                  ? AppColors.darkTextInverse
                                                  : Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppConstants.spacing2xl * 2),

                          // Version
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMd,
                              vertical: AppConstants.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  theme.brightness == Brightness.dark
                                      ? AppColors.darkSurface.withValues(
                                        alpha: 0.3,
                                      )
                                      : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    theme.brightness == Brightness.dark
                                        ? AppColors.darkDivider
                                        : Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'Version ${Env.appVersion}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.7,
                                ),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
