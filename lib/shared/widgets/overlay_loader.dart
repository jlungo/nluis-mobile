import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class OverlayLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? appIconPath;
  final double appIconSize;
  final Color? overlayColor;
  final double overlayOpacity;

  const OverlayLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.appIconPath = 'assets/images/logo/nlupc_logo.png',
    this.appIconSize = 80,
    this.overlayColor,
    this.overlayOpacity = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final defaultOverlayColor = isDark ? AppColors.darkOverlay : AppColors.overlay;
    final containerColor = isDark ? AppColors.darkTextPrimary : AppColors.textInverse;
    final indicatorColor = isDark ? AppColors.darkPrimary : AppColors.textInverse;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textInverse;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: (overlayColor ?? defaultOverlayColor).withValues(
                alpha: overlayOpacity,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: containerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: containerColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            indicatorColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Loading text
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: containerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Inapakia...',
                        style: TextStyle(
                          color: textColor,
                          fontSize: ResponsiveUtils.fontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
