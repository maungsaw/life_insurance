import 'package:flutter/material.dart' show Color;
import 'package:life_insurance/features/components/components.dart'
    show AppPromoItem;
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';

/// Static demo data for Home until FR-02 APIs are wired (docs/36 · 46).
abstract final class HomeMockData {
  static const agentName = 'Mr Chit';
  static const greeting = 'Good Morning!';

  static String get commissionAmount => CommissionMockData.totalLabel;
  static String get commissionDelta => CommissionMockData.deltaLabel;

  static const policyActive = '20';
  static const policyPending = '10';
  static const policyExpired = '5';

  static const renewalTitle = 'Policy Renewal';
  static String get renewalBody {
    final id = CustomerMockData.firstRenewalPolicy?.id ?? '23487532096712';
    return 'Your policy no $id is expiring soon. Renew now to stay covered.';
  }

  static const renewalTime = '1d';

  static const promos = <AppPromoItem>[
    AppPromoItem(
      title: 'Easily Claim Commission',
      subtitle: 'Track and claim your earnings',
      color: Color(0xFF00A6FB),
    ),
    // Gold instead of a second cold blue — pairs with the cyan card above
    // and sits warmer against the milk-tea page background (docs/74).
    AppPromoItem(
      title: 'Unlock special discounts',
      subtitle: 'Campaign offers for your clients',
      color: Color(0xFFE8960C),
    ),
  ];
}
