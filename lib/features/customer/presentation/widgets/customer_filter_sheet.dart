import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';

/// Filter sheet — Status + Product chips (docs/51 · Customer.png).
Future<CustomerFilterSelection?> showCustomerFilterSheet(
  BuildContext context, {
  required CustomerFilterSelection initial,
}) {
  return showModalBottomSheet<CustomerFilterSelection>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => CustomerFilterSheet(initial: initial),
  );
}

class CustomerFilterSheet extends StatefulWidget {
  const CustomerFilterSheet({super.key, required this.initial});

  final CustomerFilterSelection initial;

  @override
  State<CustomerFilterSheet> createState() => _CustomerFilterSheetState();
}

class _CustomerFilterSheetState extends State<CustomerFilterSheet> {
  late CrmStatus? _status;
  late ProductCategory? _product;

  @override
  void initState() {
    super.initState();
    _status = widget.initial.status;
    _product = widget.initial.product;
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
                _FilterChip(
                  label: 'All',
                  selected: _status == null,
                  onTap: () => setState(() => _status = null),
                ),
                _FilterChip(
                  label: 'Active',
                  selected: _status == CrmStatus.active,
                  onTap: () => setState(() => _status = CrmStatus.active),
                ),
                _FilterChip(
                  label: 'Expired',
                  selected: _status == CrmStatus.expired,
                  onTap: () => setState(() => _status = CrmStatus.expired),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Product',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _product == null,
                    onTap: () => setState(() => _product = null),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Protection',
                    selected: _product == ProductCategory.protection,
                    onTap: () =>
                        setState(() => _product = ProductCategory.protection),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Saving',
                    selected: _product == ProductCategory.saving,
                    onTap: () =>
                        setState(() => _product = ProductCategory.saving),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Travel',
                    selected: _product == ProductCategory.travel,
                    onTap: () =>
                        setState(() => _product = ProductCategory.travel),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: 'Apply',
                    onPressed: () {
                      Navigator.of(context).pop(
                        CustomerFilterSelection(
                          status: _status,
                          product: _product,
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
                      }),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            AppColors.lightPrimary.withValues(alpha: 0.15),
                        foregroundColor: AppColors.lightPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset',
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
