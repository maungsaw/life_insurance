import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/pages/compare.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductQuotePage extends StatefulWidget {
  const ProductQuotePage({super.key, required this.product});

  final CatalogProduct product;

  @override
  State<ProductQuotePage> createState() => _ProductQuotePageState();
}

class _ProductQuotePageState extends State<ProductQuotePage> {
  late CatalogProduct _product;
  late ProductLine _type;
  late String _variant;
  late String _frequency;
  late String _term;
  late DateTime _dob;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _siCtrl;
  late final TextEditingController _premiumCtrl;
  late final TextEditingController _topupCtrl;
  late final TextEditingController _variantCtrl;
  late final TextEditingController _freqCtrl;
  late final TextEditingController _termCtrl;
  late final TextEditingController _partyCtrl;
  QuoteParty? _party;
  bool _saving = false;
  String? _partyError;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _type = widget.product.line;
    ProductSession.rememberProduct(_product);
    _variant = _product.variants.first;
    _frequency = _product.frequencies.first;
    _term = _product.terms.first;
    _dob = DateTime(1999, 6, 4);
    _dobCtrl = TextEditingController(text: ProductFormat.dob(_dob));
    _siCtrl = TextEditingController(
      text: ProductFormat.money(_product.defaultSi),
    );
    _premiumCtrl = TextEditingController(text: _premiumLabel());
    _topupCtrl = TextEditingController(
      text: ProductFormat.money(_product.defaultTopup),
    );
    _variantCtrl = TextEditingController(text: _variant);
    _freqCtrl = TextEditingController(text: _frequency);
    _termCtrl = TextEditingController(text: _term);
    _partyCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _dobCtrl.dispose();
    _siCtrl.dispose();
    _premiumCtrl.dispose();
    _topupCtrl.dispose();
    _variantCtrl.dispose();
    _freqCtrl.dispose();
    _termCtrl.dispose();
    _partyCtrl.dispose();
    super.dispose();
  }

  int get _age => ProductFormat.ageOn(_dob);

  String _premiumLabel() {
    final si = ProductFormat.parseMoney(_siCtrl.text);
    return ProductFormat.money(
      ProductMockData.monthlyPremiumFor(product: _product, si: si),
    );
  }

  void _recalc() {
    _premiumCtrl.text = _premiumLabel();
    setState(() {});
  }

  void _applyProduct(CatalogProduct product) {
    ProductSession.rememberProduct(product);
    setState(() {
      _product = product;
      _type = product.line;
      _variant = product.variants.first;
      _frequency = product.frequencies.first;
      _term = product.terms.first;
      _siCtrl.text = ProductFormat.money(product.defaultSi);
      _topupCtrl.text = ProductFormat.money(product.defaultTopup);
      _variantCtrl.text = _variant;
      _freqCtrl.text = _frequency;
      _termCtrl.text = _term;
    });
    _recalc();
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

  Future<void> _pickParty() async {
    final party = await showQuotePartySheet(context);
    if (party == null) return;
    setState(() {
      _party = party;
      _partyError = null;
      _partyCtrl.text = '${party.name} (${party.kindLabel})';
      if (party.dob != null) {
        _dob = party.dob!;
        _dobCtrl.text = ProductFormat.dob(_dob);
      }
    });
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
      variant: _variant,
      frequency: _frequency,
      si: ProductFormat.parseMoney(_siCtrl.text),
      topup: ProductFormat.parseMoney(_topupCtrl.text),
      term: _term,
      dob: _dob,
      party: _party!,
    );
    setState(() => _saving = false);
    if (!mounted) return;
    context.push(AppRoute.productQuoteSaved, extra: quote);
  }

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
    _variantCtrl.text = _variant;
    _freqCtrl.text = _frequency;
    _termCtrl.text = _term;
  }

  @override
  Widget build(BuildContext context) {
    final typeLines = ProductMockData.linesInCatalog;
    final names = ProductMockData.products
        .where((p) => p.line == _type)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProductSubAppBar(title: 'Get A Quote'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
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
          AppTextField(
            label: 'Variant',
            isRequired: true,
            controller: _variantCtrl,
            readOnly: true,
            onTap: () => _dropdown(
              title: 'Variant',
              options: _product.variants,
              current: _variant,
              onPick: (v) => setState(() => _variant = v),
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Payment Frequency',
            isRequired: true,
            controller: _freqCtrl,
            readOnly: true,
            onTap: () => _dropdown(
              title: 'Payment Frequency',
              options: _product.frequencies,
              current: _frequency,
              onPick: (v) => setState(() => _frequency = v),
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Sum Insured Amount',
            isRequired: true,
            controller: _siCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => _recalc(),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Monthly Premium',
            controller: _premiumCtrl,
            enabled: false,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Topup Premium',
            controller: _topupCtrl,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Policy Terms',
            isRequired: true,
            controller: _termCtrl,
            readOnly: true,
            onTap: () => _dropdown(
              title: 'Policy Terms',
              options: _product.terms,
              current: _term,
              onPick: (v) => setState(() => _term = v),
            ),
          ),
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
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Premium (${_frequency.toLowerCase()})  ${_premiumCtrl.text} MMK',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _kv('Product Name', 'KBZ ${_product.name}'),
          _kv('Your Age', '$_age'),
          _kv('Sum Insured', '${_siCtrl.text} MMK'),
          _kv('Top-Up Premium', '${_topupCtrl.text} MMK'),
          _kv('Policy Term', _term),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Save quote',
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                tooltip: 'Compare',
                onPressed: () => openCompareFor(context, _product),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.12),
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
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
