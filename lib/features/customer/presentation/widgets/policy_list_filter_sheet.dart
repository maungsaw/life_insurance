import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';

/// Policy List filter — Product · Status · Date range (docs/66 · Policy.png).
Future<PolicyListFilterSelection?> showPolicyListFilterSheet(
  BuildContext context, {
  required PolicyListFilterSelection initial,
}) {
  return showModalBottomSheet<PolicyListFilterSelection>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => PolicyListFilterSheet(initial: initial),
  );
}

class PolicyListFilterSheet extends StatefulWidget {
  const PolicyListFilterSheet({super.key, required this.initial});

  final PolicyListFilterSelection initial;

  @override
  State<PolicyListFilterSheet> createState() => _PolicyListFilterSheetState();
}

class _PolicyListFilterSheetState extends State<PolicyListFilterSheet> {
  late CrmStatus? _status;
  late ProductCategory? _product;
  late DateTime? _from;
  late DateTime? _to;
  late final TextEditingController _rangeCtrl;

  @override
  void initState() {
    super.initState();
    _status = widget.initial.status;
    _product = widget.initial.product;
    _from = widget.initial.dateFrom;
    _to = widget.initial.dateTo;
    _rangeCtrl = TextEditingController(text: PolicyFormat.range(_from, _to));
  }

  @override
  void dispose() {
    _rangeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final now = DateTime(2026, 8, 14);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _from != null && _to != null
          ? DateTimeRange(start: _from!, end: _to!)
          : DateTimeRange(
              start: DateTime(2025, 1, 1),
              end: now,
            ),
    );
    if (range == null) return;
    setState(() {
      _from = range.start;
      _to = range.end;
      _rangeCtrl.text = PolicyFormat.range(_from, _to);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface(context),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Product',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Chip(
                  label: 'All',
                  selected: _product == null,
                  onTap: () => setState(() => _product = null),
                ),
                _Chip(
                  label: 'Protection',
                  selected: _product == ProductCategory.protection,
                  onTap: () =>
                      setState(() => _product = ProductCategory.protection),
                ),
                _Chip(
                  label: 'Saving',
                  selected: _product == ProductCategory.saving,
                  onTap: () =>
                      setState(() => _product = ProductCategory.saving),
                ),
                _Chip(
                  label: 'Travel',
                  selected: _product == ProductCategory.travel,
                  onTap: () =>
                      setState(() => _product = ProductCategory.travel),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Chip(
                  label: 'All',
                  selected: _status == null,
                  onTap: () => setState(() => _status = null),
                ),
                _Chip(
                  label: 'Active',
                  selected: _status == CrmStatus.active,
                  onTap: () => setState(() => _status = CrmStatus.active),
                ),
                _Chip(
                  label: 'Pending',
                  selected: _status == CrmStatus.pending,
                  onTap: () => setState(() => _status = CrmStatus.pending),
                ),
                _Chip(
                  label: 'Expired',
                  selected: _status == CrmStatus.expired,
                  onTap: () => setState(() => _status = CrmStatus.expired),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Date Range',
              isRequired: true,
              controller: _rangeCtrl,
              readOnly: true,
              hintText: 'Select range',
              onTap: _pickRange,
              suffix: IconButton(
                onPressed: _pickRange,
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: 'APPLY',
                    onPressed: () {
                      Navigator.of(context).pop(
                        PolicyListFilterSelection(
                          status: _status,
                          product: _product,
                          dateFrom: _from,
                          dateTo: _to,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: () => setState(() {
                        _status = null;
                        _product = null;
                        _from = null;
                        _to = null;
                        _rangeCtrl.clear();
                      }),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            AppColors.lightPrimary.withValues(alpha: 0.15),
                        foregroundColor: AppColors.lightPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text(
                        'RESET',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
    return Material(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? AppColors.lightPrimary
                      : AppColors.border(context),
                  width: 1.4,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.lightPrimary
                      : AppColors.onSurface(context),
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: -5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
