import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/profile/presentation/models/profile_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_sub_app_bar.dart';

/// Notification *preferences* — not the inbox (docs/50).
class NotificationPrefsPage extends StatefulWidget {
  const NotificationPrefsPage({super.key});

  @override
  State<NotificationPrefsPage> createState() => _NotificationPrefsPageState();
}

class _NotificationPrefsPageState extends State<NotificationPrefsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: const ProfileSubAppBar(title: 'Notification'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _PrefCard(
            label: 'Push Notification',
            value: ProfileMockData.pushNotification,
            onChanged: (v) => setState(() => ProfileMockData.pushNotification = v),
          ),
          const SizedBox(height: 12),
          _PrefCard(
            label: 'Message Notification',
            value: ProfileMockData.messageNotification,
            onChanged: (v) =>
                setState(() => ProfileMockData.messageNotification = v),
          ),
          const SizedBox(height: 12),
          _PrefCard(
            label: 'Email Notification',
            value: ProfileMockData.emailNotification,
            onChanged: (v) =>
                setState(() => ProfileMockData.emailNotification = v),
          ),
        ],
      ),
    );
  }
}

class _PrefCard extends StatelessWidget {
  const _PrefCard({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface(context),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
