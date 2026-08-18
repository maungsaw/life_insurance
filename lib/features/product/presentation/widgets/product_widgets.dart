import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart'
    show AppSelectChip;
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';

class ProductSelectChip extends StatelessWidget {
  const ProductSelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.expand = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AppSelectChip(
      label: label,
      selected: selected,
      onTap: onTap,
      expand: expand,
      outlinedWhenIdle: expand,
    );
  }
}

/// Get A Quote · Product Type chip — intrinsic width for [Wrap] (docs/63).
class QuoteTypeChip extends StatelessWidget {
  const QuoteTypeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSelectChip(
      label: label,
      selected: selected,
      onTap: onTap,
      mutedWhenIdle: true,
    );
  }
}

/// Get A Quote · Product Name tile — equal-width cell (docs/63).
class QuoteNameTile extends StatelessWidget {
  const QuoteNameTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSelectChip(
      label: label,
      selected: selected,
      onTap: onTap,
      expand: true,
      minHeight: 48,
    );
  }
}

class QuoteRequiredLabel extends StatelessWidget {
  const QuoteRequiredLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: AppColors.onSurface(context),
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCatalogCard extends StatelessWidget {
  const ProductCatalogCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final CatalogProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  product.icon,
                  color: AppColors.lightPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface(context),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.tagline,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: AppColors.onSurfaceSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductSubAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.surface(context),
      foregroundColor: AppColors.onSurface(context),
      actions: actions,
    );
  }
}

Future<QuoteParty?> showQuotePartySheet(BuildContext context) {
  return showModalBottomSheet<QuoteParty>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => const _PartySheet(),
  );
}

class _PartySheet extends StatefulWidget {
  const _PartySheet();

  @override
  State<_PartySheet> createState() => _PartySheetState();
}

class _PartySheetState extends State<_PartySheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = ProductMockData.parties(query: _ctrl.text);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link to Lead or Client',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ctrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search..',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.background(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border(context)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final p = list[i];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text(p.kindLabel),
                    onTap: () => Navigator.pop(context, p),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void popToShell(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
