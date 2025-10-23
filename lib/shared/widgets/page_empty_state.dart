import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class EmptyPageState extends StatelessWidget {
  const EmptyPageState({
    super.key,
    required this.context,
    required this.isDark,
    required this.heading,
    required this.description,
    this.isError = false,
    this.actionButton,
  });

  final BuildContext context;
  final bool isDark;
  final String heading;
  final String description;
  final bool isError;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isError
                        ? AppColors.error.withValues(alpha: 0.1)
                        : AppColors.info.withValues(alpha: 0.1),
                    isError
                        ? AppColors.error.withValues(alpha: 0.05)
                        : AppColors.info.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.info.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.assignment_late_outlined,
                size: 48,
                color: isError ? AppColors.error : AppColors.info,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              heading,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
            actionButton != null
                ? Padding(
                  padding: const EdgeInsets.only(top: AppConstants.spacingLg),
                  child: actionButton!,
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
