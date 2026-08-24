import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

class AppServiceItem {
  const AppServiceItem({
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
}

class AppServiceTile extends StatelessWidget {
  const AppServiceTile({super.key, required this.item, this.flat = false});

  final AppServiceItem item;

  /// When true, renders as a tinted icon with no card/shadow of its own —
  /// for use inside a shared group panel (docs/74) instead of standing alone.
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      splashFactory: InkRipple.splashFactory,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: flat
                  ? AppColors.primarySoftTint(context)
                  : AppColors.surface(context),
              borderRadius: BorderRadius.circular(14),
              boxShadow: flat
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(item.icon, color: AppColors.lightPrimary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: AppColors.onSurface(context),
            ),
          ),
        ],
      ),
    );
  }
}

class AppServiceGrid extends StatelessWidget {
  const AppServiceGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 3,
    this.flat = false,
  });

  final List<AppServiceItem> items;
  final int crossAxisCount;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, i) => AppServiceTile(item: items[i], flat: flat),
    );
  }
}
