/// In-memory guest Get A Quote snapshot (docs/75). Lost on process kill.
class GuestQuoteDraft {
  GuestQuoteDraft({
    required this.productId,
    required this.dob,
    required this.variant,
    required this.frequency,
    required this.term,
    required this.si,
    required this.topup,
    required this.lockupAmount,
    required this.lockupPeriod,
    required this.industryRisk,
    required this.additionalCover,
    required this.travelBy,
    required this.plateNumber,
    required this.optionalBundle,
    required this.riderPlan,
    required this.riderFrequency,
    required this.discountName,
    required this.discountAmount,
    required this.premiumLabel,
  });

  final String productId;
  final DateTime dob;
  final String variant;
  final String frequency;
  final String term;
  final String si;
  final String topup;
  final String lockupAmount;
  final String lockupPeriod;
  final String industryRisk;
  final String additionalCover;
  final String travelBy;
  final String plateNumber;
  final bool optionalBundle;
  final String riderPlan;
  final String riderFrequency;
  final String discountName;
  final String discountAmount;
  final String premiumLabel;

  static GuestQuoteDraft? current;
  static bool pendingResume = false;

  static bool get has => current != null;

  static void save(GuestQuoteDraft draft) {
    current = draft;
  }

  static void clear() {
    current = null;
    pendingResume = false;
  }
}
