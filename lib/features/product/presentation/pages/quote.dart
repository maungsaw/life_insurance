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
  late ProductLine _type;
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
  late final TextEditingController _variantCtrl;
  late final TextEditingController _freqCtrl;
  late final TextEditingController _termCtrl;
  late final TextEditingController _lockupPeriodCtrl;
  late final TextEditingController _industryRiskCtrl;
  late final TextEditingController _additionalCoverCtrl;
  late final TextEditingController _travelByCtrl;
  late final TextEditingController _riderPlanCtrl;
  late final TextEditingController _riderFreqCtrl;
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
    _type = widget.product.line;
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
    _variantCtrl = TextEditingController();
    _freqCtrl = TextEditingController();
    _termCtrl = TextEditingController();
    _lockupPeriodCtrl = TextEditingController();
    _industryRiskCtrl = TextEditingController();
    _additionalCoverCtrl = TextEditingController();
    _travelByCtrl = TextEditingController();
    _riderPlanCtrl = TextEditingController();
    _riderFreqCtrl = TextEditingController();
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
    _variantCtrl.dispose();
    _freqCtrl.dispose();
    _termCtrl.dispose();
    _lockupPeriodCtrl.dispose();
    _industryRiskCtrl.dispose();
    _additionalCoverCtrl.dispose();
    _travelByCtrl.dispose();
    _riderPlanCtrl.dispose();
    _riderFreqCtrl.dispose();
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
    if (!keepParty) {
      _party = null;
      _partyCtrl.clear();
      _partyError = null;
    }
    _syncDropdownCtrls();
    _recalc();
  }

  void _syncDropdownCtrls() {
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
      si: ProductFormat.parseMoney(_siCtrl.text),
      topup: _schema.has(PremiumFieldId.topup)
          ? ProductFormat.parseMoney(_topupCtrl.text)
          : 0,
      lockupAmount: _schema.has(PremiumFieldId.lockupAmount)
          ? ProductFormat.parseMoney(_lockupCtrl.text)
          : 0,
      optionalBundle: _optionalBundle,
      industryRisk: _industryRisk,
    );
    _premiumCtrl.text = ProductFormat.money(_calc.premium);
    setState(() {});
  }

  void _hydrateGuestDraft() {
    final d = GuestQuoteDraft.current;
    if (d == null || GuestSession.isGuest) return;
    final product = ProductSession.byProductId(d.productId);
    if (product != null && product.id != _product.id) {
      _product = product;
      _type = product.line;
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
      _type = product.line;
      _resetForProduct(product, keepParty: true);
    });
  }

  void _selectType(ProductLine line) {
    final next = ProductMockData.products.firstWhere((p) => p.line == line);
    _applyProduct(next);
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
      si: ProductFormat.parseMoney(_siCtrl.text),
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
    );
    setState(() => _saving = false);
    if (!mounted) return;
    context.push(AppRoute.productQuoteSaved, extra: quote);
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
                  style: const TextStyle(fontWeight: FontWeight.w800),
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
    final typeLines = ProductMockData.linesInCatalog;
    final names = ProductMockData.products
        .where((p) => p.line == _type)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
              child: const Text(
                'You’re not signed in. Estimates aren’t saved until you log in.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          const QuoteRequiredLabel('Product Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final line in typeLines)
                QuoteTypeChip(
                  label: switch (line) {
                    ProductLine.protection => 'Protection',
                    ProductLine.saving => 'Saving',
                    ProductLine.travel => 'Travel',
                    ProductLine.health => 'Health',
                    ProductLine.bundled => 'Bundle',
                  },
                  selected: _type == line,
                  onTap: () => _selectType(line),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const QuoteRequiredLabel('Product Name'),
          const SizedBox(height: 8),
          if (names.length <= 3)
            Row(
              children: [
                for (var i = 0; i < names.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: QuoteNameTile(
                      label: names[i].name,
                      selected: _product.id == names[i].id,
                      onTap: () => _applyProduct(names[i]),
                    ),
                  ),
                ],
              ],
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: names.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.4,
              ),
              itemBuilder: (context, i) {
                final p = names[i];
                return QuoteNameTile(
                  label: p.name,
                  selected: _product.id == p.id,
                  onTap: () => _applyProduct(p),
                );
              },
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
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          ..._schemaFields(),
          const SizedBox(height: 4),
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
                    current: _discountName.isEmpty ? '(None)' : _discountName,
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
          const SizedBox(height: 18),
          QuotePremiumSummaryCard(
            productName: _product.name,
            frequency: _frequency,
            premium: ProductFormat.money(_calc.premium),
            age: _age,
            variant: _schema.has(PremiumFieldId.variant)
                ? _variant
                : (_industryRisk.isNotEmpty ? _industryRisk : null),
            sumInsured: _siCtrl.text,
            topup: _schema.has(PremiumFieldId.topup) ? _topupCtrl.text : null,
            term: _term,
            stampFee: ProductFormat.money(_calc.stampFee),
            total: ProductFormat.money(_calc.total),
            extraRows: {
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
          const Text(
            'Indicative · final premium from Core calculator',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.lightTextHint),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: GuestSession.isGuest
                      ? 'Login to save quote'
                      : 'Save quote',
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
      case PremiumFieldId.optionalBundle:
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _optionalBundle,
          activeColor: AppColors.lightPrimary,
          title: Text(
            field.label,
            style: const TextStyle(fontWeight: FontWeight.w600),
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
    required this.sumInsured,
    required this.term,
    required this.stampFee,
    required this.total,
    this.variant,
    this.topup,
    this.extraRows = const {},
  });

  final String productName;
  final String frequency;
  final String premium;
  final int age;
  final String sumInsured;
  final String term;
  final String stampFee;
  final String total;
  final String? variant;
  final String? topup;
  final Map<String, String> extraRows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.bookmark_border,
                color: AppColors.lightPrimary.withValues(alpha: 0.7),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Premium ($frequency)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  premium,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _kv('Product Name', productName),
          if (variant != null) _kv('Variant', variant!),
          _kv('Payment Frequency', frequency),
          _kv('Your Age', '$age'),
          _kv('Sum Insured', sumInsured),
          if (topup != null && topup != '0.00') _kv('Top-Up Premium', topup!),
          _kv('Policy Terms', term),
          for (final e in extraRows.entries) _kv(e.key, e.value),
          _kv('Stamp Fee', stampFee),
          const Divider(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Amount',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(total, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(color: AppColors.lightTextSecondary),
            ),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
