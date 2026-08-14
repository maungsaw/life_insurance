import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';

/// Schema-driven Get A Quote fields (docs/65). One page · swap body by product.

enum PremiumFieldId {
  variant,
  frequency,
  sumInsured,
  premium,
  topup,
  lockupAmount,
  lockupPeriod,
  policyTerms,
  industryRisk,
  additionalCover,
  travelBy,
  plateNumber,
  optionalBundle,
  riderPlan,
  riderFrequency,
}

enum PremiumFieldKind { dropdown, money, text, toggle }

class PremiumFieldSpec {
  const PremiumFieldSpec({
    required this.id,
    required this.label,
    this.isRequired = false,
    this.readOnly = false,
    this.kind = PremiumFieldKind.dropdown,
    this.options = const [],
  });

  final PremiumFieldId id;
  final String label;
  final bool isRequired;
  final bool readOnly;
  final PremiumFieldKind kind;
  final List<String> options;
}

class ProductPremiumSchema {
  const ProductPremiumSchema(this.fields);

  final List<PremiumFieldSpec> fields;

  bool has(PremiumFieldId id) => fields.any((f) => f.id == id);

  PremiumFieldSpec? of(PremiumFieldId id) {
    for (final f in fields) {
      if (f.id == id) return f;
    }
    return null;
  }
}

class QuoteCalcResult {
  const QuoteCalcResult({
    required this.premium,
    required this.stampFee,
    required this.riderPremium,
    required this.total,
  });

  final int premium;
  final int stampFee;
  final int riderPremium;
  final int total;
}

/// Extra quote values persisted for e-App pre-fill (beyond core SavedQuote columns).
class QuoteExtras {
  const QuoteExtras({
    this.lockupAmount = '0.00',
    this.lockupPeriod = '',
    this.industryRisk = '',
    this.additionalCover = '',
    this.travelBy = '',
    this.plateNumber = '',
    this.optionalBundle = false,
    this.riderPlan = '',
    this.riderFrequency = '',
    this.riderPremium = '0.00',
    this.discountName = '',
    this.discountAmount = '0.00',
    this.stampFee = '0.00',
    this.totalAmount = '0.00',
  });

  final String lockupAmount;
  final String lockupPeriod;
  final String industryRisk;
  final String additionalCover;
  final String travelBy;
  final String plateNumber;
  final bool optionalBundle;
  final String riderPlan;
  final String riderFrequency;
  final String riderPremium;
  final String discountName;
  final String discountAmount;
  final String stampFee;
  final String totalAmount;

  Map<String, String> get summaryRows {
    final rows = <String, String>{};
    if (lockupAmount != '0.00' && lockupAmount.isNotEmpty) {
      rows['Lock-Up Amount'] = lockupAmount;
    }
    if (lockupPeriod.isNotEmpty) rows['Lock-Up Period'] = lockupPeriod;
    if (industryRisk.isNotEmpty) rows['Industry Risk'] = industryRisk;
    if (additionalCover.isNotEmpty) rows['Additional Cover'] = additionalCover;
    if (travelBy.isNotEmpty) rows['Travel By'] = travelBy;
    if (plateNumber.isNotEmpty) rows['Plate Number'] = plateNumber;
    if (optionalBundle) {
      if (riderPlan.isNotEmpty) rows['Rider Plan'] = riderPlan;
      if (riderFrequency.isNotEmpty) {
        rows['Rider Payment Frequency'] = riderFrequency;
      }
      if (riderPremium != '0.00') rows['Rider Premium'] = riderPremium;
    }
    if (discountName.isNotEmpty) rows['Discount Name'] = discountName;
    if (discountAmount != '0.00' && discountAmount.isNotEmpty) {
      rows['Discount Amount'] = discountAmount;
    }
    rows['Stamp Fee'] = stampFee;
    return rows;
  }
}

abstract final class PremiumSchemas {
  static ProductPremiumSchema forProduct(CatalogProduct product) {
    switch (product.id) {
      case 'ul':
        return _ul(product);
      case 'ste':
        return _ste(product);
      case 'pa':
        return _pa(product);
      case 'cl':
        return _cl(product);
      case 'fh':
        return _health(product);
      case 'tp':
        return _travel(product);
      case 'lp':
        return _pack(product);
      default:
        return _ste(product);
    }
  }

  static QuoteCalcResult calculate({
    required CatalogProduct product,
    required int si,
    required int topup,
    required int lockupAmount,
    required bool optionalBundle,
    required String industryRisk,
  }) {
    var premium = ProductMockData.monthlyPremiumFor(product: product, si: si);
    if (product.id == 'pa') {
      final risk = industryRisk.toLowerCase();
      if (risk.contains('high')) {
        premium = (premium * 1.35).round();
      } else if (risk.contains('medium')) {
        premium = (premium * 1.15).round();
      }
    }
    final rider = optionalBundle ? (premium * 0.35).round() : 0;
    final stamp = _stamp(product: product, premium: premium);
    // Discount stub does not reduce total (docs/65).
    final total = premium + topup + lockupAmount + rider + stamp;
    return QuoteCalcResult(
      premium: premium,
      stampFee: stamp,
      riderPremium: rider,
      total: total,
    );
  }

  static int _stamp({required CatalogProduct product, required int premium}) {
    if (premium <= 0) return 0;
    switch (product.line) {
      case ProductLine.travel:
        return 0;
      case ProductLine.protection:
        return premium < 20000 ? 100 : (premium * 0.01).round().clamp(100, 5000);
      case ProductLine.health:
        return (premium * 0.03).round().clamp(50, 2000);
      case ProductLine.saving:
      case ProductLine.bundled:
        return (premium * 0.018).round().clamp(100, 20000);
    }
  }

  static ProductPremiumSchema _ul(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.variant,
          label: 'Product Variant',
          isRequired: true,
          options: p.variants,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.premium,
          label: 'Monthly Premium',
          readOnly: true,
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.topup,
          label: 'Topup Premium',
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.lockupAmount,
          label: 'Lock Up Amount',
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.lockupPeriod,
          label: 'Lock Up Period',
          kind: PremiumFieldKind.dropdown,
          options: ['2 Years', '3 Years', '5 Years'],
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
      ]);

  static ProductPremiumSchema _ste(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.variant,
          label: 'Product Variant',
          isRequired: true,
          options: p.variants,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
      ]);

  static ProductPremiumSchema _pa(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.industryRisk,
          label: 'Insured Person Worked at High Risk Industry',
          isRequired: true,
          options: ['Low Risk', 'Medium Risk', 'High Risk'],
        ),
      ]);

  static ProductPremiumSchema _cl(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.variant,
          label: 'Product Variant',
          isRequired: true,
          options: p.variants,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.premium,
          label: 'Premium',
          readOnly: true,
          kind: PremiumFieldKind.money,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
      ]);

  static ProductPremiumSchema _health(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.variant,
          label: 'Product Variant',
          isRequired: true,
          options: p.variants,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.additionalCover,
          label: 'Additional Cover',
          options: ['None', 'Cover 1', 'Full Health Check-up'],
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.premium,
          label: 'Premium',
          readOnly: true,
          kind: PremiumFieldKind.money,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
      ]);

  static ProductPremiumSchema _travel(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.variant,
          label: 'Product Variant',
          isRequired: true,
          options: p.variants,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.travelBy,
          label: 'Travel By',
          isRequired: true,
          options: ['Car', 'Bus', 'Flight', 'Train'],
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.plateNumber,
          label: 'Plate Number',
          isRequired: true,
          kind: PremiumFieldKind.text,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.premium,
          label: 'Premium',
          readOnly: true,
          kind: PremiumFieldKind.money,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
      ]);

  static ProductPremiumSchema _pack(CatalogProduct p) => ProductPremiumSchema([
        PremiumFieldSpec(
          id: PremiumFieldId.variant,
          label: 'Product Variant',
          isRequired: true,
          options: p.variants,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.frequency,
          label: 'Payment Frequency',
          isRequired: true,
          options: p.frequencies,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.policyTerms,
          label: 'Policy Terms',
          isRequired: true,
          options: p.terms,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.optionalBundle,
          label: 'Optional Bundle',
          kind: PremiumFieldKind.toggle,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.riderPlan,
          label: 'Rider Plan',
          options: p.variants,
        ),
        PremiumFieldSpec(
          id: PremiumFieldId.riderFrequency,
          label: 'Rider Payment Frequency',
          options: p.frequencies,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.sumInsured,
          label: 'Sum Insured Amount',
          isRequired: true,
          kind: PremiumFieldKind.money,
        ),
        const PremiumFieldSpec(
          id: PremiumFieldId.premium,
          label: 'Premium',
          readOnly: true,
          kind: PremiumFieldKind.money,
        ),
      ]);
}
