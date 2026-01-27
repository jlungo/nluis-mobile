import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class FormFieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const FormFieldLabel({
    super.key,
    required this.label,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RichText(
      text: TextSpan(
        text: label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: isDark ? AppColors.errorDark : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
