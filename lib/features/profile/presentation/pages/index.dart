import 'dart:ui';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Toggle States
  bool _isDarkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Modern Collapsible Parallax Header
        const _CollapsibleProfileHeader(),

        // 2. Profile Content Body
        SliverPadding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 20.0,
            bottom: MediaQuery.paddingOf(context).bottom + 24.0,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Bento Grid Stats Section
              const _BentoStatsGrid(),
              const SizedBox(height: 20),

              // Contact Information Card
              const _ContactInformationCard(),
              const SizedBox(height: 16),

              // License Information Card
              const _LicenseInformationCard(),
              const SizedBox(height: 16),

              // Quick Settings Card
              _QuickSettingsCard(
                isDarkMode: _isDarkMode,
                pushNotifications: _pushNotifications,
                emailNotifications: _emailNotifications,
                smsNotifications: _smsNotifications,
                onDarkModeChanged: (val) => setState(() => _isDarkMode = val),
                onPushChanged: (val) =>
                    setState(() => _pushNotifications = val),
                onEmailChanged: (val) =>
                    setState(() => _emailNotifications = val),
                onSmsChanged: (val) => setState(() => _smsNotifications = val),
              ),
              const SizedBox(height: 24),

              // Logout Button
              const _LogoutButton(),
            ]),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 1. Modern Collapsible Parallax Header
// ==========================================
class _CollapsibleProfileHeader extends StatelessWidget {
  const _CollapsibleProfileHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Show title only when app bar is collapsed
            final isCollapsed =
                constraints.maxHeight <=
                kToolbarHeight + MediaQuery.paddingOf(context).top + 10;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isCollapsed ? 1.0 : 0.0,
              child: Text(
                'Marcus J. Reynolds',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        background: Stack(
          fit: .expand,
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Decorative Background Circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Main Header Details
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  // Avatar with Gradient Ring
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.onPrimary,
                              colorScheme.onPrimary.withValues(alpha: 0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Marcus J. Reynolds',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Senior Insurance Agent',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Glassmorphic ID Chip
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.onPrimary.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: Text(
                          'ID: AGT-00492',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. Bento Box Stats Grid
// ==========================================
class _BentoStatsGrid extends StatelessWidget {
  const _BentoStatsGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _BentoCard(
            icon: Icons.assignment_turned_in_outlined,
            title: '128',
            subtitle: 'Active Policies',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _BentoCard(
            icon: Icons.star_rounded,
            title: '4.9 / 5.0',
            subtitle: 'Client Rating',
          ),
        ),
      ],
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

// ==========================================
// 3. Contact Information Card
// ==========================================
class _ContactInformationCard extends StatelessWidget {
  const _ContactInformationCard();

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
          const _InfoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: 'marcus.reynolds@insureagent.com',
          ),
          Divider(
            height: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          const _InfoRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: '+1 (555) 847–2930',
          ),
          Divider(
            height: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          const _InfoRow(
            icon: Icons.domain_outlined,
            title: 'Agency',
            value: 'Pacific Shield Insurance Group',
          ),
          Divider(
            height: 24,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          const _InfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Member Since',
            value: 'March 2019',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. License Information Card
// ==========================================
class _LicenseInformationCard extends StatelessWidget {
  const _LicenseInformationCard();

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
                Icons.verified_outlined,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'License Information',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primaryContainer.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CA–INS–2019–084721',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Life & Health Insurance',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _InfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Expiry Date',
            value: 'Dec 31, 2026',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. Quick Settings Card
// ==========================================
class _QuickSettingsCard extends StatelessWidget {
  final bool isDarkMode;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onSmsChanged;

  const _QuickSettingsCard({
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
          _SettingToggleRow(
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
          _SettingToggleRow(
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
          _SettingToggleRow(
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
          _SettingToggleRow(
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

// ==========================================
// Helper Components
// ==========================================
class _SettingToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggleRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
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
                style: theme.textTheme.bodyMedium?.copyWith(
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
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: colorScheme.primary,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      onPressed: () {
        // Handle logout navigation
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(
          color: colorScheme.error.withValues(alpha: 0.5),
          width: 1.5,
        ),
        backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: colorScheme.error, size: 18),
          const SizedBox(width: 8),
          Text(
            'Log Out',
            style: TextStyle(
              color: colorScheme.error,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
