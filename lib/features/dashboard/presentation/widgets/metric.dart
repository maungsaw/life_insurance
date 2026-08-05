import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Row,
        Icons,
        Color,
        Expanded,
        SizedBox;

import 'status.dart';

class MetricsView extends StatelessWidget {
  const MetricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatusCard(
            icon: Icons.shield_outlined,
            iconBg: Color(0xFFE0E7FF),
            iconColor: Color(0xFF3730A3),
            value: '32',
            title: 'Policies\nSold',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatusCard(
            icon: Icons.shield_outlined,
            iconBg: Color(0xFFE0F2FE),
            iconColor: Color(0xFF0284C7),
            value: '128',
            title: 'Active\nPolicies',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatusCard(
            icon: Icons.people_outline,
            iconBg: Color(0xFFF3E8FF),
            iconColor: Color(0xFF9333EA),
            value: '86',
            title: 'Total\nCustomers',
          ),
        ),
      ],
    );
  }
}
