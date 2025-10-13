import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';

class TextareaFormFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool required;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;

  const TextareaFormFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    this.required = false,
    required this.controller,
    this.validator,
    this.maxLines = 4,
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
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder ?? label,
            filled: true,
            fillColor:
                isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: isDark ? AppColors.errorDark : AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
