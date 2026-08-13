import 'package:flutter/material.dart' show Color;
import 'package:life_insurance/features/components/components.dart'
    show AppPromoItem;

/// Static demo data for Home until FR-02 APIs are wired (docs/36).
abstract final class HomeMockData {
  static const agentName = 'Mg Htet';
  static const initials = 'MH';
  static const greeting = 'Good morning';
  static const periodLabel = 'Aug 2026';

  static const commissionAmount = '726,080.00 MMK';
  static const commissionDelta = '↗ 15% vs last month';

  static const newPolicies = '12';
  static const activePolicies = '128';
  static const fypPercent = '78%';
  static const mdrtPercent = 0.62;
  static const mdrtSubtitle = 'Premium 25.4M · Gate 41.0M';

  static const dueAlertTitle = '3 premiums due this week';
  static const dueAlertSubtitle = 'Follow up before grace period ends';

  static const promos = <AppPromoItem>[
    AppPromoItem(
      title: 'Q3 Sales Incentive',
      subtitle: 'Close 2 more policies for bonus tier',
      color: Color(0xFF006494),
    ),
    AppPromoItem(
      title: 'MDRT Roadshow',
      subtitle: 'Yangon · 20-Aug-2026',
      color: Color(0xFF0582CA),
    ),
    AppPromoItem(
      title: 'Product update',
      subtitle: 'Endowment rates refreshed',
      color: Color(0xFF003554),
    ),
  ];
}
