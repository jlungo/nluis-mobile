import 'package:flutter/material.dart';

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
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
