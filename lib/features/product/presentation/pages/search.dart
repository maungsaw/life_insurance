import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

/// Full-screen product search — blue AppBar + pill field (docs/59 P1).
class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = ProductMockData.filtered(query: _ctrl.text);
    final grouped = <ProductLine, List<CatalogProduct>>{};
    for (final p in list) {
      grouped.putIfAbsent(p.line, () => []).add(p);
    }

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          style: TextStyle(color: AppColors.surface(context), fontWeight: FontWeight.w600),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search products',
            hintStyle: TextStyle(color: AppColors.surface(context).withValues(alpha: 0.7)),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: AppColors.surface(context).withValues(alpha: 0.18),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.surface(context).withValues(alpha: 0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.surface(context).withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.surface(context)),
            ),
          ),
        ),
      ),
      body: list.isEmpty
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                for (final entry in grouped.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
                    child: Text(
                      entry.value.first.sectionTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entry.value.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, i) {
                      final p = entry.value[i];
                      return ProductCatalogCard(
                        product: p,
                        onTap: () => context.push(AppRoute.productDetail, extra: p),
                      );
                    },
                  ),
                ],
              ],
            ),
    );
  }
}
