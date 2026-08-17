import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/pages/commission_report_body.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_sub_app_bar.dart';

/// Commission hub — History ledger + Report dashboard (docs/80).
class CommissionHistoryPage extends StatefulWidget {
  const CommissionHistoryPage({super.key, this.initialReport = false});

  final bool initialReport;

  @override
  State<CommissionHistoryPage> createState() => _CommissionHistoryPageState();
}

class _CommissionHistoryPageState extends State<CommissionHistoryPage> {
  late int _tab;
  late CommissionPeriodFilter _period;
  CommissionLine? _line;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialReport ? 1 : 0;
    _period = widget.initialReport
        ? CommissionPeriodFilter.thisMonth
        : CommissionPeriodFilter.all;
  }

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<(CommissionPeriodFilter, CommissionLine?)>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _HistoryFilterSheet(period: _period, line: _line),
    );
    if (result == null || !mounted) return;
    setState(() {
      _period = result.$1;
      _line = result.$2;
    });
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
                  entry.productName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                _kv(ctx, 'Amount', '${entry.amountLabel} MMK'),
                _kv(ctx, 'When', entry.whenLabel),
                _kv(ctx, 'Category', entry.line.label),
                if (entry.clientName != null) _kv(ctx, 'Client', entry.clientName!),
                if (entry.policyRef != null) _kv(ctx, 'Policy', entry.policyRef!),
                const SizedBox(height: 12),
                Text(
                  'Display only · paid via company process outside this app. No withdraw in Phase 1.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.onSurfaceSecondary(context),
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
    final list = CommissionMockData.filtered(_period, line: _line);
    final showReport = _tab == 1;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: const ProfileSubAppBar(title: 'Commission'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: _HubTabs(
              selectedIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          if (showReport)
            Expanded(
              child: CommissionReportBody(
                period: _period,
                onPeriodChanged: (p) => setState(() => _period = p),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: AppCommissionCard(
                amountLabel: CommissionMockData.totalLabel,
                deltaLabel: CommissionMockData.deltaLabel,
                showDetailsChevron: false,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Product commission · display only',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.hint(context),
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
            if (_period != CommissionPeriodFilter.all || _line != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  [
                    if (_period != CommissionPeriodFilter.all)
                      commissionPeriodLabel(_period),
                    if (_line != null) _line!.label,
                  ].join(' · '),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No commission in this period',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceSecondary(context),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              _period = CommissionPeriodFilter.all;
                              _line = null;
                            }),
                            child: const Text('Reset filters'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        indent: 72,
                        color: AppColors.border(context),
                      ),
                      itemBuilder: (context, i) {
                        final e = list[i];
                        return ListTile(
                          onTap: () => _openRow(e),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: e.line.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(e.line.icon, color: e.line.color),
                          ),
                          title: Text(
                            [
                              e.productName,
                              if (e.clientName != null) e.clientName!,
                            ].join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            e.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceSecondary(context),
                            ),
                          ),
                          trailing: Text(
                            e.amountLabel,
                            style: TextStyle(
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
        ],
      ),
    );
  }

  static Widget _kv(BuildContext context, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
            ),
          ),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubTabs extends StatelessWidget {
  const _HubTabs({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.mutedFill(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tab(context, 'History', 0),
          _tab(context, 'Report', 1),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String label, int index) {
    final selected = selectedIndex == index;
    return Expanded(
      child: Material(
        color: selected ? AppColors.lightPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => onChanged(index),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : AppColors.onSurfaceSecondary(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryFilterSheet extends StatefulWidget {
  const _HistoryFilterSheet({required this.period, required this.line});

  final CommissionPeriodFilter period;
  final CommissionLine? line;

  @override
  State<_HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends State<_HistoryFilterSheet> {
  late CommissionPeriodFilter _period;
  late CommissionLine? _line;

  @override
  void initState() {
    super.initState();
    _period = widget.period;
    _line = widget.line;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter history',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              'Period',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in CommissionPeriodFilter.values)
                  ChoiceChip(
                    label: Text(commissionPeriodLabel(p)),
                    selected: _period == p,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _period = p),
                    selectedColor: AppColors.lightPrimary.withValues(alpha: 0.12),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _period == p
                          ? AppColors.lightPrimary
                          : AppColors.onSurfaceSecondary(context),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Product line',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _line == null,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _line = null),
                  selectedColor: AppColors.lightPrimary.withValues(alpha: 0.12),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: _line == null
                        ? AppColors.lightPrimary
                        : AppColors.onSurfaceSecondary(context),
                  ),
                ),
                for (final line in CommissionLine.values)
                  ChoiceChip(
                    label: Text(line.label),
                    selected: _line == line,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _line = line),
                    selectedColor: line.color.withValues(alpha: 0.12),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _line == line
                          ? line.color
                          : AppColors.onSurfaceSecondary(context),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _period = CommissionPeriodFilter.all;
                      _line = null;
                    }),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, (_period, _line)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings → Report still uses this route name; opens the Report tab.
class CommissionReportPage extends StatelessWidget {
  const CommissionReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommissionHistoryPage(initialReport: true);
  }
}
