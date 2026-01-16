import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/env/env.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input_field.dart';
import '../../../../shared/widgets/overlay_loader.dart';
import '../../../../shared/states/page_state.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  PageState _pageState = PageState.success;
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
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              setState(() => _pageState = PageState.success);
              context.read<AuthBloc>().add(UserLoggedIn(state.user));

              // Navigate directly to module if user has only one
              final modules = state.user.mobileModules;
              if (modules.length == 1) {
                final moduleId = modules.first['module_id'] as int;
                switch (moduleId) {
                  case 1:
                    context.go('/land-use');
                    break;
                  case 2:
                    context.go('/adjudication');
                    break;
                  case 3:
                    context.go('/monitoring-evaluation');
                    break;
                  case 4:
                    context.go('/compliance');
                    break;
                  default:
                    context.go('/module-switchboard');
                }
              } else {
                context.go('/module-switchboard');
              }
            } else if (state is LoginFailed) {
              setState(() => _pageState = PageState.loadFailed);
              SnackBarUtils.showError(context, state.message);
            } else if (state is LoginLoading) {
              setState(() => _pageState = PageState.loading);
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;

              return OverlayLoader(
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
                      Positioned(
                        top: -100,
                        right: -100,
                        child: Container(
                          width: ResponsiveUtils.value(
                            context,
                            mobile: 250.0,
                            tablet: 350.0,
                          ),
                          height: ResponsiveUtils.value(
                            context,
                            mobile: 250.0,
                            tablet: 350.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        left: -80,
                        child: Container(
                          width: ResponsiveUtils.value(
                            context,
                            mobile: 200.0,
                            tablet: 300.0,
                          ),
                          height: ResponsiveUtils.value(
                            context,
                            mobile: 200.0,
                            tablet: 300.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.08,
                                ),
                                theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                AppConstants.spacingLg,
                              ),
                            ),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo/nlupc_logo.png',
                                    width: ResponsiveUtils.value(
                                      context,
                                      mobile: 100.0,
                                      tablet: 140.0,
                                    ),
                                    height: ResponsiveUtils.value(
                                      context,
                                      mobile: 100.0,
                                      tablet: 140.0,
                                    ),
                                    fit: BoxFit.cover,
                                  ),

                                  SizedBox(
                                    height: ResponsiveUtils.spacing(
                                      context,
                                      AppConstants.spacingMd,
                                    ),
                                  ),

                                  Text(
                                    Env.appName,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                  ),

                                  SizedBox(
                                    height: ResponsiveUtils.spacing(
                                      context,
                                      AppConstants.spacingSm,
                                    ),
                                  ),

                                  Text(
                                    Env.appDescription,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary
                                          .withValues(alpha: 0.9),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  SizedBox(
                                    height: ResponsiveUtils.spacing(
                                      context,
                                      AppConstants.spacing2xl,
                                    ),
                                  ),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 15,
                                        sigmaY: 15,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          ResponsiveUtils.spacing(
                                            context,
                                            AppConstants.spacingLg,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors:
                                                theme.brightness ==
                                                        Brightness.dark
                                                    ? [
                                                      AppColors
                                                          .darkGlassBackground
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                      AppColors.darkSurface
                                                          .withValues(
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
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color:
                                                theme.brightness ==
                                                        Brightness.dark
                                                    ? AppColors.darkDivider
                                                        .withValues(alpha: 0.5)
                                                    : Colors.white.withValues(
                                                      alpha: 0.3,
                                                    ),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  theme.brightness ==
                                                          Brightness.dark
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
                                                style: theme
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      color:
                                                          theme.brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? AppColors
                                                                  .darkTextPrimary
                                                              : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: ResponsiveUtils.spacing(
                                                  context,
                                                  AppConstants.spacingXl,
                                                ),
                                              ),

                                              AppInputField(
                                                useFormField: true,
                                                controller: _emailController,
                                                labelText: 'Barua pepe',
                                                hintText:
                                                    'Ingiza barua pepe yako',
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                prefixIcon:
                                                    Icons.email_outlined,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Tafadhali ingiza barua pepe';
                                                  }
                                                  if (!value.contains('@')) {
                                                    return 'Barua pepe si sahihi';
                                                  }
                                                  return null;
                                                },
                                                fillColor:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? AppColors
                                                            .darkSurfaceVariant
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                        : Colors.white
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                borderColor:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? AppColors.darkDivider
                                                        : Colors.white
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                hintColor:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                        : Colors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                              ),

                                              SizedBox(
                                                height: ResponsiveUtils.spacing(
                                                  context,
                                                  AppConstants.spacingMd,
                                                ),
                                              ),

                                              AppInputField(
                                                useFormField: true,
                                                controller: _passwordController,
                                                labelText: 'Neno la siri',
                                                hintText: 'Ingiza neno la siri',
                                                obscureText: _obscurePassword,
                                                prefixIcon: Icons.lock_outlined,
                                                suffixIcon:
                                                    _obscurePassword
                                                        ? Icons
                                                            .visibility_off_outlined
                                                        : Icons
                                                            .visibility_outlined,
                                                onSuffixTap: () {
                                                  setState(
                                                    () =>
                                                        _obscurePassword =
                                                            !_obscurePassword,
                                                  );
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Tafadhali ingiza neno la siri';
                                                  }
                                                  if (value.length < 4) {
                                                    return 'Neno la siri linatakiwa liwe na herufi 6 au zaidi';
                                                  }
                                                  return null;
                                                },
                                                fillColor:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? AppColors
                                                            .darkSurfaceVariant
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                        : Colors.white
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                borderColor:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? AppColors.darkDivider
                                                        : Colors.white
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                hintColor:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                        : Colors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                              ),

                                              SizedBox(
                                                height: ResponsiveUtils.spacing(
                                                  context,
                                                  AppConstants.spacingMd,
                                                ),
                                              ),

                                              AppButton(
                                                label: 'Ingia',
                                                onPressed: _handleLogin,
                                                gradientColors:
                                                    theme.brightness ==
                                                            Brightness.dark
                                                        ? [
                                                          AppColors.darkPrimary,
                                                          AppColors
                                                              .darkPrimaryDark,
                                                        ]
                                                        : [
                                                          AppColors.primary,
                                                          AppColors.primaryDark,
                                                        ],
                                                textStyle: TextStyle(
                                                  fontSize:
                                                      ResponsiveUtils.fontSize(
                                                        context,
                                                        18,
                                                      ),
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      theme.brightness ==
                                                              Brightness.dark
                                                          ? AppColors
                                                              .darkTextInverse
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

                                  SizedBox(
                                    height: ResponsiveUtils.spacing(
                                      context,
                                      AppConstants.spacing2xl * 2,
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.spacing(
                                        context,
                                        AppConstants.spacingMd,
                                      ),
                                      vertical: ResponsiveUtils.spacing(
                                        context,
                                        AppConstants.spacingSm,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          theme.brightness == Brightness.dark
                                              ? AppColors.darkSurface
                                                  .withValues(alpha: 0.3)
                                              : Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? AppColors.darkDivider
                                                : Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                      ),
                                    ),
                                    child: Text(
                                      'Version ${Env.appVersion}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onPrimary
                                                .withValues(alpha: 0.7),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
