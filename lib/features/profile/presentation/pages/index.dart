import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';
import 'package:life_insurance/features/notification/presentation/models/notification_mock_data.dart';
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
  Future<void> _open(String route) async {
    await context.push(route);
    if (mounted) setState(() {});
  }

  void _createQuote() {
    MainTabScope.maybeOf(context)?.goToTab(PrototypeConfig.tabProduct);
    AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: 'Create New Quote',
      message: 'Opens Product hub — full quote spine later (FR-04).',
      actionLabel: 'OK',
    );
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
    context.go(AppRoute.login);
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
          const ProfileIdentityCard(),
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
                ),
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
