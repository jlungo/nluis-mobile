import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'form_completion_state.dart';

class FormStatusBadge extends StatelessWidget {
  final FormCompletionState status;
  final bool isDark;

  const FormStatusBadge({
    super.key,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor(isDark).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: status.backgroundColor(isDark)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.foregroundColor(isDark)),
          const SizedBox(width: AppConstants.spacingXs),
          Text(
            status.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: status.foregroundColor(isDark),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
