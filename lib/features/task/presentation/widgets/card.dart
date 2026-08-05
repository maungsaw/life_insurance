import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Color,
        IconData,
        Widget,
        BuildContext,
        EdgeInsets,
        SizedBox,
        BorderRadius,
        Border,
        BoxDecoration,
        Icon,
        CrossAxisAlignment,
        MainAxisSize,
        FontWeight,
        TextStyle,
        Text,
        Column,
        Row,
        Container;

class SummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Color countColor;
  final Color bgColor;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.count,
    required this.label,
    required this.countColor,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: countColor, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: countColor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: countColor.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
