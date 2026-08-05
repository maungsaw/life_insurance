import 'package:flutter/material.dart'
    show
        BuildContext,
        Theme,
        StatelessWidget,
        Widget,
        EdgeInsets,
        SizedBox,
        BorderRadius,
        Border,
        BoxDecoration,
        CrossAxisAlignment,
        Icons,
        Icon,
        FontWeight,
        Text,
        Row,
        Divider,
        Column,
        Container;
import 'info.dart';

class ContactInformationCard extends StatelessWidget {
  const ContactInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'Contact Information',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const InfoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: 'marcus.reynolds@insureagent.com',
          ),
          Divider(
            height: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          const InfoRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: '+1 (555) 847–2930',
          ),
          Divider(
            height: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          const InfoRow(
            icon: Icons.domain_outlined,
            title: 'Agency',
            value: 'Pacific Shield Insurance Group',
          ),
          Divider(
            height: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          const InfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Member Since',
            value: 'March 2019',
          ),
        ],
      ),
    );
  }
}
