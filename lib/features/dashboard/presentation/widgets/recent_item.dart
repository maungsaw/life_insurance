import 'package:flutter/material.dart'
    show
        StatelessWidget,
        IconData,
        Color,
        Widget,
        BuildContext,
        EdgeInsets,
        SizedBox,
        TextStyle,
        BorderRadius,
        BoxDecoration,
        Icon,
        Container,
        CrossAxisAlignment,
        FontWeight,
        Text,
        Colors,
        TextOverflow,
        Column,
        Expanded,
        Row;

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const ActivityItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(time, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
      ],
    );
  }
}
