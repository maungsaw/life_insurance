import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/widgets/app_crm_status_pill.dart';
import 'package:life_insurance/features/customer/presentation/widgets/policy_list_filter_sheet.dart';
import 'package:life_insurance/features/product/presentation/widgets/eapp_launch.dart';

/// Agent-wide Policy List — search · chart · filter (docs/66 · FR-06).
class PolicyListPage extends StatefulWidget {
  const PolicyListPage({super.key, this.initialStatus});

  final CrmStatus? initialStatus;

  @override
  State<PolicyListPage> createState() => _PolicyListPageState();
}

class _PolicyListPageState extends State<PolicyListPage> {
  late PolicyListFilterSelection _filter;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = PolicyListFilterSelection(status: widget.initialStatus);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<PolicyMock> get _rows => CustomerMockData.filterAgentPolicies(
    query: _search.text,
    filter: _filter,
  );

  Future<void> _openFilter() async {
    final next = await showPolicyListFilterSheet(context, initial: _filter);
    if (next == null) return;
    setState(() => _filter = next);
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Policy List',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      hintStyle: const TextStyle(
                        color: AppColors.lightTextHint,
                      ),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: AppColors.lightTextHint,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _openFilter,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color:
                            _filter.status != null ||
                                _filter.product != null ||
                                _filter.hasDate
                            ? AppColors.lightPrimary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                const _PolicyTrendChart(),
                const SizedBox(height: 14),
                if (rows.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'No policies match',
                        style: TextStyle(color: AppColors.lightTextHint),
                      ),
                    ),
                  )
                else
                  for (final p in rows) ...[
                    _PolicyListTile(
                      policy: p,
                      onTap: () =>
                          context.push(AppRoute.policyDetail, extra: p),
                      onRenew: p.isRenewalEligible
                          ? () => EappLaunch.startRenewalEapp(context, p)
                          : null,
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyTrendChart extends StatelessWidget {
  const _PolicyTrendChart();

  static const _active = Color(0xFF22C55E);
  static const _pending = Color(0xFFF59E0B);
  static const _expired = Color(0xFFF43F5E);

  @override
  Widget build(BuildContext context) {
    final series = CustomerMockData.chartSeries;

    return Container(
      height: 210,
      padding: const EdgeInsets.fromLTRB(12, 14, 16, 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 40,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (v) =>
                        FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 10,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    _area(series, (m) => m.active.toDouble(), _active),
                    _area(series, (m) => m.pending.toDouble(), _pending),
                    _area(series, (m) => m.expired.toDouble(), _expired),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: _active, label: 'Active'),
              SizedBox(width: 14),
              _Legend(color: _pending, label: 'Pending'),
              SizedBox(width: 14),
              _Legend(color: _expired, label: 'Expired'),
            ],
          ),
        ],
      ),
    );
  }

  static LineChartBarData _area(
    List<PolicyChartMonth> series,
    double Function(PolicyChartMonth) y,
    Color color,
  ) {
    return LineChartBarData(
      spots: [
        for (var i = 0; i < series.length; i++)
          FlSpot(i.toDouble(), y(series[i])),
      ],
      isCurved: true,
      color: color,
      barWidth: 2.2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.18),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _PolicyListTile extends StatelessWidget {
  const _PolicyListTile({
    required this.policy,
    required this.onTap,
    this.onRenew,
  });

  final PolicyMock policy;
  final VoidCallback onTap;
  final VoidCallback? onRenew;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEF0F3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      policy.listIcon,
                      color: AppColors.lightPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.id,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          policy.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${policy.clientName} · expires ${policy.expiryLabel}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.lightTextHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppCrmStatusPill(status: policy.status),
                ],
              ),
            ),
            if (onRenew != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onRenew,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AppColors.lightPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(EappLaunch.renewalCta(policy)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
