import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../providers/auth_providers.dart';

/// A widget that listens for automatic logout triggers
/// (e.g., when token refresh fails while online)
/// and performs the logout and navigation to login page.
class AuthSessionListener extends ConsumerWidget {
  final Widget child;

  const AuthSessionListener({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the logout trigger
    ref.listen<int>(
      tokenExpiredLogoutTriggerProvider,
      (previous, next) async {
        // If the state changed (incremented), trigger logout
        if (previous != null && next > previous) {
          // Perform logout
          await ref.read(authStateProvider.notifier).logout(clearData: false);

          // Show a snackbar to inform the user
          if (context.mounted) {
            SnackBarUtils.showWarning(
              context,
              'Kipindi chako kimeisha. Tafadhali ingia tena.',
            );
          }

          // Navigate to login page
          // Note: The router's redirect logic will handle this automatically
          // when authStateProvider becomes null, but we can force it here
        }
      },
    );

    return child;
  }
}
