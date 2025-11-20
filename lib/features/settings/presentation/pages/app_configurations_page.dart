import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../providers/setup_providers.dart';

class AppConfigurationsPage extends ConsumerStatefulWidget {
  const AppConfigurationsPage({super.key});

  @override
  ConsumerState<AppConfigurationsPage> createState() =>
      _AppConfigurationsPageState();
}

class _AppConfigurationsPageState extends ConsumerState<AppConfigurationsPage> {
  final Map<String, TextEditingController> _bufferControllers = {
    'point': TextEditingController(),
    'lineString': TextEditingController(),
    'polygon': TextEditingController(),
  };

  @override
  void dispose() {
    for (final controller in _bufferControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final landUsesAsync = ref.watch(localLandUsesProvider);
    final bufferDefaultsAsync = ref.watch(bufferDefaultsProvider);

    // Initialize buffer controllers
    bufferDefaultsAsync.whenData((defaults) {
      if (_bufferControllers['point']!.text.isEmpty) {
        _bufferControllers['point']!.text = defaults['point']!.toString();
        _bufferControllers['lineString']!.text =
            defaults['lineString']!.toString();
        _bufferControllers['polygon']!.text = defaults['polygon']!.toString();
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const CustomAppBar(
        title: 'Mipangilio ya Programu',
        showBackButton: true,
        showProfile: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Land Uses Section
            _buildSectionHeader(context, 'MATUMIZI YA ARDHI'),
            const SizedBox(height: AppConstants.spacingSm),
            _buildLandUsesCard(landUsesAsync, isDark, theme),
            const SizedBox(height: AppConstants.spacingLg),

            // Buffer Defaults Section
            _buildSectionHeader(context, 'BUFFER CHAGUO-MSINGI'),
            const SizedBox(height: AppConstants.spacingSm),
            _buildBufferDefaultsCard(bufferDefaultsAsync, isDark, theme),
            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLandUsesCard(
    AsyncValue landUsesAsync,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.darkShadow
                    : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.successDark : AppColors.success)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.landscape_outlined,
                color: isDark ? AppColors.successDark : AppColors.success,
                size: 24,
              ),
            ),
            title: Text(
              'Matumizi ya Ardhi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: landUsesAsync.when(
              data:
                  (landUses) => Text(
                    '${landUses.length} aina zimehifadhiwa',
                    style: TextStyle(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
              loading: () => const Text('Inapakia...'),
              error: (_, _) => const Text('Hakuna data'),
            ),
            trailing: ElevatedButton.icon(
              onPressed: () => _handleReloadLandUses(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Sasisha'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.darkPrimary : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBufferDefaultsCard(
    AsyncValue<Map<String, double>> bufferDefaultsAsync,
    bool isDark,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.darkShadow
                    : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weka Buffer Chaguo-Msingi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Buffer (kwa mita) itakayotumika kwaajili ya vipengele vipya',
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildBufferInput('Point', 'point', isDark, theme),
            const SizedBox(height: AppConstants.spacingSm),
            _buildBufferInput('Line', 'lineString', isDark, theme),
            const SizedBox(height: AppConstants.spacingSm),
            _buildBufferInput('Polygon', 'polygon', isDark, theme),
            const SizedBox(height: AppConstants.spacingMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleSaveBufferDefaults(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                ),
                child: const Text(
                  'Hifadhi Mabadiliko',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBufferInput(
    String label,
    String key,
    bool isDark,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextField(
            controller: _bufferControllers[key],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              suffixText: 'm',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleReloadLandUses() async {
    await ref.read(setupStateProvider.notifier).fetchLandUses();
    ref.invalidate(localLandUsesProvider);

    if (mounted) {
      SnackBarUtils.showSuccess(context, 'Matumizi ya ardhi yamepakiwa');
    }
  }

  Future<void> _handleSaveBufferDefaults() async {
    try {
      final defaults = {
        'point': double.tryParse(_bufferControllers['point']!.text) ?? 0.0,
        'lineString':
            double.tryParse(_bufferControllers['lineString']!.text) ?? 0.0,
        'polygon': double.tryParse(_bufferControllers['polygon']!.text) ?? 0.0,
      };

      await ref
          .read(setupStateProvider.notifier)
          .updateBufferDefaults(defaults);
      ref.invalidate(bufferDefaultsProvider);

      if (mounted) {
        SnackBarUtils.showSuccess(
          context,
          'Buffer chaguo-msingi zimehifadhiwa',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    }
  }
}
