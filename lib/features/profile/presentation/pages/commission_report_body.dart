import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_overview_layout.dart';
import 'package:life_insurance/features/profile/presentation/widgets/commission_overview_chart.dart';

/// Report dashboard body — category bars, top performer, summary (docs/80 · 85).
class CommissionReportBody extends StatelessWidget {
  const CommissionReportBody({
    super.key,
    required this.period,
    required this.onPeriodChanged,
  });

  final CommissionPeriodFilter period;
  final ValueChanged<CommissionPeriodFilter> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final plan = CommissionOverviewLayout.plan(
      CommissionMockData.reportLines(period),
    );
    final top = CommissionMockData.topLine(period);
    final total = CommissionMockData.sumFor(period);
    final count = CommissionMockData.filtered(period).length;
    final last = period == CommissionPeriodFilter.thisMonth
        ? CommissionMockData.sumFor(CommissionPeriodFilter.lastMonth)
        : 0.0;
    final vsPct = last > 0 ? ((total - last) / last * 100).round() : null;
    final vsAmount = last > 0 ? (total - last).abs() : 0.0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commission Report',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Overview of your commission by product category.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _PeriodMenu(period: period, onChanged: onPeriodChanged),
          ],
        ),
        const SizedBox(height: 20),
        const _SectionTitle(
          icon: Icons.bar_chart_rounded,
          label: 'Commission Overview',
        ),
        const SizedBox(height: 14),
        if (plan.mode == CommissionOverviewMode.empty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No commission this period',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceSecondary(context),
                ),
              ),
            ),
          )
        else
          CommissionOverviewChart(plan: plan),
        if (top != null) ...[
          const SizedBox(height: 20),
          _TopCategoryCard(stat: top),
        ],
        const SizedBox(height: 20),
        const _SectionTitle(
          icon: Icons.description_outlined,
          label: 'Summary',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                icon: Icons.payments_outlined,
                label: 'Total commissions',
                value: '$count',
                sub: CommissionFormat.compactMmK(total),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                icon: vsPct != null && vsPct < 0
                    ? Icons.trending_down_rounded
                    : Icons.trending_up_rounded,
                label: 'Vs last month',
                value: vsPct == null ? '—' : '${vsPct >= 0 ? '+' : ''}$vsPct%',
                sub: vsPct == null
                    ? commissionPeriodLabel(period)
                    : CommissionFormat.compactMmK(vsAmount),
                valueColor: vsPct == null
                    ? AppColors.onSurface(context)
                    : (vsPct >= 0
                          ? AppColors.successGreen
                          : const Color(0xFFE11D48)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                icon: Icons.pie_chart_outline_rounded,
                label: 'Categories',
                value: '${CommissionMockData.categoryCount(period)}',
                sub: 'Active lines',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                icon: Icons.policy_outlined,
                label: 'Policies',
                value: '${CommissionMockData.policyCount(period)}',
                sub: 'With credits',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PeriodMenu extends StatelessWidget {
  const _PeriodMenu({required this.period, required this.onChanged});

  final CommissionPeriodFilter period;
  final ValueChanged<CommissionPeriodFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(20),
      child: PopupMenuButton<CommissionPeriodFilter>(
        initialValue: period,
        onSelected: onChanged,
        tooltip: 'Period',
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) => [
          for (final p in CommissionPeriodFilter.values)
            PopupMenuItem(
              value: p,
              child: Text(commissionPeriodLabel(p)),
            ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                commissionPeriodLabel(period),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightPrimary,
                ),
              ),
              const Icon(
                Icons.expand_more,
                size: 18,
                color: AppColors.lightPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.lightPrimary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface(context),
          ),
        ),
      ],
    );
  }
}

class _TopCategoryCard extends StatelessWidget {
  const _TopCategoryCard({required this.stat});

  final CommissionLineStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPrimary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: stat.line.color.withValues(alpha: 0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(stat.line.icon, color: stat.line.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top performing category',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${stat.line.label} Insurance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface(context),
                  ),
                ),
                Text(
                  '${CommissionFormat.compactMmK(stat.amount)} · ${stat.count} commissions',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.trending_up_rounded,
            color: AppColors.lightPrimary,
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.lightPrimary),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.onSurfaceSecondary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.onSurface(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.hint(context),
            ),
          ),
        ],
      ),
    );
  }
}
