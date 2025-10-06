import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../providers/auth_providers.dart';
import '../../../auth/domain/entities/user.dart';

class ModuleSwitchboardPage extends ConsumerWidget {
  const ModuleSwitchboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(
      authStateProvider.select((state) => state.valueOrNull),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingLg,
                AppConstants.spacingLg,
                AppConstants.spacingLg,
                AppConstants.spacingMd,
              ),
              child: Column(
                children: [
                  // Logo and Title Row
                  Row(
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingSm),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.8),
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
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMd),
                      // Title and User Info
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
                            const SizedBox(height: 4),
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

            // Module Grid
            Expanded(
              child:
                  user == null
                      ? const Center(child: Text('Hakuna mtumiaji'))
                      : Builder(
                        builder: (context) {
                          final modules = user.modules;

                          if (modules.isEmpty) {
                            return const Center(
                              child: Text('Hakuna moduli zilizotolewa'),
                            );
                          }

                          if (modules.length == 1) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _navigateToModule(context, ref, modules.first);
                            });
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(
                              AppConstants.spacingLg,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppConstants.spacingMd,
                                  mainAxisSpacing: AppConstants.spacingMd,
                                  childAspectRatio: 1.0,
                                ),
                            itemCount: modules.length,
                            itemBuilder: (context, index) {
                              final module = modules[index];
                              return _ModernModuleCard(
                                module: module,
                                onTap:
                                    () =>
                                        _navigateToModule(context, ref, module),
                              );
                            },
                          );
                        },
                      ),
            ),

            // Logout Button
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
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
                    onPressed: () async {
                      await ref.read(authStateProvider.notifier).logout();
                      if (context.mounted) {
                        context.goNamed('login');
                      }
                    },
                    icon: Icon(Icons.logout, color: theme.colorScheme.error),
                    label: Text(
                      'Toka',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: theme.colorScheme.error.withValues(alpha: 0.5),
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
      ),
    );
  }

  void _navigateToModule(
    BuildContext context,
    WidgetRef ref,
    UserModule module,
  ) {
    ref.read(authStateProvider.notifier).setActiveModule(module.id);

    final moduleId = module.id;

    switch (moduleId) {
      case ModuleType.landUse:
        context.goNamed('luDashboard');
        break;
      case ModuleType.landSubDivision:
        SnackBarUtils.showInfo(context, 'Moduli ya CCRO bado haijatekelezwa');
        break;
      case ModuleType.monitoringAndEvaluation:
        SnackBarUtils.showInfo(context, 'Moduli ya M&E haijatekelezwa bado');
        break;
      case ModuleType.compliance:
        SnackBarUtils.showInfo(
          context,
          'Moduli ya Compliance haijatekelezwa bado',
        );
        break;
      default:
        SnackBarUtils.showWarning(context, 'Moduli haijulikani: ${module.id}');
    }
  }
}

class _ModernModuleCard extends StatefulWidget {
  final UserModule module;
  final VoidCallback onTap;

  const _ModernModuleCard({required this.module, required this.onTap});

  @override
  State<_ModernModuleCard> createState() => _ModernModuleCardState();
}

class _ModernModuleCardState extends State<_ModernModuleCard>
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
      case ModuleType.landUse:
        return Icons.landscape_outlined;
      case ModuleType.landSubDivision:
        return Icons.description_outlined;
      case ModuleType.monitoringAndEvaluation:
        return Icons.analytics_outlined;
      case ModuleType.compliance:
        return Icons.check_circle_outline;
      default:
        return Icons.apps;
    }
  }

  String _getModuleTitle(int moduleId) {
    switch (moduleId) {
      case ModuleType.landUse:
        return ModuleType.labels[ModuleType.landUse] ?? 'Matumizi ya Ardhi';
      case ModuleType.landSubDivision:
        return ModuleType.labels[ModuleType.landSubDivision] ?? 'CCRO';
      case ModuleType.monitoringAndEvaluation:
        return ModuleType.labels[ModuleType.monitoringAndEvaluation] ??
            'Ufuatiliaji & Tathmini';
      case ModuleType.compliance:
        return ModuleType.labels[ModuleType.compliance] ?? 'Uzingatiaji';
      default:
        return 'Haijulikani';
    }
  }

  Color _getModuleGradientStart(int moduleId) {
    switch (moduleId) {
      case ModuleType.landUse:
        return const Color(0xFF1976D2);
      case ModuleType.landSubDivision:
        return const Color(0xFF00ACC1);
      case ModuleType.monitoringAndEvaluation:
        return const Color(0xFF5E35B1);
      case ModuleType.compliance:
        return const Color(0xFF43A047);
      default:
        return AppColors.primary;
    }
  }

  Color _getModuleGradientEnd(int moduleId) {
    switch (moduleId) {
      case ModuleType.landUse:
        return const Color(0xFF1565C0);
      case ModuleType.landSubDivision:
        return const Color(0xFF0097A7);
      case ModuleType.monitoringAndEvaluation:
        return const Color(0xFF512DA8);
      case ModuleType.compliance:
        return const Color(0xFF388E3C);
      default:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                _getModuleGradientStart(widget.module.id),
                _getModuleGradientEnd(widget.module.id),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            boxShadow: [
              BoxShadow(
                color: _getModuleGradientStart(
                  widget.module.id,
                ).withValues(alpha: 0.3),
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
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getModuleIcon(widget.module.id),
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      _getModuleTitle(widget.module.id),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.2,
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
