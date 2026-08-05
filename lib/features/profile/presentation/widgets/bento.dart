import 'package:flutter/material.dart'
    show
        BuildContext,
        StatelessWidget,
        Widget,
        IconData,
        EdgeInsets,
        SizedBox,
        Icons,
        Theme,
        BorderRadius,
        Border,
        BoxDecoration,
        CrossAxisAlignment,
        Icon,
        FontWeight,
        Text,
        Column,
        Container;

class BentoStatsGrid extends StatelessWidget {
  const BentoStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return _BentoCard(
      icon: Icons.star_rounded,
      title: '4.9 / 5.0',
      subtitle: 'Client Rating',
    );
  }
}

class _BentoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _BentoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
