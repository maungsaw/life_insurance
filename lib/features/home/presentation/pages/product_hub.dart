import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

/// Product tab catalog (docs/59). Old stub tiles replaced.
class ProductHubPage extends StatefulWidget {
  const ProductHubPage({super.key, this.guestMode = false});

  final bool guestMode;

  @override
  State<ProductHubPage> createState() => _ProductHubPageState();
}

class _ProductHubPageState extends State<ProductHubPage> {
  ProductLine? _line;

  @override
  Widget build(BuildContext context) {
    final list = ProductMockData.filtered(
      query: '',
      line: _line,
    );
    final grouped = <ProductLine, List<CatalogProduct>>{};
    for (final p in list) {
      grouped.putIfAbsent(p.line, () => []).add(p);
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                  ),
                  if (!widget.guestMode) ...[
                    IconButton(
                      tooltip: 'Saved quotes',
                      onPressed: () => context.push(AppRoute.productQuotes),
                      icon: const Icon(Icons.description_outlined),
                    ),
                    IconButton(
                      tooltip: 'Tracker',
                      onPressed: () => context.push(AppRoute.productTracker),
                      icon: const Icon(Icons.assignment_outlined),
                    ),
                  ],
                  IconButton(
                    tooltip: 'Search',
                    onPressed: () => context.push(AppRoute.productSearch),
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _Chip(
                    label: 'All',
                    selected: _line == null,
                    onTap: () => setState(() => _line = null),
                  ),
                  ...ProductMockData.linesInCatalog.map(
                    (line) => _Chip(
                      label: switch (line) {
                        ProductLine.protection => 'Protection',
                        ProductLine.saving => 'Saving',
                        ProductLine.travel => 'Travel',
                        ProductLine.health => 'Health',
                        ProductLine.bundled => 'Bundled',
                      },
                      selected: _line == line,
                      onTap: () => setState(() => _line = line),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text(
                        'No match',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        AppBottomNavBar.scrollClearance(context),
                      ),
                      children: [
                        for (final entry in grouped.entries) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                            child: Text(
                              entry.value.first.sectionTitle,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface(context),
                              ),
                            ),
                          ),
                          _ProductGrid(
                            products: entry.value,
                            onTap: (p) => context.push(
                              AppRoute.productDetail,
                              extra: p,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? AppColors.lightPrimary
                      : AppColors.onSurfaceSecondary(context),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 28,
                decoration: BoxDecoration(
                  color: selected ? AppColors.lightPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.onTap});

  final List<CatalogProduct> products;
  final ValueChanged<CatalogProduct> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, i) {
        return ProductCatalogCard(
          product: products[i],
          onTap: () => onTap(products[i]),
        );
      },
    );
  }
}
