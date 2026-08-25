import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/pages/compare.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final CatalogProduct product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _tab = 0;

  CatalogProduct get p => widget.product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: ProductSubAppBar(
        title: 'Product Details',
        actions: [
          IconButton(
            tooltip: 'Compare',
            onPressed: () => openCompareFor(context, p),
            icon: const Icon(Icons.compare_arrows_rounded),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Milk-tea / condensed-milk cream two-tone (matches AppColors.lightBackground)
          // — kept as fixed light tones on purpose, independent of dark mode.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF6E9),
              Color(0xFFFDEBCB),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(p.icon, color: AppColors.lightPrimary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.tagline,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () => setState(() => _tab = i),
                        child: Column(
                          children: [
                            Text(
                              const [
                                'About',
                                'Coverage & Benefit',
                                'Eligible',
                              ][i],
                              style: TextStyle(
                                fontWeight: _tab == i
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: _tab == i
                                    ? AppColors.lightPrimary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 3,
                              width: 36,
                              color: _tab == i
                                  ? AppColors.lightPrimary
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.lightBorder),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  if (_tab == 0) ..._about(),
                  if (_tab == 1) ..._coverage(),
                  if (_tab == 2) ..._eligible(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          border: Border(top: BorderSide(color: AppColors.lightBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'GET A QUOTE',
                    variant: AppButtonVariant.secondary,
                    onPressed: () =>
                        context.push(AppRoute.productQuote, extra: p),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'START E-APP',
                    onPressed: () {
                      final draft = ProductSession.startEappForProduct(p);
                      context.push(AppRoute.productEapp, extra: draft);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _about() {
    return [
      Text(
        p.about,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: AppColors.lightTextPrimary,
        ),
      ),
      const SizedBox(height: 22),
      const Text(
        'Who Should Take This Policy?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
        ),
      ),
      const SizedBox(height: 12),
      for (final row in p.whoShould) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(row.icon, color: AppColors.lightSurface, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    row.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
      const SizedBox(height: 8),
      const Text(
        'Why Should You Buy This Policy?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
        ),
      ),
      const SizedBox(height: 12),
      for (final why in p.whyBuy)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: AppColors.lightSurface, size: 14),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  why,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _coverage() {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          p.rateCallout,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.lightPrimary,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Indicative · final premium from the calculator.',
        style: TextStyle(fontSize: 12, color: AppColors.lightTextHint),
      ),
      const SizedBox(height: 16),
      for (final line in p.coverage)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '•  ',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              Expanded(
                child: Text(
                  line,
                  style: const TextStyle(
                    height: 1.35,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _eligible() {
    return [
      for (final line in p.eligible)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: AppColors.lightPrimary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  line,
                  style: const TextStyle(
                    height: 1.35,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
    ];
  }
}
