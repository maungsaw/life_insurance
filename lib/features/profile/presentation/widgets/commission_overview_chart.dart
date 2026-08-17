import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_overview_layout.dart';

/// Category chart that switches density with count (docs/85).
class CommissionOverviewChart extends StatelessWidget {
  const CommissionOverviewChart({super.key, required this.plan});

  final CommissionOverviewPlan plan;

  @override
  Widget build(BuildContext context) {
    return switch (plan.mode) {
      CommissionOverviewMode.empty => const SizedBox.shrink(),
      CommissionOverviewMode.single || CommissionOverviewMode.list =>
        _CategoryList(plan: plan),
      CommissionOverviewMode.few => _FewBars(plan: plan),
      CommissionOverviewMode.scroll => _ScrollBars(plan: plan),
    };
  }
}

class _FewBars extends StatelessWidget {
  const _FewBars({required this.plan});

  final CommissionOverviewPlan plan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('commission-overview-few'),
      height: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final slice in plan.slices)
            Expanded(
              child: _CategoryBar(
                slice: slice,
                maxAmount: plan.maxAmount,
              ),
            ),
        ],
      ),
    );
  }
}

class _ScrollBars extends StatelessWidget {
  const _ScrollBars({required this.plan});

  final CommissionOverviewPlan plan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('commission-overview-scroll'),
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final slice in plan.slices)
              SizedBox(
                width: CommissionOverviewLayout.barMinWidth,
                child: _CategoryBar(
                  slice: slice,
                  maxAmount: plan.maxAmount,
                ),
              ),
            const SizedBox(width: CommissionOverviewLayout.barPeek),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.plan});

  final CommissionOverviewPlan plan;

  @override
  Widget build(BuildContext context) {
    final key = plan.mode == CommissionOverviewMode.single
        ? const Key('commission-overview-single')
        : const Key('commission-overview-list');
    return Column(
      key: key,
      children: [
        for (var i = 0; i < plan.slices.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _CategoryListTile(
            slice: plan.slices[i],
            maxAmount: plan.maxAmount,
          ),
        ],
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.slice, required this.maxAmount});

  final CommissionOverviewSlice slice;
  final double maxAmount;

  @override
  Widget build(BuildContext context) {
    final h = maxAmount <= 0 ? 0.0 : (slice.amount / maxAmount) * 120;
    return Semantics(
      label: slice.semanticsLabel,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              slice.amount <= 0 ? '—' : CommissionFormat.money(slice.amount),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: h.clamp(8, 120),
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    slice.color,
                    slice.color.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${slice.count}',
                style: TextStyle(
                  color: AppColors.surface(context),
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: slice.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(slice.icon, size: 14, color: slice.color),
            ),
            const SizedBox(height: 4),
            Text(
              slice.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  const _CategoryListTile({required this.slice, required this.maxAmount});

  final CommissionOverviewSlice slice;
  final double maxAmount;

  @override
  Widget build(BuildContext context) {
    final frac = maxAmount <= 0 ? 0.0 : (slice.amount / maxAmount).clamp(0.0, 1.0);
    return Semantics(
      label: slice.semanticsLabel,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: slice.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(slice.icon, size: 18, color: slice.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          slice.isOthers
                              ? slice.label
                              : '${slice.label} Insurance',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        CommissionFormat.money(slice.amount),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: SizedBox(
                      height: 8,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(color: AppColors.mutedFill(context)),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: frac,
                            child: ColoredBox(color: slice.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slice.isOthers
                        ? '${slice.count} commissions · ${slice.othersCategoryCount} more categories'
                        : '${slice.count} commissions',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
