import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class StatCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  final bool isDark;

  final double? width;
  final double? height;

  final CrossAxisAlignment alignment;

  const StatCard({
    super.key,
    required this.count,
    required this.label,
    required this.color,
    required this.isDark,
    this.width,
    this.height,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.spacing(context, 16);
    final countFontSize = ResponsiveUtils.fontSize(context, 32);
    final labelFontSize = ResponsiveUtils.fontSize(context, 12);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: alignment == CrossAxisAlignment.center
                ? Alignment.center
                : Alignment.centerLeft,
            child: Text(
              count,
              style: TextStyle(
                fontSize: countFontSize,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
