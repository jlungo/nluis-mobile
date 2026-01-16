import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/states/page_state.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class ModuleSwitchboardPage extends StatefulWidget {
  const ModuleSwitchboardPage({super.key});

  @override
  State<ModuleSwitchboardPage> createState() => _ModuleSwitchboardPageState();
}

class _ModuleSwitchboardPageState extends State<ModuleSwitchboardPage> {
  PageState _pageState = PageState.loading;

  @override
  void initState() {
    super.initState();
    setState(() => _pageState = PageState.success);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;

          return SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveUtils.spacing(context, AppConstants.spacingLg),
                    ResponsiveUtils.spacing(context, AppConstants.spacingLg),
                    ResponsiveUtils.spacing(context, AppConstants.spacingLg),
                    ResponsiveUtils.spacing(context, AppConstants.spacingMd),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                AppConstants.spacingSm,
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo/nlupc_logo.png',
                              width: ResponsiveUtils.iconSize(context, 50),
                              height: ResponsiveUtils.iconSize(context, 50),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              AppConstants.spacingMd,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user != null
                                      ? 'Karibu, ${user.firstName}'
                                      : 'Karibu',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    AppConstants.spacingXs,
                                  ),
                                ),
                                Text(
                                  'Chagua moduli ya kuanza',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        theme.brightness == Brightness.dark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color:
                      theme.brightness == Brightness.dark
                          ? AppColors.darkDivider
                          : AppColors.divider,
                ),

                Expanded(
                  child:
                      user == null
                          ? Builder(
                            builder: (context) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.read<AuthBloc>().add(
                                  const UserLoggedOut(),
                                );
                                context.go('/login');
                              });
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                          : Builder(
                            builder: (context) {
                              final modules = user.mobileModules;

                              if (modules.isEmpty) {
                                return const Center(
                                  child: Text('Hakuna moduli zilizotolewa'),
                                );
                              }

                              if (modules.length == 1) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  _navigateToModule(context, modules.first);
                                });
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return GridView.builder(
                                padding: EdgeInsets.all(
                                  ResponsiveUtils.spacing(
                                    context,
                                    AppConstants.spacingLg,
                                  ),
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          ResponsiveUtils.gridColumns(
                                            context,
                                            mobileColumns: 2,
                                          ),
                                      crossAxisSpacing: ResponsiveUtils.spacing(
                                        context,
                                        AppConstants.spacingMd,
                                      ),
                                      mainAxisSpacing: ResponsiveUtils.spacing(
                                        context,
                                        AppConstants.spacingMd,
                                      ),
                                      childAspectRatio:
                                          ResponsiveUtils.gridAspectRatio(
                                            context,
                                            baseRatio: 1.0,
                                          ),
                                    ),
                                itemCount: modules.length,
                                itemBuilder: (context, index) {
                                  final module = modules[index];
                                  return _ModuleCard(
                                    module: module,
                                    onTap:
                                        () =>
                                            _navigateToModule(context, module),
                                  );
                                },
                              );
                            },
                          ),
                ),

                Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context, AppConstants.spacingLg),
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color:
                            theme.brightness == Brightness.dark
                                ? AppColors.darkShadow
                                : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(const UserLoggedOut());
                          context.go('/login');
                        },
                        icon: Icon(
                          Icons.logout,
                          color: theme.colorScheme.error,
                        ),
                        label: Text(
                          'Toka',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.spacing(
                              context,
                              AppConstants.spacingMd,
                            ),
                          ),
                          side: BorderSide(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.5,
                            ),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToModule(BuildContext context, Map<String, dynamic> module) {
    final moduleId = module['module_id'] as int;

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
        SnackBarUtils.showWarning(context, 'Moduli haijulikani: $moduleId');
    }
  }
}

class _ModuleCard extends StatefulWidget {
  final Map<String, dynamic> module;
  final VoidCallback onTap;

  const _ModuleCard({required this.module, required this.onTap});

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getModuleIcon(int moduleId) {
    switch (moduleId) {
      case 1:
        return Icons.landscape_outlined;
      case 2:
        return Icons.description_outlined;
      case 3:
        return Icons.analytics_outlined;
      case 4:
        return Icons.check_circle_outline;
      default:
        return Icons.apps;
    }
  }

  String _getModuleTitle(int moduleId) {
    switch (moduleId) {
      case 1:
        return 'Land Use';
      case 2:
        return 'Adjudication';
      case 3:
        return 'Monitoring & Evaluation';
      case 4:
        return 'Compliance';
      default:
        return 'Haijulikani';
    }
  }

  Color _getModuleGradientStart(int moduleId) {
    switch (moduleId) {
      case 1:
        return const Color(0xFF1976D2);
      case 2:
        return const Color(0xFF00ACC1);
      case 3:
        return const Color(0xFF5E35B1);
      case 4:
        return const Color(0xFF43A047);
      default:
        return AppColors.primary;
    }
  }

  Color _getModuleGradientEnd(int moduleId) {
    switch (moduleId) {
      case 1:
        return const Color(0xFF1565C0);
      case 2:
        return const Color(0xFF0097A7);
      case 3:
        return const Color(0xFF512DA8);
      case 4:
        return const Color(0xFF388E3C);
      default:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moduleId = widget.module['module_id'] as int;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getModuleGradientStart(moduleId),
                _getModuleGradientEnd(moduleId),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            boxShadow: [
              BoxShadow(
                color: _getModuleGradientStart(moduleId).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              child: Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(context, AppConstants.spacingLg),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          AppConstants.spacingMd,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getModuleIcon(moduleId),
                        size: ResponsiveUtils.iconSize(context, 40),
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        AppConstants.spacingSm,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        _getModuleTitle(moduleId),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: ResponsiveUtils.fontSize(context, 16),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
