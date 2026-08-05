import 'package:flutter/material.dart'
    show
        StatelessWidget,
        ValueChanged,
        Widget,
        BuildContext,
        EdgeInsets,
        SizedBox,
        Theme,
        BorderRadius,
        Border,
        BoxDecoration,
        CrossAxisAlignment,
        Icons,
        Icon,
        FontWeight,
        Text,
        Row,
        Padding,
        Divider,
        Column,
        Container;

import 'toogle.dart';

class QuickSettingsCard extends StatelessWidget {
  final bool isDarkMode;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onSmsChanged;

  const QuickSettingsCard({
    super.key,
    required this.isDarkMode,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.onDarkModeChanged,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onSmsChanged,
  });

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
                Icons.settings_outlined,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Settings',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dark Mode Toggle
          AppToogle(
            icon: Icons.wb_sunny_outlined,
            iconBg: colorScheme.tertiaryContainer,
            iconColor: colorScheme.onTertiaryContainer,
            title: 'Dark Mode',
            subtitle: isDarkMode ? 'Dark theme active' : 'Light theme active',
            value: isDarkMode,
            onChanged: onDarkModeChanged,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'NOTIFICATIONS',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Push Notifications Toggle
          AppToogle(
            icon: Icons.notifications_none_rounded,
            iconBg: colorScheme.secondaryContainer,
            iconColor: colorScheme.onSecondaryContainer,
            title: 'Push Notifications',
            subtitle: 'Task reminders & lead alerts',
            value: pushNotifications,
            onChanged: onPushChanged,
          ),
          Divider(
            height: 20,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),

          // Email Notifications Toggle
          AppToogle(
            icon: Icons.email_outlined,
            iconBg: colorScheme.primaryContainer,
            iconColor: colorScheme.onPrimaryContainer,
            title: 'Email Notifications',
            subtitle: 'Daily summaries & reports',
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
          Divider(
            height: 20,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),

          // SMS Notifications Toggle
          AppToogle(
            icon: Icons.chat_bubble_outline_rounded,
            iconBg: colorScheme.tertiaryContainer,
            iconColor: colorScheme.onTertiaryContainer,
            title: 'SMS Notifications',
            subtitle: 'Urgent alerts via text',
            value: smsNotifications,
            onChanged: onSmsChanged,
          ),
        ],
      ),
    );
  }
}
