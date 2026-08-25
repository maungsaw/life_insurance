import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppDate;
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/lead/data/repository/repository.dart'
    show leadsData;
import 'package:life_insurance/features/product/presentation/models/premium_schema.dart';

/// Product catalog + in-memory quotes / e-Apps (docs/59). No API.

enum ProductLine { protection, saving, travel, health, bundled }

enum QuotePartyKind { client, lead }

enum EappStatus { draft, submitted, correction, approved, rejected }

enum EappLaunchIntent { newSale, renewal, repurchase }

class WhoShouldRow {
  const WhoShouldRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.code,
    required this.name,
    required this.line,
    required this.tagline,
    required this.icon,
    required this.about,
    required this.whoShould,
    required this.whyBuy,
    required this.coverage,
    required this.rateCallout,
    required this.eligible,
    required this.variants,
    required this.frequencies,
    required this.terms,
    this.defaultSi = 30000000,
    this.defaultTopup = 0,
  });

  final String id;
  final String code;
  final String name;
  final ProductLine line;
  final String tagline;
  final IconData icon;
  final String about;
  final List<WhoShouldRow> whoShould;
  final List<String> whyBuy;
  final List<String> coverage;
  final String rateCallout;
  final List<String> eligible;
  final List<String> variants;
  final List<String> frequencies;
  final List<String> terms;
  final int defaultSi;
  final int defaultTopup;

  String get lineLabel => switch (line) {
    ProductLine.protection => 'Protection',
    ProductLine.saving => 'Saving',
    ProductLine.travel => 'Travel',
    ProductLine.health => 'Health',
    ProductLine.bundled => 'Bundled',
  };

  String get sectionTitle => '$lineLabel Product';
}

class QuoteParty {
  const QuoteParty({
    required this.id,
    required this.name,
    required this.kind,
    this.phone,
    this.email,
    this.dob,
    this.identification,
    this.gender,
  });

  final String id;
  final String name;
  final QuotePartyKind kind;
  final String? phone;
  final String? email;
  final DateTime? dob;
  final String? identification;
  final String? gender;

  String get kindLabel => kind == QuotePartyKind.client ? 'Client' : 'Lead';
}

/// Extra for Get A Quote when opened from a Client / Lead (`81`).
class QuoteLaunchArgs {
  const QuoteLaunchArgs({this.product, this.party});

  final CatalogProduct? product;
  final QuoteParty? party;
}

class SavedQuote {
  SavedQuote({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.lineLabel,
    required this.variant,
    required this.frequency,
    required this.sumInsured,
    required this.monthlyPremium,
    required this.topup,
    required this.term,
    required this.dob,
    required this.age,
    required this.party,
    required this.savedAt,
    this.stampFee = '0.00',
    this.totalAmount = '0.00',
    this.extras = const {},
  });

  final String id;
  final String productId;
  final String productName;
  final String productCode;
  final String lineLabel;
  final String variant;
  final String frequency;
  final String sumInsured;
  final String monthlyPremium;
  final String topup;
  final String term;
  final DateTime dob;
  final int age;
  final QuoteParty party;
  final DateTime savedAt;
  final String stampFee;
  final String totalAmount;

  /// Schema extras for e-App snapshot (lock-up, travel, risk, rider, …).
  final Map<String, String> extras;

  /// True for the placeholder quote `startEappForProduct` builds when a
  /// product has no calculated quote yet — the e-App's Premium step keeps
  /// this one editable instead of showing it as a locked summary.
  bool get isDraftPlaceholder => id == 'QT-DRAFT';
}

class BeneficiaryDraft {
  BeneficiaryDraft({
    required this.name,
    required this.relationship,
    required this.fatherName,
    required this.identification,
    required this.dob,
    required this.mobile,
    required this.percent,
  });

  String name;
  String relationship;
  String fatherName;
  String identification;
  DateTime dob;
  String mobile;
  int percent;
}

class PersonDraft {
  PersonDraft({
    required this.name,
    required this.mobile,
    required this.altMobile,
    required this.idType,
    required this.identification,
    required this.gender,
    required this.email,
    required this.fatherName,
    required this.dob,
    required this.height,
    required this.weight,
    required this.occupation,
    required this.town,
    required this.township,
    required this.state,
    required this.address,
  });

  String name;
  String mobile;
  String altMobile;
  String idType;
  String identification;
  String gender;
  String email;
  String fatherName;
  DateTime dob;
  String height;
  String weight;
  String occupation;
  String town;
  String township;
  String state;
  String address;
}

class EappDraft {
  EappDraft({
    required this.id,
    required this.quote,
    required this.status,
    required this.step,
    required this.policyholder,
    required this.sameAsLifeAssured,
    required this.lifeAssured,
    required this.nrcCaptured,
    required this.beneficiaries,
    required this.highRisk,
    required this.healthRemark,
    this.intent = EappLaunchIntent.newSale,
    this.sourcePolicyId,
  });

  final String id;
  SavedQuote quote;
  EappStatus status;
  int step;
  PersonDraft policyholder;
  bool sameAsLifeAssured;
  PersonDraft lifeAssured;
  bool nrcCaptured;
  List<BeneficiaryDraft> beneficiaries;
  bool highRisk;
  String healthRemark;
  String? appRef;
  final EappLaunchIntent intent;
  final String? sourcePolicyId;

  bool get isRenewal => intent == EappLaunchIntent.renewal;

  String get statusLabel => switch (status) {
    EappStatus.draft => 'Draft',
    EappStatus.submitted => 'Submitted',
    EappStatus.correction => 'Correction',
    EappStatus.approved => 'Approved',
    EappStatus.rejected => 'Rejected',
  };

  String get nextHint => switch (status) {
    EappStatus.draft => 'At step ${_stepName(step)}',
    EappStatus.submitted => 'Underwriting will update this row',
    EappStatus.correction => 'Fix the flagged step and re-submit',
    EappStatus.approved => 'Ready to view as policy (stub)',
    EappStatus.rejected => 'Closed — start a new quote if needed',
  };

  String get intentLabel => switch (intent) {
    EappLaunchIntent.newSale => 'New sale',
    EappLaunchIntent.renewal => 'Renewal',
    EappLaunchIntent.repurchase => 'Additional',
  };

  static String _stepName(int step) {
    const names = [
      'Policyholder',
      'Life Assured',
      'Scanner',
      'Beneficiary',
      'Health',
      'Premium',
      'Confirm',
    ];
    if (step < 0 || step >= names.length) return 'Policyholder';
    return names[step];
  }
}

abstract final class ProductFormat {
  static String dob(DateTime d) => AppDate.dMy(d);

  static int ageOn(DateTime dob, [DateTime? asOf]) {
    final now = asOf ?? DateTime(2026, 8, 14);
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  static String money(num value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final digits = parts[0];
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '${buf.toString()}.${parts[1]}';
  }

  static int parseMoney(String raw) {
    final t = raw.replaceAll(',', '').replaceAll(' ', '').trim();
    return double.tryParse(t)?.round() ?? 0;
  }
}

abstract final class ProductMockData {
  static const products = <CatalogProduct>[
    CatalogProduct(
      id: 'ul',
      code: 'UL',
      name: 'Universal Life',
      line: ProductLine.saving,
      tagline: 'Flexible savings with lifelong protection.',
      icon: Icons.public_outlined,
      about:
          'Universal Life combines life cover with a savings account you can top up. Cash value grows with declared rates; the death benefit pays the sum insured to beneficiaries.',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Anyone aged 16 to 65 looking to save while staying covered.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body:
              'Spouse, children, or dependents can be named as beneficiaries.',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body:
              'Useful as a staff benefit conversation — not a group/entity proposal.',
        ),
      ],
      whyBuy: [
        'Flexible premiums and top-ups',
        'Lifelong protection option',
        'Cash value you can illustrate in a quote',
        'Clear Core product code for e-App',
      ],
      coverage: [
        'Death benefit = sum insured',
        'Optional top-up premium',
        'Surrender value after the lock-in (illustrative)',
        'Policy term from the selected variant',
      ],
      rateCallout:
          'Age 26 · SI 30,000,000.00 → ~50,000.00 / month (indicative)',
      eligible: [
        'Entry age 16–65',
        'Myanmar resident for this prototype',
        'Insurable interest on the life assured',
        'Final eligibility is confirmed at e-App / underwriting',
      ],
      variants: [
        '2 years Saving Plus',
        '5 Plus 100',
        '10 Plus 100',
        '300 DIET',
      ],
      frequencies: ['Monthly', 'Quarterly', 'Annual'],
      terms: ['5 years', '10 years', '15 years', '20 years'],
      defaultTopup: 10000000,
    ),
    CatalogProduct(
      id: 'ste',
      code: 'STE',
      name: 'Short Term Endowment',
      line: ProductLine.saving,
      tagline: 'Save for a set term, then take the maturity benefit.',
      icon: Icons.savings_outlined,
      about:
          'Short Term Endowment pays a maturity benefit if the life assured survives the term, and a death benefit if not.',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Anyone aged 18 to 55 planning a 5–10 year savings goal.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body: 'Parents saving toward education or a family milestone.',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body: 'Can be discussed as a staff savings talking point only.',
        ),
      ],
      whyBuy: [
        'Defined term and maturity',
        'Death cover during the term',
        'Simple illustration for clients',
        'Affordable entry sum insured bands',
      ],
      coverage: [
        'Maturity = sum insured (illustrative)',
        'Death benefit during term',
        'No entity / group version in Phase 1',
      ],
      rateCallout: 'Age 30 · SI 10,000,000.00 → indicative annual premium',
      eligible: [
        'Entry age 18–55',
        'Term 5 or 10 years in this prototype',
        'Medical questions at e-App if required',
      ],
      variants: ['5 Year', '10 Year'],
      frequencies: ['Monthly', 'Annual'],
      terms: ['5 years', '10 years'],
      defaultSi: 10000000,
    ),
    CatalogProduct(
      id: 'pa',
      code: 'PA',
      name: 'Personal Accident',
      line: ProductLine.protection,
      tagline: 'Protects you with the payouts from 71 category of accidents.',
      icon: Icons.health_and_safety_outlined,
      about:
          'Personal Accidents policy protects you with the payouts from 71 categories of accidents, and full Sum Insured amount in case of accidental death and total permanent disability.',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Anyone aged 16 to 65 can purchase this policy.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body:
              'Spouse, children, or dependents can also be insured under this policy.',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body:
              'Companies can buy group personal accident insurance for their employees.',
        ),
      ],
      whyBuy: [
        'Comprehensive Coverage',
        'Peace of Mind',
        'Financial Security',
        'Affordable Premium',
      ],
      coverage: [
        '71 accident categories',
        'Accidental death — full sum insured',
        'Total permanent disability — full sum insured',
        'Medical reimbursement limits by plan',
      ],
      rateCallout: 'SI 5 Lakh · from ~3,600 MMK (indicative)',
      eligible: [
        'Age 16–65',
        'Individual lives — no entity beneficiary',
        'Occupation class reviewed at e-App',
      ],
      variants: ['Plan A', 'Plan B'],
      frequencies: ['Lumpsum', 'Annual'],
      terms: ['6 Months', '1 year'],
      defaultSi: 5000000,
    ),
    CatalogProduct(
      id: 'cl',
      code: 'CL',
      name: 'Credit Life',
      line: ProductLine.protection,
      tagline: 'Clears the outstanding loan if the life assured dies.',
      icon: Icons.credit_card_outlined,
      about:
          'Credit Life pays the outstanding loan balance to the financier (as directed) if the life assured dies during the cover period.',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Borrowers aged 18–60 with an active loan.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body: 'Protects dependents from inheriting the loan burden.',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body: 'Not a group scheme in Phase 1 — individual lives only.',
        ),
      ],
      whyBuy: [
        'Loan protection',
        'Simple annual term',
        'Fast quote from sum insured = loan',
      ],
      coverage: [
        'Death benefit toward outstanding loan',
        'Term matches the selected policy term',
      ],
      rateCallout: 'SI 10,000,000.00 · indicative annual premium',
      eligible: ['Age 18–60', 'Insurable interest / loan evidence at e-App'],
      variants: [
        'Decreasing',
        'Level',
        'Default Variant',
        'Short Term Single Premium',
      ],
      frequencies: ['Lumpsum', 'Annual', 'Monthly'],
      terms: ['1 year', '5 years'],
      defaultSi: 100000,
    ),
    CatalogProduct(
      id: 'fh',
      code: 'FH',
      name: 'Family Health',
      line: ProductLine.health,
      tagline: 'Hospital and medical limits for the life assured.',
      icon: Icons.favorite_outline,
      about:
          'Family Health provides hospital cash / medical limits for the insured person. Benefits are illustrative until Core pricing is wired.',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Adults 18–60 who want medical backup beside life cover.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body: 'Dependents listed at e-App where the product allows.',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body: 'Staff medical talk-track only — no group proposal here.',
        ),
      ],
      whyBuy: [
        'Hospital limits you can explain quickly',
        'Pairs with a life sale',
        'Health declaration captured in e-App',
      ],
      coverage: [
        'In-patient limit (illustrative)',
        'Accident medical (illustrative)',
      ],
      rateCallout: 'Age 30 · plan Silver → indicative annual premium',
      eligible: ['Age 18–60', 'Health questions at e-App'],
      variants: ['Silver', 'Gold', 'Basic Cover', 'Default Variant'],
      frequencies: ['Lumpsum', 'Annual'],
      terms: ['1 year'],
      defaultSi: 1000000,
    ),
    CatalogProduct(
      id: 'tp',
      code: 'TP',
      name: 'Travel Protect',
      line: ProductLine.travel,
      tagline: 'Trip medical and accident cover for the travel dates.',
      icon: Icons.flight_outlined,
      about:
          'Travel Protect covers accidental injury and emergency medical while travelling. Dates stay simple in this prototype (term chip).',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Travellers aged 16–70.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body: 'One life per quote in Phase 1 (single product).',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body: 'Business trip talk-track — still an individual life.',
        ),
      ],
      whyBuy: [
        'Short-term cover',
        'Accident + medical illustration',
        'Fast e-App after save quote',
      ],
      coverage: [
        'Emergency medical (illustrative)',
        'Accidental death while travelling',
      ],
      rateCallout: '15-day trip · SI 5,000,000.00 (indicative)',
      eligible: ['Age 16–70', 'Trip term selected on the quote'],
      variants: ['Domestic', 'Overseas', 'Default Variant'],
      frequencies: ['Lumpsum', 'Single'],
      terms: ['3 Days', '15 days', '30 days', '1 year'],
      defaultSi: 1000000,
    ),
    CatalogProduct(
      id: 'lp',
      code: 'LP',
      name: 'Life Plus Pack',
      line: ProductLine.bundled,
      tagline: 'One Core code: life cover with an accident rider illustration.',
      icon: Icons.layers_outlined,
      about:
          'Life Plus Pack is a single Core product (not two proposals). It illustrates life cover plus accident rider on one quote.',
      whoShould: [
        WhoShouldRow(
          icon: Icons.person_outline,
          title: 'Individuals',
          body: 'Ages 18–60 who want life + accident in one application.',
        ),
        WhoShouldRow(
          icon: Icons.groups_outlined,
          title: 'Families',
          body: 'One life assured per pack in Phase 1.',
        ),
        WhoShouldRow(
          icon: Icons.apartment_outlined,
          title: 'Employers',
          body: 'Not a group scheme.',
        ),
      ],
      whyBuy: [
        'One product code',
        'One e-App',
        'Clearer than two separate quotes',
      ],
      coverage: ['Life sum insured', 'Accident rider (illustrative)'],
      rateCallout: 'SI 20,000,000.00 · indicative monthly premium',
      eligible: ['Age 18–60', 'Single life — no multi-product cart'],
      variants: ['Pack A', 'Pack B', 'Grand Plan 1'],
      frequencies: ['Monthly', 'Semi-Annually', 'Annual'],
      terms: ['1 year', '5 years', '10 years'],
      defaultSi: 60000000,
    ),
  ];

  static CatalogProduct byId(String id) =>
      products.firstWhere((p) => p.id == id, orElse: () => products.first);

  static CatalogProduct byNameNear(String name) {
    final n = name.toLowerCase();
    for (final p in products) {
      if (p.name.toLowerCase() == n) return p;
    }
    for (final p in products) {
      if (n.contains(p.name.toLowerCase()) ||
          p.name.toLowerCase().contains(n)) {
        return p;
      }
    }
    if (n.contains('health')) {
      return products.firstWhere(
        (p) => p.line == ProductLine.health,
        orElse: () => products.first,
      );
    }
    if (n.contains('education') || n.contains('endowment')) {
      return products.firstWhere(
        (p) => p.line == ProductLine.saving,
        orElse: () => products.first,
      );
    }
    return products.first;
  }

  static List<CatalogProduct> filtered({
    required String query,
    ProductLine? line,
  }) {
    final q = query.trim().toLowerCase();
    return products.where((p) {
      final lineOk = line == null || p.line == line;
      final textOk =
          q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.tagline.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q);
      return lineOk && textOk;
    }).toList();
  }

  static List<ProductLine> get linesInCatalog {
    final seen = <ProductLine>{};
    final out = <ProductLine>[];
    for (final p in products) {
      if (seen.add(p.line)) out.add(p.line);
    }
    return out;
  }

  static int monthlyPremiumFor({
    required CatalogProduct product,
    required int si,
  }) {
    if (si <= 0) return 0;
    switch (product.line) {
      case ProductLine.saving:
      case ProductLine.bundled:
        return (si / 600).round();
      case ProductLine.protection:
        return (si / 140).round();
      case ProductLine.health:
        return (si / 200).round();
      case ProductLine.travel:
        return (si / 400).round();
    }
  }

  static List<QuoteParty> parties({String query = ''}) {
    final q = query.trim().toLowerCase();
    final clients = CustomerMockData.customers.map(
      (c) => QuoteParty(
        id: c.id,
        name: c.name,
        kind: QuotePartyKind.client,
        phone: c.phone,
        email: c.email,
        dob: c.dob,
        identification: c.identification,
        gender: c.gender,
      ),
    );
    final leads = leadsData.map(
      (l) => QuoteParty(
        id: 'lead-${l.id}',
        name: l.name,
        kind: QuotePartyKind.lead,
        phone: l.phone,
        email: l.email,
      ),
    );
    return [...clients, ...leads].where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          (p.phone ?? '').replaceAll(' ', '').contains(q.replaceAll(' ', ''));
    }).toList();
  }
}

abstract final class ProductSession {
  static final List<SavedQuote> quotes = [];
  static final List<EappDraft> applications = [];
  static int _q = 0;
  static int _a = 0;

  /// Last product opened for quote (Home Calculator shortcut).
  static String? lastProductId;

  static CatalogProduct get lastOrDefaultProduct =>
      byProductId(lastProductId) ?? ProductMockData.products.first;

  static CatalogProduct? byProductId(String? id) {
    if (id == null) return null;
    for (final p in ProductMockData.products) {
      if (p.id == id) return p;
    }
    return null;
  }

  static void rememberProduct(CatalogProduct product) {
    lastProductId = product.id;
  }

  /// Most recently saved quote for this product, if any — used to
  /// auto-fill the quote form when re-opening a product that already
  /// has a calculated quote, instead of asking the agent to retype it.
  static SavedQuote? latestQuoteFor(String productId) {
    for (final q in quotes) {
      if (q.productId == productId) return q;
    }
    return null;
  }

  static SavedQuote saveQuote({
    required CatalogProduct product,
    required String variant,
    required String frequency,
    required int si,
    required int topup,
    required String term,
    required DateTime dob,
    required QuoteParty party,
    int lockupAmount = 0,
    bool optionalBundle = false,
    String industryRisk = '',
    String lockupPeriod = '',
    String additionalCover = '',
    String travelBy = '',
    String plateNumber = '',
    String riderPlan = '',
    String riderFrequency = '',
    String discountName = '',
    String discountAmount = '0.00',
    int basePremiumAnnual = 0,
    String dividendRate = '',
  }) {
    rememberProduct(product);
    _q += 1;
    final calc = PremiumSchemas.calculate(
      product: product,
      si: si,
      topup: topup,
      lockupAmount: lockupAmount,
      optionalBundle: optionalBundle,
      industryRisk: industryRisk,
      basePremiumAnnual: basePremiumAnnual,
    );
    final extras = <String, String>{
      if (basePremiumAnnual > 0)
        'Base Premium (Annual)': ProductFormat.money(basePremiumAnnual),
      if (dividendRate.isNotEmpty) 'Dividend Rate': '$dividendRate%',
      if (lockupAmount > 0) 'Lock-Up Amount': ProductFormat.money(lockupAmount),
      if (lockupPeriod.isNotEmpty) 'Lock-Up Period': lockupPeriod,
      if (industryRisk.isNotEmpty) 'Industry Risk': industryRisk,
      if (additionalCover.isNotEmpty && additionalCover != 'None')
        'Additional Cover': additionalCover,
      if (travelBy.isNotEmpty) 'Travel By': travelBy,
      if (plateNumber.isNotEmpty) 'Plate Number': plateNumber,
      if (optionalBundle) ...{
        if (riderPlan.isNotEmpty) 'Rider Plan': riderPlan,
        if (riderFrequency.isNotEmpty)
          'Rider Payment Frequency': riderFrequency,
        'Rider Premium': ProductFormat.money(calc.riderPremium),
      },
      if (discountName.isNotEmpty) 'Discount Name': discountName,
      if (discountAmount != '0.00' && discountAmount.isNotEmpty)
        'Discount Amount': discountAmount,
    };
    final quote = SavedQuote(
      id: 'QT-2026-${_q.toString().padLeft(4, '0')}',
      productId: product.id,
      productName: product.name,
      productCode: product.code,
      lineLabel: product.lineLabel,
      variant: variant,
      frequency: frequency,
      sumInsured: ProductFormat.money(si),
      monthlyPremium: ProductFormat.money(calc.premium),
      topup: ProductFormat.money(topup),
      term: term,
      dob: dob,
      age: ProductFormat.ageOn(dob),
      party: party,
      savedAt: DateTime(2026, 8, 14),
      stampFee: ProductFormat.money(calc.stampFee),
      totalAmount: ProductFormat.money(calc.total),
      extras: extras,
    );
    quotes.insert(0, quote);
    return quote;
  }

  static EappDraft startEapp(
    SavedQuote quote, {
    EappLaunchIntent intent = EappLaunchIntent.newSale,
    String? sourcePolicyId,
    List<BeneficiaryDraft>? beneficiaries,
  }) {
    _a += 1;
    final ph = _personFrom(quote.party, fallbackDob: quote.dob);
    final draft = EappDraft(
      id: 'EA-2026-${_a.toString().padLeft(4, '0')}',
      quote: quote,
      status: EappStatus.draft,
      step: 0,
      policyholder: ph,
      sameAsLifeAssured: true,
      lifeAssured: _copyPerson(ph),
      nrcCaptured: false,
      beneficiaries:
          beneficiaries ??
          [
            BeneficiaryDraft(
              name: 'Zaw Min Thu',
              relationship: 'Father',
              fatherName: 'U Min Thu',
              identification: '12/PAZATA(N)548964',
              dob: DateTime(1972, 3, 8),
              mobile: quote.party.phone ?? '09 750337968',
              percent: 100,
            ),
          ],
      highRisk: false,
      healthRemark: '',
      intent: intent,
      sourcePolicyId: sourcePolicyId,
    );
    applications.insert(0, draft);
    return draft;
  }

  static List<SavedQuote> quotesForParty(String partyId) =>
      quotes.where((q) => q.party.id == partyId).toList();

  /// Jumps straight from a Product into the e-App. Reuses the product's
  /// most recently calculated quote when one exists (docs/86); otherwise
  /// starts the wizard with a blank policyholder so the agent can fill in
  /// the Get A Quote details (DOB, sum insured, premium) inside the e-App
  /// itself, instead of being blocked and sent back to Get A Quote first.
  static EappDraft startEappForProduct(
    CatalogProduct product, {
    EappLaunchIntent intent = EappLaunchIntent.newSale,
  }) {
    final existing = latestQuoteFor(product.id);
    if (existing != null) {
      return startEapp(existing, intent: intent);
    }
    rememberProduct(product);
    final fallbackDob = DateTime(1999, 6, 4);
    final blankQuote = SavedQuote(
      id: 'QT-DRAFT',
      productId: product.id,
      productName: product.name,
      productCode: product.code,
      lineLabel: product.lineLabel,
      variant: product.variants.first,
      frequency: product.frequencies.first,
      sumInsured: ProductFormat.money(0),
      monthlyPremium: ProductFormat.money(0),
      topup: ProductFormat.money(0),
      term: product.terms.first,
      dob: fallbackDob,
      age: ProductFormat.ageOn(fallbackDob),
      party: QuoteParty(
        id: 'blank-${DateTime.now().millisecondsSinceEpoch}',
        name: '',
        kind: QuotePartyKind.lead,
      ),
      savedAt: DateTime(2026, 8, 14),
    );
    // Not added to `quotes` — it's a placeholder for the draft only, not
    // a real calculated quote the agent should see in their saved list.
    return startEapp(blankQuote, intent: intent);
  }

  static int _parseSi(String raw) {
    final n = int.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), ''));
    if (n == null || n == 0) return 30000000;
    if (n < 1000) return n * 1000000;
    return n;
  }

  static EappDraft startEappFromPolicy(PolicyMock policy) {
    final product = ProductMockData.byNameNear(policy.productName);
    final party = QuoteParty(
      id: policy.clientId,
      name: policy.clientName,
      kind: QuotePartyKind.client,
      phone: policy.policyholder.rows['Mobile'],
      email: policy.policyholder.rows['Email'],
      identification: policy.insured.rows['Identification'],
      gender: policy.insured.rows['Gender'],
    );
    _q += 1;
    final si = _parseSi(policy.sumInsured);
    final prem = _parseSi(policy.premium);
    final quote = SavedQuote(
      id: 'QT-REN-${_q.toString().padLeft(3, '0')}',
      productId: product.id,
      productName: product.name,
      productCode: product.code,
      lineLabel: product.lineLabel,
      variant: product.variants.first,
      frequency: policy.frequency,
      sumInsured: ProductFormat.money(si),
      monthlyPremium: ProductFormat.money(prem),
      topup: ProductFormat.money(0),
      term: policy.term,
      dob: DateTime(1999, 6, 4),
      age: policy.ageAtIssue,
      party: party,
      savedAt: DateTime(2026, 8, 17),
    );
    quotes.insert(0, quote);
    final benName = policy.beneficiary.rows['Name'] ?? 'Beneficiary';
    final draft = startEapp(
      quote,
      intent: EappLaunchIntent.renewal,
      sourcePolicyId: policy.id,
      beneficiaries: [
        BeneficiaryDraft(
          name: benName,
          relationship: policy.beneficiary.rows['Relationship'] ?? 'Spouse',
          fatherName: '',
          identification: '',
          dob: DateTime(1972, 3, 8),
          mobile: policy.policyholder.rows['Mobile'] ?? '09 750337968',
          percent: 100,
        ),
      ],
    );
    final phRows = policy.policyholder.rows;
    final laRows = policy.insured.rows;
    final phName = phRows['Name'] ?? policy.clientName;
    draft.policyholder
      ..name = phName
      ..mobile = phRows['Mobile'] ?? draft.policyholder.mobile
      ..altMobile = phRows['Mobile'] ?? draft.policyholder.altMobile
      ..email = phRows['Email'] ?? draft.policyholder.email
      ..address = phRows['Address'] ?? draft.policyholder.address
      ..identification =
          laRows['Identification'] ?? draft.policyholder.identification
      ..gender = laRows['Gender'] ?? draft.policyholder.gender;
    final laName = laRows['Name'] ?? phName;
    draft.sameAsLifeAssured = laName == phName;
    if (draft.sameAsLifeAssured) {
      draft.lifeAssured = _copyPerson(draft.policyholder);
    } else {
      draft.lifeAssured
        ..name = laName
        ..identification =
            laRows['Identification'] ?? draft.lifeAssured.identification
        ..gender = laRows['Gender'] ?? draft.lifeAssured.gender;
    }
    return draft;
  }

  static EappDraft? openDraftForPolicy(String policyId) {
    for (final a in applications) {
      if (a.sourcePolicyId == policyId &&
          (a.status == EappStatus.draft || a.status == EappStatus.correction)) {
        return a;
      }
    }
    return null;
  }

  static EappDraft? appById(String id) {
    for (final a in applications) {
      if (a.id == id) return a;
    }
    return null;
  }

  static SavedQuote? quoteById(String id) {
    for (final q in quotes) {
      if (q.id == id) return q;
    }
    return null;
  }

  static int beneficiaryTotal(EappDraft draft) =>
      draft.beneficiaries.fold<int>(0, (sum, b) => sum + b.percent);

  static PersonDraft _personFrom(
    QuoteParty party, {
    required DateTime fallbackDob,
  }) {
    return PersonDraft(
      name: party.name,
      mobile: party.phone ?? '09 750337968',
      altMobile: party.phone ?? '09 750337968',
      idType: 'NRC',
      identification: party.identification ?? '12/KaMaNa(N)127487',
      gender: party.gender ?? 'Female',
      email: party.email ?? 'may@gmail.com',
      fatherName: 'Zaw Min Thu',
      dob: party.dob ?? fallbackDob,
      height: "5' 7\"",
      weight: '105',
      occupation: 'Designer',
      town: 'Yangon',
      township: 'Tamwe',
      state: 'Yangon',
      address: 'No.59, 1st Floor, 159 Street, Yangon, Myanmar.',
    );
  }

  static PersonDraft _copyPerson(PersonDraft p) {
    return PersonDraft(
      name: p.name,
      mobile: p.mobile,
      altMobile: p.altMobile,
      idType: p.idType,
      identification: p.identification,
      gender: p.gender,
      email: p.email,
      fatherName: p.fatherName,
      dob: p.dob,
      height: p.height,
      weight: p.weight,
      occupation: p.occupation,
      town: p.town,
      township: p.township,
      state: p.state,
      address: p.address,
    );
  }
}
