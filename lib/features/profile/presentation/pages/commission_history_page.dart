import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_sub_app_bar.dart';

/// Commission history — display only (docs/61 · Comission.png).
class CommissionHistoryPage extends StatefulWidget {
  const CommissionHistoryPage({super.key});

  @override
  State<CommissionHistoryPage> createState() => _CommissionHistoryPageState();
}

class _CommissionHistoryPageState extends State<CommissionHistoryPage> {
  CommissionPeriodFilter _period = CommissionPeriodFilter.all;

  Future<void> _openFilter() async {
    final picked = await showModalBottomSheet<CommissionPeriodFilter>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Filter history',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                for (final p in CommissionPeriodFilter.values)
                  ListTile(
                    title: Text(_periodLabel(p)),
                    trailing: _period == p
                        ? const Icon(Icons.check, color: AppColors.lightPrimary)
                        : null,
                    onTap: () => Navigator.pop(ctx, p),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => _period = picked);
  }

  void _openRow(CommissionEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                _kv('Amount', '${entry.amountLabel} MMK'),
                _kv('When', entry.whenLabel),
                if (entry.productName != null)
                  _kv('Product', entry.productName!),
                if (entry.policyRef != null) _kv('Ref', entry.policyRef!),
                const SizedBox(height: 12),
                const Text(
                  'Display only · paid via company process outside this app. No withdraw in Phase 1.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'OK',
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = CommissionMockData.filtered(_period);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileSubAppBar(title: 'Commission'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoute.profileReport),
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        tooltip: 'Report',
        child: const Icon(Icons.bar_chart_rounded),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: AppCommissionCard(
              amountLabel: CommissionMockData.totalLabel,
              deltaLabel: CommissionMockData.deltaLabel,
              showDetailsChevron: false,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Product commission · display only',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.lightTextHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Filter',
                  onPressed: _openFilter,
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
          ),
          if (_period != CommissionPeriodFilter.all)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                _periodLabel(_period),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightPrimary,
                ),
              ),
            ),
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text(
                      'No commission history yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 88),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      indent: 72,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, i) {
                      final e = list[i];
                      return ListTile(
                        onTap: () => _openRow(e),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.monetization_on_outlined,
                            color: AppColors.lightPrimary,
                          ),
                        ),
                        title: Text(
                          e.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          e.whenLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        trailing: Text(
                          e.amountLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightPrimary,
                            fontSize: 15,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static String _periodLabel(CommissionPeriodFilter p) => switch (p) {
        CommissionPeriodFilter.all => 'All',
        CommissionPeriodFilter.thisMonth => 'This month',
        CommissionPeriodFilter.lastMonth => 'Last month',
        CommissionPeriodFilter.last90 => 'Last 90 days',
      };

  static Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(color: AppColors.lightTextSecondary),
            ),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
