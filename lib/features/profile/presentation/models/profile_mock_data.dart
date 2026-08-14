/// Session-only agent profile mock (docs/50). Lost on restart.
class ProfileMockData {
  ProfileMockData._();

  static String displayName = 'May Chan Myae';
  static const String agentCode = 'YGN/IA/(O)/2021/0009';
  static String mobile = '09 8800 8834';
  static DateTime dob = DateTime(1999, 6, 4);
  static String identification = '12/KaMaNa(N)127645';
  static String email = 'may@gmail.com';
  static ProfileGender gender = ProfileGender.female;

  static const String totalPremium = '39,485,908.00';
  // Prefer CommissionMockData.totalCommissionPlain on UI chips (docs/61).
  static const String totalCommission = '726,080.00';

  static String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'A';
    return parts.first[0].toUpperCase();
  }

  static String get dobLabel {
    final d = dob.day.toString().padLeft(2, '0');
    final m = dob.month.toString().padLeft(2, '0');
    return '$d.$m.${dob.year}';
  }

  static bool pushNotification = true;
  static bool messageNotification = false;
  static bool emailNotification = true;
}

enum ProfileGender { male, female }

class FaqItem {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}

abstract final class FaqMockData {
  static const items = <FaqItem>[
    FaqItem(
      id: 'claim',
      question: 'How to claim the policy?',
      answer:
          'Open the policy from Home or Product, then start a claim with the required documents. Status updates appear in Notifications. Full claim workflow comes in a later pass.',
    ),
    FaqItem(
      id: 'change-info',
      question: 'How to change the policy information?',
      answer:
          'Policy holder details are updated through the policy record after verification. Use Edit Profile for your own agent account. Policy endorsement flow is a later pass.',
    ),
    FaqItem(
      id: 'commission',
      question: 'How to check commission?',
      answer:
          'Commission is on Home and Profile. Open the Commission screen for history, or Report for a category chart. Display only — no withdraw or payout in this app.',
    ),
  ];

  static FaqItem byId(String id) =>
      items.firstWhere((e) => e.id == id, orElse: () => items.first);
}

abstract final class CommissionReportMock {
  static const categories = <String>['Protection', 'Saving', 'Health', 'Travel'];
  static const values = <double>[24, 8, 13, 33];
}
