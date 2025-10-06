import 'package:flutter/material.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/app_drawer.dart';

class DraftDodososPage extends StatefulWidget {
  const DraftDodososPage({super.key});

  @override
  State<DraftDodososPage> createState() => _DraftDodososPageState();
}

class _DraftDodososPageState extends State<DraftDodososPage> {
  // Mock draft dodosos
  List<_DraftDodosoItem> _drafts = [
    _DraftDodosoItem(
      id: '1',
      type: 'Dodoso la Matumizi ya Ardhi ya Makazi',
      projectName: 'Mradi wa Kinondoni',
      savedDate: 'Oktoba 5, 2025',
      completionPercentage: 65,
      lastEditedBy: 'John Doe',
    ),
    _DraftDodosoItem(
      id: '2',
      type: 'Dodoso la Matumizi ya Ardhi ya Kilimo',
      projectName: 'Mradi wa Temeke',
      savedDate: 'Oktoba 3, 2025',
      completionPercentage: 40,
      lastEditedBy: 'Jane Smith',
    ),
    _DraftDodosoItem(
      id: '3',
      type: 'Dodoso la Maeneo ya Kibiashara',
      projectName: 'Mradi wa Ilala',
      savedDate: 'Oktoba 1, 2025',
      completionPercentage: 80,
      lastEditedBy: 'Mike Johnson',
    ),
  ];

  void _deleteDraft(String id) {
    setState(() {
      _drafts.removeWhere((draft) => draft.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rasimu imefutwa'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(BuildContext context, _DraftDodosoItem draft) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 28,
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: Text(
                'Thibitisha Kufuta',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Je, una uhakika unataka kufuta rasimu hii?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.type,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    draft.projectName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Kitendo hiki hakiwezi kutenduliwa nyuma.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Ghairi',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDraft(draft.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
            ),
            child: const Text('Futa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rasimu za Dodoso',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Text(
                    'Dodoso zilizohifadhiwa kama rasimu katika miradi yote',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_drafts.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.info.withValues(alpha: 0.1),
                              AppColors.info.withValues(alpha: 0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.drafts_outlined,
                          size: 80,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Hakuna Rasimu',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rasimu zako zitaonyeshwa hapa',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                    vertical: AppConstants.spacingSm,
                  ),
                  itemCount: _drafts.length,
                  itemBuilder: (context, index) {
                    return _DraftCard(
                      draft: _drafts[index],
                      isDark: isDark,
                      onDelete: () => _confirmDelete(context, _drafts[index]),
                      onEdit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Endelea kuhariri: ${_drafts[index].type}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DraftDodosoItem {
  final String id;
  final String type;
  final String projectName;
  final String savedDate;
  final int completionPercentage;
  final String lastEditedBy;

  _DraftDodosoItem({
    required this.id,
    required this.type,
    required this.projectName,
    required this.savedDate,
    required this.completionPercentage,
    required this.lastEditedBy,
  });
}

class _DraftCard extends StatelessWidget {
  final _DraftDodosoItem draft;
  final bool isDark;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _DraftCard({
    required this.draft,
    required this.isDark,
    required this.onDelete,
    required this.onEdit,
  });

  IconData _getIconForType(String type) {
    if (type.contains('Makazi')) return Icons.home_outlined;
    if (type.contains('Kilimo')) return Icons.agriculture_outlined;
    if (type.contains('Biashara')) return Icons.store_mall_directory_outlined;
    return Icons.description_outlined;
  }

  Color _getColorForPercentage(int percentage) {
    if (percentage >= 70) return AppColors.success;
    if (percentage >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(AppConstants.spacingMd),
            leading: Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                      : [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(
                _getIconForType(draft.type),
                color: isDark ? AppColors.darkTextInverse : Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              draft.type,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingXs),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      draft.projectName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      draft.savedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Endelea Kuhariri',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Futa',
                        style: TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Umekamilika',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${draft.completionPercentage}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getColorForPercentage(draft.completionPercentage),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  child: LinearProgressIndicator(
                    value: draft.completionPercentage / 100,
                    backgroundColor: isDark
                        ? AppColors.darkDivider
                        : AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForPercentage(draft.completionPercentage),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppConstants.radiusMd),
                bottomRight: Radius.circular(AppConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ilihaririwa na ${draft.lastEditedBy}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
