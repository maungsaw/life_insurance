import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

/// Full-screen product search — surface AppBar + pill field (docs/59 · 96 · 97).
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
        backgroundColor: AppColors.surface(context),
        foregroundColor: AppColors.onSurface(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        leadingWidth: 64,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
          child: _SearchField(
            controller: _ctrl,
            onChanged: () => setState(() {}),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final pillFill = AppColors.mutedFill(context);
    final iconColor = AppColors.lightPrimary;
    final textColor = AppColors.onSurface(context);
    final hintColor = AppColors.hint(context);
    final radius = BorderRadius.circular(24);
    final restBorder = BorderSide(color: AppColors.border(context));
    final focusBorder = const BorderSide(
      color: AppColors.lightPrimary,
      width: 1.6,
    );

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasQuery = controller.text.isNotEmpty;
        return TextField(
          controller: controller,
          autofocus: true,
          onChanged: (_) => onChanged(),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          cursorColor: iconColor,
          decoration: InputDecoration(
            hintText: 'Search products',
            hintStyle: TextStyle(color: hintColor, fontWeight: FontWeight.w500),
            prefixIcon: Icon(Icons.search, color: iconColor, size: 22),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            suffixIcon: hasQuery
                ? IconButton(
                    tooltip: 'Clear',
                    icon: Icon(Icons.close, color: iconColor, size: 20),
                    onPressed: () {
                      controller.clear();
                      onChanged();
                    },
                  )
                : null,
            isDense: true,
            filled: true,
            fillColor: pillFill,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: restBorder,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: restBorder,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: focusBorder,
            ),
          ),
        );
      },
    );
  }
}
