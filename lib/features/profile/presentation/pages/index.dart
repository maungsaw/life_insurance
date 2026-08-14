import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show
        AppColors,
        GuestSession,
        GuestQuoteDraft,
        PrototypeConfig,
        PrototypeRole,
        PrototypeRoleId;
import 'package:life_insurance/core/navigation/name.dart' show AppRoute;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/core/secure/biometric_prefs.dart';
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';
import 'package:life_insurance/features/notification/presentation/models/notification_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_biometric_tile.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_setting_tile.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_stat_cards.dart';

/// Profile tab — settings hub (docs/50 · Agent Profile.png).
/// Old parallax / contact / license cards are unused (kept under widgets/).
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _bioBusy = false;

  @override
  void initState() {
    super.initState();
    _loadBiometrics();
  }

  Future<void> _loadBiometrics() async {
    await BiometricPrefs.load();
    if (mounted) setState(() {});
  }

  Future<void> _open(String route) async {
    await context.push(route);
    if (mounted) setState(() {});
  }

  void _createQuote() {
    MainTabScope.maybeOf(context)?.goToTab(PrototypeConfig.tabProduct);
  }

  Future<void> _logout() async {
    final proceed = await AppStatusDialog.show(
      context,
      type: AppStatusType.warning,
      title: 'Log out?',
      message: 'You will need to log in again to use the app.',
      actionLabel: 'Log out',
      secondaryLabel: 'Cancel',
    );
    if (!mounted || proceed != true) return;
    PrototypeRole.reset();
    TeamMockData.scope = TeamScope.personal;
    GuestSession.signOut();
    GuestQuoteDraft.clear();
    context.go(AppRoute.guestHome);
  }

  bool get _bioCanToggle =>
      !_bioBusy &&
      (BiometricPrefs.hardwareReady || BiometricPrefs.allowPrototypeMock);

  Future<void> _onBiometricChanged(bool next) async {
    if (!_bioCanToggle) return;
    if (next) {
      await _enableBiometric();
    } else {
      await _disableBiometric();
    }
  }

  Future<void> _enableBiometric() async {
    final proceed = await AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: 'Turn on biometric login?',
      message:
          'You’ll confirm with Face ID or fingerprint. You can turn this off anytime in Profile.',
      actionLabel: 'Continue',
      secondaryLabel: 'Cancel',
    );
    if (!mounted || proceed != true) return;

    setState(() => _bioBusy = true);
    var ok = false;
    if (BiometricPrefs.hardwareReady) {
      ok = await BiometricPrefs.authenticate(
        reason: 'Confirm it’s you to enable biometric login.',
      );
    } else if (BiometricPrefs.allowPrototypeMock) {
      final mock = await AppStatusDialog.show(
        context,
        type: AppStatusType.info,
        title: 'Prototype mock',
        message: 'Prototype: biometric mocked — no sensor.',
        actionLabel: 'Turn on',
        secondaryLabel: 'Cancel',
      );
      if (mock != true) {
        if (mounted) setState(() => _bioBusy = false);
        return;
      }
      ok = true;
    }
    if (!mounted) return;

    if (ok) {
      await BiometricPrefs.setEnabled(true);
    }
    setState(() => _bioBusy = false);

    if (!mounted) return;
    if (ok) {
      await AppStatusDialog.show(
        context,
        type: AppStatusType.success,
        title: 'Biometric login is on.',
        message: 'Next time, you can unlock with ${BiometricPrefs.kindLabel}.',
        actionLabel: 'OK',
      );
    } else {
      await AppStatusDialog.show(
        context,
        type: AppStatusType.warning,
        title: 'Couldn’t verify',
        message: 'Try again or use password.',
        actionLabel: 'OK',
      );
    }
  }

  Future<void> _disableBiometric() async {
    final proceed = await AppStatusDialog.show(
      context,
      type: AppStatusType.warning,
      title: 'Turn off biometric login?',
      message: 'You’ll sign in with mobile number and password.',
      actionLabel: 'Turn off',
      secondaryLabel: 'Cancel',
    );
    if (!mounted || proceed != true) return;
    await BiometricPrefs.setEnabled(false);
    if (mounted) setState(() {});
  }

  Future<void> _previewRole() async {
    final picked = await showModalBottomSheet<PrototypeRoleId>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'Preview role',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'For prototype review only. Logout returns to FA.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ),
              for (final role in PrototypeRoleId.values)
                ListTile(
                  title: Text(_previewLabel(role)),
                  trailing: role == PrototypeRole.id
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.lightPrimary,
                        )
                      : null,
                  onTap: () => Navigator.of(ctx).pop(role),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    PrototypeRole.set(picked);
    TeamMockData.scope = TeamScope.personal;
    setState(() {});
  }

  String _previewLabel(PrototypeRoleId role) {
    switch (role) {
      case PrototypeRoleId.fa:
        return 'FA — Financial Advisor';
      case PrototypeRoleId.teamLead:
        return 'TL — Team Lead';
      case PrototypeRoleId.am:
        return 'AM — Agency Manager';
      case PrototypeRoleId.sam:
        return 'SAM — Senior Agency Manager';
      case PrototypeRoleId.dm:
        return 'DM — District Manager';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoute.notifications),
            icon: Badge(
              isLabelVisible: NotificationMockData.unreadCount > 0,
              smallSize: 8,
              child: const Icon(Icons.notifications_none_rounded, size: 26),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        children: [
          ValueListenableBuilder(
            valueListenable: PrototypeRole.current,
            builder: (_, _, _) => const ProfileIdentityCard(),
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Create New Quote',
            icon: Icons.add_moderator_outlined,
            onPressed: _createQuote,
          ),
          const SizedBox(height: 14),
          const ProfileStatCards(),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                ProfileSettingTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () => _open(AppRoute.profileDetails),
                ),
                ProfileSettingTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Change Password',
                  onTap: () => _open(AppRoute.profilePassword),
                  showDivider: PrototypeConfig.enabled,
                ),
                if (PrototypeConfig.enabled)
                  ProfileSettingTile(
                    icon: Icons.manage_accounts_outlined,
                    label: 'Preview role',
                    subtitle: PrototypeRole.previewTitle,
                    onTap: _previewRole,
                    showDivider: false,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Security',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                ProfileBiometricTile(
                  value: BiometricPrefs.enabled,
                  subtitle: BiometricPrefs.profileSubtitle,
                  busy: _bioBusy,
                  onChanged: _bioCanToggle ? _onBiometricChanged : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ProfileSettingTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'FAQ',
                  onTap: () => _open(AppRoute.profileFaq),
                ),
                ProfileSettingTile(
                  icon: Icons.public_rounded,
                  label: 'Language',
                  onTap: () => _open(AppRoute.language),
                ),
                ProfileSettingTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notification',
                  onTap: () => _open(AppRoute.profileNotificationPrefs),
                ),
                ProfileSettingTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'Report',
                  onTap: () => _open(AppRoute.profileReport),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _logout,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.18),
                foregroundColor: AppColors.lightPrimary,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(height: AppBottomNavBar.scrollClearance(context)),
        ],
      ),
    );
  }
}
