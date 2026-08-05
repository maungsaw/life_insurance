import 'package:flutter/material.dart';

import '../widgets/widgets.dart'
    show
        ProfileHeader,
        ContactInformationCard,
        LicenseInformationCard,
        QuickSettingsCard;

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
        const ProfileHeader(),

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
              // Contact Information Card
              const ContactInformationCard(),
              const SizedBox(height: 16),

              // License Information Card
              const LicenseInformationCard(),
              const SizedBox(height: 16),

              // Quick Settings Card
              QuickSettingsCard(
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

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton.icon(
      icon: Icon(Icons.logout_rounded, color: colorScheme.error, size: 18),
      label: Text(
        'Log Out',
        style: TextStyle(
          color: colorScheme.error,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
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
      ),
    );
  }
}
