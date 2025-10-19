import 'package:flutter/material.dart';
import 'dart:io';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';

class FileFormFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final File? value;
  final void Function()? onPickFile;
  final void Function()? onRemove;
  final bool enabled;

  const FileFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    required this.onPickFile,
    this.onRemove,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: isDark ? AppColors.errorDark : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        if (value != null) ...[
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Text(
                    value!.path.split('/').last,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onRemove != null && enabled)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? AppColors.errorDark : AppColors.error,
                    ),
                    onPressed: onRemove,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
        ],
        OutlinedButton.icon(
          onPressed: enabled ? onPickFile : null,
          icon: Icon(
            value != null ? Icons.change_circle : Icons.upload_file,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
          ),
          label: Text(
            value != null ? 'Badilisha faili' : 'Chagua faili',
            style: TextStyle(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        ),
      ],
    );
  }
}
