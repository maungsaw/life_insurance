import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/notification/presentation/models/notification_mock_data.dart';

/// Notification inbox — day groups (docs/49 · Notification.png).
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  void _openItem(BuildContext context, NotificationItem item) {
    switch (item.kind) {
      case NotificationKind.productLaunch:
        context.push(AppRoute.notificationProduct, extra: item);
        break;
      case NotificationKind.policyRenewal:
      case NotificationKind.claimStatus:
      case NotificationKind.generic:
        context.push(AppRoute.notificationDetail, extra: item);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = NotificationMockData.grouped;

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface(context),
        foregroundColor: AppColors.onSurface(context),
      ),
      body: grouped.isEmpty
          ? Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
              ),
            )
          : ListView(
              children: [
                for (final entry in grouped.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                  ),
                  for (final item in entry.value)
                    AppNotificationTile(
                      title: item.title,
                      body: item.body,
                      timeLabel: item.timeLabel,
                      unread: item.unread,
                      onTap: () => _openItem(context, item),
                    ),
                ],
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
