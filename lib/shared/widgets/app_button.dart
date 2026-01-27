import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class AppButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isDisabled;
  final bool iconOnRight;
  final double iconSize;
  final double spacing;

  const AppButton({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    required this.gradientColors,
    this.height = 50,
    this.borderRadius = 16,
    this.textStyle,
    this.isDisabled = false,
    this.iconOnRight = false,
    this.iconSize = 20,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final hasLabel = label != null && label!.isNotEmpty;
    final hasIcon = icon != null;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buildChild(context, hasLabel, hasIcon),
      ),
    );
  }

  Widget _buildChild(BuildContext context, bool hasLabel, bool hasIcon) {
    final responsiveIconSize = ResponsiveUtils.iconSize(context, iconSize);
    if (hasLabel && hasIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            iconOnRight
                ? [
                  Text(label!, style: _buildTextStyle(context)),
                  SizedBox(width: spacing),
                  Icon(
                    icon,
                    size: responsiveIconSize,
                    color: _buildTextStyle(context).color,
                  ),
                ]
                : [
                  Icon(
                    icon,
                    size: responsiveIconSize,
                    color: _buildTextStyle(context).color,
                  ),
                  SizedBox(width: spacing),
                  Text(label!, style: _buildTextStyle(context)),
                ],
      );
    } else if (hasIcon) {
      return Icon(
        icon,
        size: responsiveIconSize,
        color: _buildTextStyle(context).color,
      );
    } else {
      return Text(label ?? '', style: _buildTextStyle(context));
    }
  }

  TextStyle _buildTextStyle(BuildContext context) {
    return textStyle ??
        TextStyle(
          fontSize: ResponsiveUtils.fontSize(context, 18),
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        );
  }
}
