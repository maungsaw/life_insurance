/// In-app notification inbox mock (docs/49). No FCM required.
enum NotificationKind { policyRenewal, productLaunch, claimStatus, generic }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.group,
    required this.kind,
    this.unread = true,
  });

  final String id;
  final String title;
  final String body;
  final String timeLabel;
  /// Today | Yesterday | date label e.g. 20-Sep-2024
  final String group;
  final NotificationKind kind;
  final bool unread;
}

abstract final class NotificationMockData {
  static const items = <NotificationItem>[
    NotificationItem(
      id: 'n1',
      title: 'Policy Renewal',
      body:
          'Your policy no 23471239074138 is expiring soon. Renew now to stay covered.',
      timeLabel: '2 hr',
      group: 'Today',
      kind: NotificationKind.policyRenewal,
    ),
    NotificationItem(
      id: 'n2',
      title: 'New Product Launching',
      body:
          'Universal Life is now available. Protect clients with accident coverage.',
      timeLabel: '5 hr',
      group: 'Today',
      kind: NotificationKind.productLaunch,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Claim Status Update',
      body: 'Claim CL-8821 moved to under review. We will notify you of the result.',
      timeLabel: '1d',
      group: 'Yesterday',
      kind: NotificationKind.claimStatus,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Policy Renewal',
      body:
          'Your policy no 23471239074138 is expiring soon. Renew now to stay covered.',
      timeLabel: '2d',
      group: 'Yesterday',
      kind: NotificationKind.policyRenewal,
      unread: false,
    ),
    NotificationItem(
      id: 'n5',
      title: 'New Product Launching',
      body: 'Check the latest product brochure for Universal Life.',
      timeLabel: '3d',
      group: '20-Sep-2024',
      kind: NotificationKind.productLaunch,
      unread: false,
    ),
    NotificationItem(
      id: 'n6',
      title: 'Claim Status Update',
      body: 'Additional documents were requested for claim CL-7702.',
      timeLabel: '4d',
      group: '20-Sep-2024',
      kind: NotificationKind.claimStatus,
      unread: false,
    ),
  ];

  static int get unreadCount => items.where((e) => e.unread).length;

  static Map<String, List<NotificationItem>> get grouped {
    final map = <String, List<NotificationItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.group, () => []).add(item);
    }
    return map;
  }

  static NotificationItem? byId(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}
