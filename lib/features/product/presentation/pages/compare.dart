import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

/// Side-by-side compare — display aid only; one product → Get A Quote (docs/59 P1).
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                border: TableBorder.all(color: AppColors.lightBorder),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: AppColors.lightPrimary,
                    ),
                    children: [
                      const _HeadCell('Feature', white: true),
                      _HeadCell(_left.name, white: true),
                      _HeadCell(_right.name, white: true),
                    ],
                  ),
                  TableRow(
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
                            ? AppColors.lightPrimary.withValues(alpha: 0.06)
                            : Colors.white,
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
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.push(
                        AppRoute.productQuote,
                        extra: _left,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Use ${_right.name.split(' ').first}',
                      onPressed: () => context.push(
                        AppRoute.productQuote,
                        extra: _right,
                      ),
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
          color: white ? Colors.white : AppColors.lightTextPrimary,
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

/// Opens compare with [product] pinned left and a default peer on the right.
void openCompareFor(BuildContext context, CatalogProduct product) {
  final peer = ProductMockData.products.firstWhere(
    (p) => p.id != product.id,
    orElse: () => ProductMockData.products.first,
  );
  context.push(AppRoute.productCompare, extra: <CatalogProduct>[product, peer]);
}
