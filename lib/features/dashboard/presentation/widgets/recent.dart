import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        EdgeInsets,
        Offset,
        Text,
        SizedBox,
        Color,
        TextStyle,
        Colors,
        BorderRadius,
        BoxShadow,
        BoxDecoration,
        MainAxisAlignment,
        FontWeight,
        TextButton,
        Size,
        MaterialTapTargetSize,
        Row,
        Icons,
        Divider,
        Column,
        Container;

import 'recent_item.dart';

class RecentActivitiesCard extends StatelessWidget {
  const RecentActivitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ActivityItem(
            icon: Icons.shield,
            iconBg: Color(0xFFDCFCE7),
            iconColor: Color(0xFF16A34A),
            title: 'New Policy Issued',
            subtitle: 'Jane Cooper • Life Insurance',
            time: '2m ago',
          ),
          Divider(color: Colors.grey.shade100, height: 24),
          const ActivityItem(
            icon: Icons.account_balance_wallet,
            iconBg: Color(0xFFDBEAFE),
            iconColor: Color(0xFF2563EB),
            title: 'Premium Received',
            subtitle: 'Robert Fox • Health Insurance • \$1,200...',
            time: '1h ago',
          ),
        ],
      ),
    );
  }
}
