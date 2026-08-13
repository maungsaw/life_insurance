import 'package:flutter/material.dart' show Color;
import 'package:life_insurance/features/components/components.dart'
    show AppPromoItem;

/// Static demo data for Home until FR-02 APIs are wired (docs/36 · 46).
abstract final class HomeMockData {
  static const agentName = 'Mr Chit';
  static const greeting = 'Good Morning!';

  static const commissionAmount = '726,080.00 MMK';
  static const commissionDelta = '↗ 15% up compared with last month';

  static const policyActive = '20';
  static const policyPending = '10';
  static const policyExpired = '5';

  static const renewalTitle = 'Policy Renewal';
  static const renewalBody =
      'Your policy no 23471239074138 is expiring soon. Renew now to stay covered.';
  static const renewalTime = '1d';

  static const promos = <AppPromoItem>[
    AppPromoItem(
      title: 'Easily Claim Commission',
      subtitle: 'Track and claim your earnings',
      color: Color(0xFF00A6FB),
    ),
    AppPromoItem(
      title: 'Unlock special discounts',
      subtitle: 'Campaign offers for your clients',
      color: Color(0xFF006494),
    ),
  ];
}
