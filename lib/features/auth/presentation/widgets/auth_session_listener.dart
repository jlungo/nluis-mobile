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
    // Listen to the logout trigger (token expired, no token, or unauthorized)
    ref.listen<int>(
      tokenExpiredLogoutTriggerProvider,
      (previous, next) async {
        // If the state changed (incremented), trigger logout
        if (previous != null && next > previous) {
          // Perform logout - clear auth state
          await ref.read(authStateProvider.notifier).logout(clearData: false);

          // Show clear message to user
          if (context.mounted) {
            SnackBarUtils.showWarning(
              context,
              'Ingia tena ili kuendelea. (Login again to continue)',
            );
          }

          // Router will automatically redirect to login when auth state is null
        }
      },
    );

    return child;
  }
}
