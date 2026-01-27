import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import 'form_field_label.dart';

class FileFormFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final String? value;
  final void Function(String?)? onChanged;
  final bool enabled;
  final List<String>? allowedExtensions;

  const FileFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.allowedExtensions,
  });

  Future<void> _pickFile(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        onChanged!(result.files.single.path!);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imeshindikana kuchagua faili. Jaribu tena.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeFile() {
    if (enabled && onChanged != null) {
      onChanged!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasFile = value != null && value!.isNotEmpty;
    final fileName = hasFile ? path.basename(value!) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: label, required: required),
        const SizedBox(height: AppConstants.spacingSm),
        if (hasFile)
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(
                    Icons.insert_drive_file,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Faili limehifadhiwa',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (enabled) ...[
                  IconButton(
                    icon: Icon(
                      Icons.visibility,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      // Preview file - could open file viewer
                    },
                    tooltip: 'Angalia faili',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: isDark ? AppColors.errorDark : AppColors.error,
                    ),
                    onPressed: _removeFile,
                    tooltip: 'Ondoa faili',
                  ),
                ],
              ],
            ),
          )
        else
          InkWell(
            onTap: enabled ? () => _pickFile(context) : null,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Bonyeza kuchagua faili',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Text(
                    allowedExtensions != null
                        ? 'Aina za faili zinazoruhusiwa: ${allowedExtensions!.join(", ")}'
                        : 'Aina yoyote ya faili inaruhusiwa',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
