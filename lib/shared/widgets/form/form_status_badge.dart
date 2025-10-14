import 'package:flutter/material.dart';
import 'package:nluis_app/shared/constants/app_constants.dart';
import 'package:nluis_app/shared/widgets/form/form_completion_state.dart';

class FormStatusBadge extends StatelessWidget {
  final FormCompletionState status;
  final bool isDark;
  final bool compact;

  const FormStatusBadge({
    super.key,
    required this.status,
    required this.isDark,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : AppConstants.spacingSm,
        vertical: compact ? 4 : AppConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor(isDark),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 16,
            color: status.foregroundColor(isDark),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            status.label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: status.foregroundColor(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
