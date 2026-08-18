import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

/// Side-by-side compare — display aid only; one product → Get A Quote (docs/59 P1, 92).
class ProductComparePage extends StatefulWidget {
  const ProductComparePage({
    super.key,
    required this.left,
    required this.right,
  });

  final CatalogProduct left;
  final CatalogProduct right;

  @override
  State<ProductComparePage> createState() => _ProductComparePageState();
}

class _ProductComparePageState extends State<ProductComparePage> {
  late CatalogProduct _left;
  late CatalogProduct _right;
  bool _pinLeft = true;

  @override
  void initState() {
    super.initState();
    _left = widget.left;
    _right = widget.right;
  }

  List<_CompareRow> get _rows => [
    _CompareRow('Policy Term', _left.terms.first, _right.terms.first),
    _CompareRow(
      'Premium (indicative)',
      ProductFormat.money(
        ProductMockData.monthlyPremiumFor(product: _left, si: _left.defaultSi),
      ),
      ProductFormat.money(
        ProductMockData.monthlyPremiumFor(
          product: _right,
          si: _right.defaultSi,
        ),
      ),
    ),
    _CompareRow(
      'Benefit',
      '${_left.whyBuy.length} highlights',
      '${_right.whyBuy.length} highlights',
    ),
    _CompareRow(
      'Coverage',
      ProductFormat.money(_left.defaultSi),
      ProductFormat.money(_right.defaultSi),
    ),
    _CompareRow('Line', _left.lineLabel, _right.lineLabel),
    _CompareRow('Code', _left.code, _right.code),
    _CompareRow(
      'Top-up',
      _left.defaultTopup > 0 ? 'Yes' : 'No',
      _right.defaultTopup > 0 ? 'Yes' : 'No',
    ),
    _CompareRow('Individual', 'Yes', 'Yes'),
    _CompareRow('Corporate / entity', 'No', 'No'),
  ];

  Future<void> _changeSlot({required bool left}) async {
    final current = left ? _left : _right;
    final other = left ? _right : _left;
    final picked = await showCompareProductPicker(
      context,
      current: current,
      other: other,
    );
    if (picked == null || !mounted || picked.id == current.id) return;
    setState(() {
      if (picked.id == other.id) {
        final wasLeft = _left;
        _left = _right;
        _right = wasLeft;
        _pinLeft = !_pinLeft;
        return;
      }
      if (left) {
        _left = picked;
      } else {
        _right = picked;
      }
    });
  }

  void _use(CatalogProduct product) {
    context.push(AppRoute.productQuote, extra: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: const ProductSubAppBar(title: 'Compare Details'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.1),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(1.2),
                },
                border: TableBorder.all(color: AppColors.border(context)),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: AppColors.lightPrimary,
                    ),
                    children: [
                      const _HeadCell('Feature', white: true),
                      _ProductHeadCell(
                        key: const Key('compare-head-left'),
                        product: _left,
                        onChange: () => _changeSlot(left: true),
                      ),
                      _ProductHeadCell(
                        key: const Key('compare-head-right'),
                        product: _right,
                        onChange: () => _changeSlot(left: false),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      color: AppColors.surface(context),
                    ),
                    children: [
                      const _BodyCell(''),
                      _PinCell(
                        pinned: _pinLeft,
                        onPin: () => setState(() => _pinLeft = true),
                      ),
                      _PinCell(
                        pinned: !_pinLeft,
                        onPin: () => setState(() => _pinLeft = false),
                      ),
                    ],
                  ),
                  for (var i = 0; i < _rows.length; i++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: i.isOdd
                            ? AppColors.mutedFill(context)
                            : AppColors.surface(context),
                      ),
                      children: [
                        _BodyCell(_rows[i].feature, bold: true),
                        _BodyCell(_rows[i].left),
                        _BodyCell(_rows[i].right),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Use ${_left.name.split(' ').first}',
                      variant: _pinLeft
                          ? AppButtonVariant.primary
                          : AppButtonVariant.secondary,
                      onPressed: () => _use(_left),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Use ${_right.name.split(' ').first}',
                      variant: _pinLeft
                          ? AppButtonVariant.secondary
                          : AppButtonVariant.primary,
                      onPressed: () => _use(_right),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow {
  const _CompareRow(this.feature, this.left, this.right);

  final String feature;
  final String left;
  final String right;
}

class _HeadCell extends StatelessWidget {
  const _HeadCell(this.text, {this.white = false});

  final String text;
  final bool white;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: white ? Colors.white : AppColors.onSurface(context),
        ),
      ),
    );
  }
}

class _ProductHeadCell extends StatelessWidget {
  const _ProductHeadCell({
    super.key,
    required this.product,
    required this.onChange,
  });

  final CatalogProduct product;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onChange,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            children: [
              Text(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Change',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell(this.text, {this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: AppColors.onSurface(context),
        ),
      ),
    );
  }
}

class _PinCell extends StatelessWidget {
  const _PinCell({required this.pinned, required this.onPin});

  final bool pinned;
  final VoidCallback onPin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: pinned
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Pinned',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightPrimary,
                  fontSize: 12,
                ),
              ),
            )
          : SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: onPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Pin',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
    );
  }
}

/// Opens compare with [product] pinned left and a same-line peer on the right.
void openCompareFor(BuildContext context, CatalogProduct product) {
  final peer = defaultComparePeer(product);
  if (peer.id == product.id) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Need another On product to compare.'),
      ),
    );
    return;
  }
  context.push(AppRoute.productCompare, extra: <CatalogProduct>[product, peer]);
}

/// Same-line On peer when possible; otherwise the first other catalog SKU.
CatalogProduct defaultComparePeer(CatalogProduct product) {
  final others = ProductMockData.products
      .where((p) => p.id != product.id)
      .toList();
  if (others.isEmpty) return product;
  return others.firstWhere(
    (p) => p.line == product.line,
    orElse: () => others.first,
  );
}

Future<CatalogProduct?> showCompareProductPicker(
  BuildContext context, {
  required CatalogProduct current,
  required CatalogProduct other,
}) {
  return showModalBottomSheet<CatalogProduct>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _CompareProductSheet(current: current, other: other),
  );
}

class _CompareProductSheet extends StatefulWidget {
  const _CompareProductSheet({
    required this.current,
    required this.other,
  });

  final CatalogProduct current;
  final CatalogProduct other;

  @override
  State<_CompareProductSheet> createState() => _CompareProductSheetState();
}

class _CompareProductSheetState extends State<_CompareProductSheet> {
  String _query = '';

  List<CatalogProduct> get _matches {
    final q = _query.trim().toLowerCase();
    return ProductMockData.products.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q) ||
          p.lineLabel.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Replace ${widget.current.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.onSurface(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Search name, code, or line',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                ),
              ),
              Expanded(
                child: matches.isEmpty
                    ? Center(
                        child: Text(
                          'No On products match.',
                          style: TextStyle(
                            color: AppColors.onSurfaceSecondary(context),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (ctx, i) {
                          final p = matches[i];
                          final isCurrent = p.id == widget.current.id;
                          final isOther = p.id == widget.other.id;
                          return ListTile(
                            leading: Icon(
                              p.icon,
                              color: AppColors.lightPrimary,
                            ),
                            title: Text(p.name),
                            subtitle: Text(
                              isOther
                                  ? '${p.lineLabel} · ${p.code} · On the other side · tap to swap'
                                  : '${p.lineLabel} · ${p.code}',
                            ),
                            trailing: isCurrent
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.lightPrimary,
                                  )
                                : isOther
                                ? const Icon(Icons.swap_horiz_rounded)
                                : null,
                            onTap: () => Navigator.pop(ctx, p),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
