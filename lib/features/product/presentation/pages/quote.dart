import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, GuestQuoteDraft, GuestSession, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/premium_schema.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/pages/compare.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductQuotePage extends StatefulWidget {
  const ProductQuotePage({super.key, required this.product, this.initialParty});

  final CatalogProduct product;
  final QuoteParty? initialParty;

  @override
  State<ProductQuotePage> createState() => _ProductQuotePageState();
}

class _ProductQuotePageState extends State<ProductQuotePage> {
  late CatalogProduct _product;
  late ProductPremiumSchema _schema;
  late String _variant;
  late String _frequency;
  late String _term;
  late String _lockupPeriod;
  late String _industryRisk;
  late String _additionalCover;
  late String _travelBy;
  late String _riderPlan;
  late String _riderFrequency;
  late String _discountName;
  late DateTime _dob;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _siCtrl;
  late final TextEditingController _premiumCtrl;
  late final TextEditingController _topupCtrl;
  late final TextEditingController _lockupCtrl;
  late final TextEditingController _plateCtrl;
  late final TextEditingController _discountAmountCtrl;
  late final TextEditingController _discountNameCtrl;
  late final TextEditingController _partyCtrl;
  late final TextEditingController _productNameCtrl;
  late final TextEditingController _variantCtrl;
  late final TextEditingController _freqCtrl;
  late final TextEditingController _termCtrl;
  late final TextEditingController _lockupPeriodCtrl;
  late final TextEditingController _industryRiskCtrl;
  late final TextEditingController _additionalCoverCtrl;
  late final TextEditingController _travelByCtrl;
  late final TextEditingController _riderPlanCtrl;
  late final TextEditingController _riderFreqCtrl;
  late final TextEditingController _basePremiumAnnualCtrl;
  late final TextEditingController _basePremiumMonthlyCtrl;
  late final TextEditingController _dividendRateCtrl;
  bool _optionalBundle = false;
  QuoteParty? _party;
  bool _saving = false;
  String? _partyError;
  QuoteCalcResult _calc = const QuoteCalcResult(
    premium: 0,
    stampFee: 0,
    riderPremium: 0,
    total: 0,
  );

  static const _discountNames = ['Staff', 'Promo', 'Loyalty'];

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    ProductSession.rememberProduct(_product);
    _dob = DateTime(1999, 6, 4);
    _dobCtrl = TextEditingController(text: ProductFormat.dob(_dob));
    _siCtrl = TextEditingController();
    _premiumCtrl = TextEditingController();
    _topupCtrl = TextEditingController();
    _lockupCtrl = TextEditingController();
    _plateCtrl = TextEditingController(text: '5K/3140');
    _discountAmountCtrl = TextEditingController(text: ProductFormat.money(0));
    _discountNameCtrl = TextEditingController();
    _partyCtrl = TextEditingController();
    _productNameCtrl = TextEditingController(text: _product.name);
    _variantCtrl = TextEditingController();
    _freqCtrl = TextEditingController();
    _termCtrl = TextEditingController();
    _lockupPeriodCtrl = TextEditingController();
    _industryRiskCtrl = TextEditingController();
    _additionalCoverCtrl = TextEditingController();
    _travelByCtrl = TextEditingController();
    _riderPlanCtrl = TextEditingController();
    _riderFreqCtrl = TextEditingController();
    _basePremiumAnnualCtrl = TextEditingController();
    _basePremiumMonthlyCtrl = TextEditingController();
    _dividendRateCtrl = TextEditingController();
    _discountName = '';
    _resetForProduct(_product, keepParty: false);
    if (widget.initialParty != null) {
      _applyParty(widget.initialParty!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _hydrateGuestDraft();
    });
  }

  @override
  void dispose() {
    _dobCtrl.dispose();
    _siCtrl.dispose();
    _premiumCtrl.dispose();
    _topupCtrl.dispose();
    _lockupCtrl.dispose();
    _plateCtrl.dispose();
    _discountAmountCtrl.dispose();
    _discountNameCtrl.dispose();
    _partyCtrl.dispose();
    _productNameCtrl.dispose();
    _variantCtrl.dispose();
    _freqCtrl.dispose();
    _termCtrl.dispose();
    _lockupPeriodCtrl.dispose();
    _industryRiskCtrl.dispose();
    _additionalCoverCtrl.dispose();
    _travelByCtrl.dispose();
    _riderPlanCtrl.dispose();
    _riderFreqCtrl.dispose();
    _basePremiumAnnualCtrl.dispose();
    _basePremiumMonthlyCtrl.dispose();
    _dividendRateCtrl.dispose();
    super.dispose();
  }

  int get _age => ProductFormat.ageOn(_dob);

  void _resetForProduct(CatalogProduct product, {required bool keepParty}) {
    _schema = PremiumSchemas.forProduct(product);
    _variant = product.variants.first;
    _frequency = product.frequencies.first;
    _term = product.terms.first;
    _lockupPeriod =
        _schema.of(PremiumFieldId.lockupPeriod)?.options.first ?? '';
    _industryRisk =
        _schema.of(PremiumFieldId.industryRisk)?.options.first ?? 'Low Risk';
    _additionalCover =
        _schema.of(PremiumFieldId.additionalCover)?.options.first ?? 'None';
    _travelBy = _schema.of(PremiumFieldId.travelBy)?.options.first ?? 'Car';
    _riderPlan = product.variants.first;
    _riderFrequency = product.frequencies.first;
    _optionalBundle = false;
    _siCtrl.text = ProductFormat.money(product.defaultSi);
    _topupCtrl.text = ProductFormat.money(
      _schema.has(PremiumFieldId.topup) ? product.defaultTopup : 0,
    );
    _lockupCtrl.text = ProductFormat.money(
      _schema.has(PremiumFieldId.lockupAmount) ? 10000000 : 0,
    );
    if (_schema.has(PremiumFieldId.basePremiumAnnual)) {
      _basePremiumAnnualCtrl.text = ProductFormat.money(600000);
      _dividendRateCtrl.text = '6.5';
    }
    if (!keepParty) {
      _party = null;
      _partyCtrl.clear();
      _partyError = null;
    }

    final existing = ProductSession.latestQuoteFor(product.id);
    if (existing != null) {
      _hydrateFromSavedQuote(existing, applyParty: !keepParty);
      return;
    }

    _syncDropdownCtrls();
    _recalc();
  }

  /// Prefills the form from a previously saved quote for the same product,
  /// so switching to (or reopening) a product that was already calculated
  /// doesn't require retyping every field.
  void _hydrateFromSavedQuote(SavedQuote quote, {required bool applyParty}) {
    _dob = quote.dob;
    _dobCtrl.text = ProductFormat.dob(_dob);
    if (_schema.has(PremiumFieldId.variant)) {
      _variant = quote.variant;
    }
    _frequency = quote.frequency;
    _term = quote.term;
    _siCtrl.text = quote.sumInsured;
    _topupCtrl.text = quote.topup;

    final extras = quote.extras;
    if (extras.containsKey('Base Premium (Annual)')) {
      _basePremiumAnnualCtrl.text = extras['Base Premium (Annual)']!;
    }
    if (extras.containsKey('Dividend Rate')) {
      _dividendRateCtrl.text = extras['Dividend Rate']!.replaceAll('%', '');
    }
    if (extras.containsKey('Lock-Up Amount')) {
      _lockupCtrl.text = extras['Lock-Up Amount']!;
    }
    if (extras.containsKey('Lock-Up Period')) {
      _lockupPeriod = extras['Lock-Up Period']!;
    }
    if (extras.containsKey('Industry Risk')) {
      _industryRisk = extras['Industry Risk']!;
    } else if (!_schema.has(PremiumFieldId.variant)) {
      _industryRisk = quote.variant;
    }
    if (extras.containsKey('Additional Cover')) {
      _additionalCover = extras['Additional Cover']!;
    }
    if (extras.containsKey('Travel By')) {
      _travelBy = extras['Travel By']!;
    }
    if (extras.containsKey('Plate Number')) {
      _plateCtrl.text = extras['Plate Number']!;
    }
    _optionalBundle = extras.containsKey('Rider Plan');
    if (extras.containsKey('Rider Plan')) {
      _riderPlan = extras['Rider Plan']!;
    }
    if (extras.containsKey('Rider Payment Frequency')) {
      _riderFrequency = extras['Rider Payment Frequency']!;
    }
    _discountName = extras['Discount Name'] ?? '';
    _discountAmountCtrl.text = extras['Discount Amount'] ?? ProductFormat.money(0);

    if (applyParty) {
      _applyParty(quote.party);
    }

    _syncDropdownCtrls();
    _recalc();
  }

  void _syncDropdownCtrls() {
    _productNameCtrl.text = _product.name;
    _variantCtrl.text = _variant;
    _freqCtrl.text = _frequency;
    _termCtrl.text = _term;
    _lockupPeriodCtrl.text = _lockupPeriod;
    _industryRiskCtrl.text = _industryRisk;
    _additionalCoverCtrl.text = _additionalCover;
    _travelByCtrl.text = _travelBy;
    _riderPlanCtrl.text = _riderPlan;
    _riderFreqCtrl.text = _riderFrequency;
    _discountNameCtrl.text = _discountName;
  }

  void _recalc() {
    _calc = PremiumSchemas.calculate(
      product: _product,
      si: _schema.has(PremiumFieldId.sumInsured)
          ? ProductFormat.parseMoney(_siCtrl.text)
          : 0,
      topup: _schema.has(PremiumFieldId.topup)
          ? ProductFormat.parseMoney(_topupCtrl.text)
          : 0,
      lockupAmount: _schema.has(PremiumFieldId.lockupAmount)
          ? ProductFormat.parseMoney(_lockupCtrl.text)
          : 0,
      optionalBundle: _optionalBundle,
      industryRisk: _industryRisk,
      basePremiumAnnual: _schema.has(PremiumFieldId.basePremiumAnnual)
          ? ProductFormat.parseMoney(_basePremiumAnnualCtrl.text)
          : 0,
    );
    if (_schema.has(PremiumFieldId.basePremiumMonthly)) {
      _basePremiumMonthlyCtrl.text = ProductFormat.money(_calc.premium);
    } else {
      _premiumCtrl.text = ProductFormat.money(_calc.premium);
    }
    setState(() {});
  }

  void _hydrateGuestDraft() {
    final d = GuestQuoteDraft.current;
    if (d == null || GuestSession.isGuest) return;
    final product = ProductSession.byProductId(d.productId);
    if (product != null && product.id != _product.id) {
      _product = product;
      _schema = PremiumSchemas.forProduct(product);
    }
    _dob = d.dob;
    _dobCtrl.text = ProductFormat.dob(_dob);
    _variant = d.variant;
    _frequency = d.frequency;
    _term = d.term;
    _siCtrl.text = d.si;
    _topupCtrl.text = d.topup;
    _lockupCtrl.text = d.lockupAmount;
    _lockupPeriod = d.lockupPeriod;
    _industryRisk = d.industryRisk;
    _additionalCover = d.additionalCover;
    _travelBy = d.travelBy;
    _plateCtrl.text = d.plateNumber;
    _optionalBundle = d.optionalBundle;
    _riderPlan = d.riderPlan;
    _riderFrequency = d.riderFrequency;
    _discountName = d.discountName;
    _discountAmountCtrl.text = d.discountAmount;
    _syncDropdownCtrls();
    GuestQuoteDraft.clear();
    _recalc();
  }

  void _captureGuestDraft() {
    GuestQuoteDraft.save(
      GuestQuoteDraft(
        productId: _product.id,
        dob: _dob,
        variant: _variant,
        frequency: _frequency,
        term: _term,
        si: _siCtrl.text,
        topup: _topupCtrl.text,
        lockupAmount: _lockupCtrl.text,
        lockupPeriod: _lockupPeriod,
        industryRisk: _industryRisk,
        additionalCover: _additionalCover,
        travelBy: _travelBy,
        plateNumber: _plateCtrl.text,
        optionalBundle: _optionalBundle,
        riderPlan: _riderPlan,
        riderFrequency: _riderFrequency,
        discountName: _discountName,
        discountAmount: _discountAmountCtrl.text,
        premiumLabel: ProductFormat.money(_calc.premium),
      ),
    );
  }

  Future<void> _loginToSave() async {
    _captureGuestDraft();
    await showLoginToSaveSheet(
      context,
      premiumLabel: ProductFormat.money(_calc.premium),
      frequency: _frequency,
    );
  }

  void _applyProduct(CatalogProduct product) {
    ProductSession.rememberProduct(product);
    setState(() {
      _product = product;
      _resetForProduct(product, keepParty: true);
    });
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1950),
      lastDate: DateTime(2026, 8, 14),
    );
    if (picked == null) return;
    setState(() {
      _dob = picked;
      _dobCtrl.text = ProductFormat.dob(picked);
    });
    _recalc();
  }

  void _applyParty(QuoteParty party) {
    _party = party;
    _partyError = null;
    _partyCtrl.text = '${party.name} (${party.kindLabel})';
    if (party.dob != null) {
      _dob = party.dob!;
      _dobCtrl.text = ProductFormat.dob(_dob);
    }
  }

  Future<void> _pickParty() async {
    final party = await showQuotePartySheet(context);
    if (party == null) return;
    setState(() => _applyParty(party));
    _recalc();
  }

  Future<void> _save() async {
    if (_party == null) {
      setState(() => _partyError = 'Link a Lead or Client to save.');
      return;
    }
    setState(() => _saving = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;
    final quote = ProductSession.saveQuote(
      product: _product,
      variant: _schema.has(PremiumFieldId.variant)
          ? _variant
          : (_industryRisk.isNotEmpty
                ? _industryRisk
                : _product.variants.first),
      frequency: _frequency,
      si: _schema.has(PremiumFieldId.sumInsured)
          ? ProductFormat.parseMoney(_siCtrl.text)
          : 0,
      topup: _schema.has(PremiumFieldId.topup)
          ? ProductFormat.parseMoney(_topupCtrl.text)
          : 0,
      term: _term,
      dob: _dob,
      party: _party!,
      lockupAmount: _schema.has(PremiumFieldId.lockupAmount)
          ? ProductFormat.parseMoney(_lockupCtrl.text)
          : 0,
      lockupPeriod: _lockupPeriod,
      optionalBundle: _optionalBundle,
      industryRisk: _industryRisk,
      additionalCover: _additionalCover,
      travelBy: _travelBy,
      plateNumber: _showPlate ? _plateCtrl.text.trim() : '',
      riderPlan: _optionalBundle ? _riderPlan : '',
      riderFrequency: _optionalBundle ? _riderFrequency : '',
      discountName: _discountName,
      discountAmount: _discountAmountCtrl.text,
      basePremiumAnnual: _schema.has(PremiumFieldId.basePremiumAnnual)
          ? ProductFormat.parseMoney(_basePremiumAnnualCtrl.text)
          : 0,
      dividendRate: _schema.has(PremiumFieldId.dividendRate)
          ? _dividendRateCtrl.text.trim()
          : '',
    );
    setState(() => _saving = false);
    if (!mounted) return;
    // Buy saves the quote as a draft and goes straight into the e-App —
    // no separate "quote saved" stop, since the e-App already reuses
    // every field from this quote.
    final draft = ProductSession.startEapp(quote);
    if (!mounted) return;
    context.push(AppRoute.productEapp, extra: draft);
  }

  bool get _showPlate =>
      _schema.has(PremiumFieldId.plateNumber) && _travelBy == 'Car';

  Future<void> _dropdown({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onPick,
  }) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              for (final o in options)
                ListTile(
                  title: Text(o),
                  trailing: o == current
                      ? const Icon(Icons.check, color: AppColors.lightPrimary)
                      : null,
                  onTap: () => Navigator.pop(ctx, o),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null) return;
    onPick(picked);
    _recalc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: const ProductSubAppBar(title: 'Get A Quote'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          if (GuestSession.isGuest) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'You’re not signed in. Estimates aren’t saved until you log in.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Select Product',
                  isRequired: true,
                  controller: _productNameCtrl,
                  readOnly: true,
                  onTap: () => _dropdown(
                    title: 'Select Product',
                    options: [
                      for (final p in ProductMockData.products) p.name,
                    ],
                    current: _product.name,
                    onPick: (v) {
                      final picked = ProductMockData.products.firstWhere(
                        (p) => p.name == v,
                      );
                      _applyProduct(picked);
                    },
                  ),
                  suffix: const Icon(Icons.expand_more, size: 18),
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Date of Birth (Insured Person)',
                  isRequired: true,
                  controller: _dobCtrl,
                  readOnly: true,
                  onTap: _pickDob,
                  suffix: IconButton(
                    onPressed: _pickDob,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Age $_age',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
                const SizedBox(height: 18),
                ..._schemaFields(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Discount Name',
                        controller: _discountNameCtrl,
                        readOnly: true,
                        hintText: 'Optional',
                        onTap: () => _dropdown(
                          title: 'Discount Name',
                          options: ['(None)', ..._discountNames],
                          current: _discountName.isEmpty
                              ? '(None)'
                              : _discountName,
                          onPick: (v) {
                            setState(() {
                              _discountName = v == '(None)' ? '' : v;
                              _discountNameCtrl.text = _discountName;
                            });
                          },
                        ),
                        suffix: const Icon(Icons.expand_more, size: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppTextField(
                        label: 'Discount Amount',
                        controller: _discountAmountCtrl,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                if (!GuestSession.isGuest) ...[
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Link to',
                    isRequired: true,
                    controller: _partyCtrl,
                    readOnly: true,
                    errorText: _partyError,
                    hintText: 'Lead or Client',
                    onTap: _pickParty,
                    suffix: const Icon(Icons.unfold_more, size: 18),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          QuotePremiumSummaryCard(
            productName: _product.name,
            frequency: _frequency,
            premium: ProductFormat.money(_calc.premium),
            age: _age,
            variant: _schema.has(PremiumFieldId.variant)
                ? _variant
                : (_industryRisk.isNotEmpty ? _industryRisk : null),
            sumInsured: _schema.has(PremiumFieldId.sumInsured)
                ? _siCtrl.text
                : null,
            topup: _schema.has(PremiumFieldId.topup) ? _topupCtrl.text : null,
            term: _schema.has(PremiumFieldId.policyTerms) ? _term : null,
            stampFee: ProductFormat.money(_calc.stampFee),
            total: ProductFormat.money(_calc.total),
            extraRows: {
              if (_schema.has(PremiumFieldId.basePremiumAnnual))
                'Base Premium (Annual)': _basePremiumAnnualCtrl.text,
              if (_schema.has(PremiumFieldId.dividendRate) &&
                  _dividendRateCtrl.text.isNotEmpty)
                'Dividend Rate': '${_dividendRateCtrl.text}%',
              if (_schema.has(PremiumFieldId.lockupAmount))
                'Lock-Up Amount': _lockupCtrl.text,
              if (_lockupPeriod.isNotEmpty &&
                  _schema.has(PremiumFieldId.lockupPeriod))
                'Lock-Up Period': _lockupPeriod,
              if (_additionalCover.isNotEmpty && _additionalCover != 'None')
                'Additional Cover': _additionalCover,
              if (_travelBy.isNotEmpty && _schema.has(PremiumFieldId.travelBy))
                'Travel By': _travelBy,
              if (_showPlate) 'Plate Number': _plateCtrl.text,
              if (_optionalBundle) ...{
                'Rider Plan': _riderPlan,
                'Rider Payment Frequency': _riderFrequency,
                'Rider Premium': ProductFormat.money(_calc.riderPremium),
              },
              if (_discountName.isNotEmpty) 'Discount Name': _discountName,
              if (ProductFormat.parseMoney(_discountAmountCtrl.text) > 0)
                'Discount Amount': _discountAmountCtrl.text,
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Indicative · final premium from Core calculator',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: GuestSession.isGuest ? 'Login to buy' : 'Buy',
                  isLoading: _saving,
                  onPressed: GuestSession.isGuest ? _loginToSave : _save,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                tooltip: 'Compare',
                onPressed: () => openCompareFor(context, _product),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary.withValues(
                    alpha: 0.12,
                  ),
                  foregroundColor: AppColors.lightPrimary,
                ),
                icon: const Icon(Icons.compare_arrows_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _schemaFields() {
    final out = <Widget>[];
    for (final field in _schema.fields) {
      if (field.id == PremiumFieldId.riderPlan ||
          field.id == PremiumFieldId.riderFrequency) {
        if (!_optionalBundle) continue;
      }
      if (field.id == PremiumFieldId.plateNumber && !_showPlate) continue;

      out.add(_buildField(field));
      out.add(const SizedBox(height: 14));
    }
    return out;
  }

  Widget _buildField(PremiumFieldSpec field) {
    switch (field.id) {
      case PremiumFieldId.variant:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _variantCtrl,
          options: field.options,
          onPick: (v) => setState(() => _variant = v),
        );
      case PremiumFieldId.frequency:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _freqCtrl,
          options: field.options,
          onPick: (v) => setState(() => _frequency = v),
        );
      case PremiumFieldId.policyTerms:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _termCtrl,
          options: field.options,
          onPick: (v) => setState(() => _term = v),
        );
      case PremiumFieldId.lockupPeriod:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _lockupPeriodCtrl,
          options: field.options,
          onPick: (v) => setState(() => _lockupPeriod = v),
        );
      case PremiumFieldId.industryRisk:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _industryRiskCtrl,
          options: field.options,
          onPick: (v) => setState(() => _industryRisk = v),
        );
      case PremiumFieldId.additionalCover:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _additionalCoverCtrl,
          options: field.options,
          onPick: (v) => setState(() => _additionalCover = v),
        );
      case PremiumFieldId.travelBy:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _travelByCtrl,
          options: field.options,
          onPick: (v) => setState(() => _travelBy = v),
        );
      case PremiumFieldId.riderPlan:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _riderPlanCtrl,
          options: field.options,
          onPick: (v) => setState(() => _riderPlan = v),
        );
      case PremiumFieldId.riderFrequency:
        return _dropdownField(
          label: field.label,
          required: field.isRequired,
          controller: _riderFreqCtrl,
          options: field.options,
          onPick: (v) => setState(() => _riderFrequency = v),
        );
      case PremiumFieldId.sumInsured:
        return AppTextField(
          label: field.label,
          isRequired: field.isRequired,
          controller: _siCtrl,
          readOnly: field.readOnly,
          enabled: !field.readOnly,
          keyboardType: TextInputType.number,
          onChanged: (_) => _recalc(),
        );
      case PremiumFieldId.premium:
        return AppTextField(
          label: field.label,
          controller: _premiumCtrl,
          enabled: false,
        );
      case PremiumFieldId.topup:
        return AppTextField(
          label: field.label,
          controller: _topupCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => _recalc(),
        );
      case PremiumFieldId.lockupAmount:
        return AppTextField(
          label: field.label,
          controller: _lockupCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => _recalc(),
        );
      case PremiumFieldId.plateNumber:
        return AppTextField(
          label: field.label,
          isRequired: field.isRequired,
          controller: _plateCtrl,
        );
      case PremiumFieldId.basePremiumAnnual:
        return AppTextField(
          label: field.label,
          isRequired: field.isRequired,
          controller: _basePremiumAnnualCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => _recalc(),
        );
      case PremiumFieldId.basePremiumMonthly:
        return AppTextField(
          label: field.label,
          controller: _basePremiumMonthlyCtrl,
          enabled: false,
        );
      case PremiumFieldId.dividendRate:
        return AppTextField(
          label: field.label,
          controller: _dividendRateCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        );
      case PremiumFieldId.optionalBundle:
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _optionalBundle,
          activeColor: AppColors.lightPrimary,
          title: Text(
            field.label,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (v) {
            setState(() => _optionalBundle = v ?? false);
            _recalc();
          },
        );
    }
  }

  Widget _dropdownField({
    required String label,
    required bool required,
    required TextEditingController controller,
    required List<String> options,
    required ValueChanged<String> onPick,
  }) {
    return AppTextField(
      label: label,
      isRequired: required,
      controller: controller,
      readOnly: true,
      onTap: () => _dropdown(
        title: label,
        options: options,
        current: controller.text,
        onPick: (v) {
          onPick(v);
          controller.text = v;
        },
      ),
      suffix: const Icon(Icons.expand_more, size: 18),
    );
  }
}

class QuotePremiumSummaryCard extends StatelessWidget {
  const QuotePremiumSummaryCard({
    super.key,
    required this.productName,
    required this.frequency,
    required this.premium,
    required this.age,
    required this.stampFee,
    required this.total,
    this.variant,
    this.sumInsured,
    this.term,
    this.topup,
    this.extraRows = const {},
  });

  final String productName;
  final String frequency;
  final String premium;
  final int age;
  final String? sumInsured;
  final String? term;
  final String stampFee;
  final String total;
  final String? variant;
  final String? topup;
  final Map<String, String> extraRows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero: the number the agent (and client) actually care about.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.lightPrimary.withValues(alpha: 0.14),
                  AppColors.lightPrimary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bookmark_border,
                      color: AppColors.lightPrimary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      premium,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'MMK / $frequency',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceSecondary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DETAILS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
                const SizedBox(height: 8),
                if (variant != null) _kv(context, 'Variant', variant!),
                _kv(context, 'Your Age', '$age'),
                if (sumInsured != null) _kv(context, 'Sum Insured', sumInsured!),
                if (topup != null && topup != '0.00')
                  _kv(context, 'Top-Up Premium', topup!),
                if (term != null) _kv(context, 'Policy Terms', term!),
                for (final e in extraRows.entries) _kv(context, e.key, e.value),
                _kv(context, 'Stamp Fee', stampFee),
                const Divider(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Amount',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      total,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
            ),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
