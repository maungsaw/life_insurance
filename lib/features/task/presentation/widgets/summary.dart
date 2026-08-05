import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Row,
        Color,
        Icons,
        Expanded,
        SizedBox;

import 'card.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: SummaryCard(
            count: '8',
            label: 'Pending',
            countColor: Color(0xFFD97706),
            bgColor: Color(0xFFFEF3C7),
            icon: Icons.hourglass_bottom_rounded,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: SummaryCard(
            count: '2',
            label: 'Completed',
            countColor: Color(0xFF16A34A),
            bgColor: Color(0xFFDCFCE7),
            icon: Icons.check_circle_outline,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: SummaryCard(
            count: '2',
            label: 'Overdue',
            countColor: Color(0xFFDC2626),
            bgColor: Color(0xFFFEE2E2),
            icon: Icons.warning_amber_rounded,
          ),
        ),
      ],
    );
  }
}
