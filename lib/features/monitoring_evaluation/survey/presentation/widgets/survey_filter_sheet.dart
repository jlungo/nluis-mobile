import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';

enum SurveyFilterType { all, drafts, completed, pending, failed }

class SurveyFilterSheet extends StatefulWidget {
  final SurveyFilterType currentFilter;
  final Function(SurveyFilterType) onFilterChanged;
  final String? searchQuery;
  final Function(String) onSearchChanged;
  final DateTimeRange? dateRange;
  final Function(DateTimeRange?)? onDateRangeChanged;

  const SurveyFilterSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    this.searchQuery,
    required this.onSearchChanged,
    this.dateRange,
    this.onDateRangeChanged,
  });

  @override
  State<SurveyFilterSheet> createState() => _SurveyFilterSheetState();

  static void show(
    BuildContext context, {
    required SurveyFilterType currentFilter,
    required Function(SurveyFilterType) onFilterChanged,
    String? searchQuery,
    required Function(String) onSearchChanged,
    DateTimeRange? dateRange,
    Function(DateTimeRange?)? onDateRangeChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SurveyFilterSheet(
            currentFilter: currentFilter,
            onFilterChanged: onFilterChanged,
            searchQuery: searchQuery,
            onSearchChanged: onSearchChanged,
            dateRange: dateRange,
            onDateRangeChanged: onDateRangeChanged,
          ),
    );
  }
}

class _SurveyFilterSheetState extends State<SurveyFilterSheet> {
  late TextEditingController _searchController;
  late SurveyFilterType _selectedFilter;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _selectedFilter = widget.currentFilter;
    _selectedDateRange = widget.dateRange;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLg),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppConstants.spacingSm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Row(
              children: [
                Text(
                  'Chuja Dodoso',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = SurveyFilterType.all;
                      _searchController.clear();
                      _selectedDateRange = null;
                    });
                  },
                  child: const Text('Futa'),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tafuta kwa jina la dodoso...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          const SizedBox(height: AppConstants.spacingLg),

          // Filter options
          _FilterOption(
            icon: Icons.all_inclusive,
            label: 'Zote',
            isSelected: _selectedFilter == SurveyFilterType.all,
            isDark: isDark,
            onTap: () => setState(() => _selectedFilter = SurveyFilterType.all),
          ),
          _FilterOption(
            icon: Icons.edit_outlined,
            label: 'Rasimu',
            isSelected: _selectedFilter == SurveyFilterType.drafts,
            isDark: isDark,
            onTap:
                () => setState(() => _selectedFilter = SurveyFilterType.drafts),
          ),
          _FilterOption(
            icon: Icons.check_circle_outline,
            label: 'Zimekamilika',
            isSelected: _selectedFilter == SurveyFilterType.completed,
            isDark: isDark,
            onTap:
                () => setState(
                  () => _selectedFilter = SurveyFilterType.completed,
                ),
          ),
          _FilterOption(
            icon: Icons.cloud_upload_outlined,
            label: 'Zinasubiri Kupakiwa',
            isSelected: _selectedFilter == SurveyFilterType.pending,
            isDark: isDark,
            onTap:
                () =>
                    setState(() => _selectedFilter = SurveyFilterType.pending),
          ),
          _FilterOption(
            icon: Icons.error_outline,
            label: 'Zimeshindikana',
            isSelected: _selectedFilter == SurveyFilterType.failed,
            isDark: isDark,
            onTap:
                () => setState(() => _selectedFilter = SurveyFilterType.failed),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterChanged(_selectedFilter);
                  widget.onSearchChanged(_searchController.text);
                  if (widget.onDateRangeChanged != null) {
                    widget.onDateRangeChanged!(_selectedDateRange);
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Tekeleza'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color:
              isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : null,
        ),
      ),
      trailing:
          isSelected
              ? Icon(
                Icons.check,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              )
              : null,
      onTap: onTap,
    );
  }
}
