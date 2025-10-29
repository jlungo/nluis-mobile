import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DialogUtils {
  DialogUtils._(); // Private constructor to prevent instantiation

  /// Shows a loading dialog with circular progress indicator
  static void showLoading(
    BuildContext context, {
    String message = 'Inapakia...',
    bool barrierDismissible = false,
  }) {
    if (!context.mounted) return;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      useRootNavigator: true,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hides the currently displayed dialog
  static Future<void> hideLoading(BuildContext context) async {
    if (!context.mounted) return;

    // Small delay to ensure proper timing
    await Future.delayed(const Duration(milliseconds: 100));

    if (!context.mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);

    if (!navigator.mounted || !navigator.canPop()) {
      return;
    }

    try {
      navigator.pop();
    } catch (_) {
      // Ignore if the dialog was already dismissed elsewhere
    }
  }

  /// Shows a confirmation dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) {
    if (!context.mounted) return Future.value(null);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: confirmColor ??
                  (isDangerous
                      ? AppColors.error
                      : (isDark ? AppColors.darkPrimary : AppColors.primary)),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows an error dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Sawa',
  }) {
    if (!context.mounted) return Future.value();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: isDark ? AppColors.errorDark : AppColors.error,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.errorDark : AppColors.error,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Shows a custom dialog
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    bool useRootNavigator = true,
  }) {
    if (!context.mounted) return Future.value(null);

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }
}
