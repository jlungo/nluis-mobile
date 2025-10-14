import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum FormCompletionState { notStarted, inProgress, complete }

extension FormCompletionStateDisplay on FormCompletionState {
  String get label {
    switch (this) {
      case FormCompletionState.complete:
        return 'Imekamilika';
      case FormCompletionState.inProgress:
        return 'Inaendelea';
      case FormCompletionState.notStarted:
        return 'Haijaanza';
    }
  }

  IconData get icon {
    switch (this) {
      case FormCompletionState.complete:
        return Icons.check_circle;
      case FormCompletionState.inProgress:
        return Icons.pending_outlined;
      case FormCompletionState.notStarted:
        return Icons.radio_button_unchecked;
    }
  }

  Color foregroundColor(bool isDark) {
    switch (this) {
      case FormCompletionState.complete:
        return isDark ? AppColors.successDark : AppColors.success;
      case FormCompletionState.inProgress:
        return isDark ? AppColors.warningDark : AppColors.warning;
      case FormCompletionState.notStarted:
        return isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    }
  }

  Color backgroundColor(bool isDark) {
    switch (this) {
      case FormCompletionState.complete:
        return (isDark ? AppColors.successDark : AppColors.success)
            .withValues(alpha: isDark ? 0.15 : 0.12);
      case FormCompletionState.inProgress:
        return (isDark ? AppColors.warningDark : AppColors.warning)
            .withValues(alpha: isDark ? 0.2 : 0.16);
      case FormCompletionState.notStarted:
        return (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
            .withValues(alpha: isDark ? 0.12 : 0.08);
    }
  }
}
