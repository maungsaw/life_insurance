import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/widgets/app_crm_status_pill.dart';

/// Policy Details — accordion sections (docs/51).
class PolicyDetailsPage extends StatefulWidget {
  const PolicyDetailsPage({super.key, required this.policy});

  final PolicyMock policy;

  @override
  State<PolicyDetailsPage> createState() => _PolicyDetailsPageState();
}

class _PolicyDetailsPageState extends State<PolicyDetailsPage> {
  int _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.policy;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Policy Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppStatusDialog.show(
          context,
          type: AppStatusType.info,
          title: 'Policy document',
          message: 'PDF / certificate viewer later — prototype stub.',
          actionLabel: 'OK',
        ),
        backgroundColor: AppColors.lightPrimary,
        child: const Icon(Icons.description_outlined, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          _ExpandCard(
            title: 'Policy Information',
            status: p.status,
            open: _openIndex == 0,
            onToggle: () => setState(() => _openIndex = _openIndex == 0 ? -1 : 0),
            child: Column(
              children: [
                _KvRow(label: 'Product Name', value: p.productName),
                _KvRow(label: 'Sum Insured', value: p.sumInsured),
                _KvRow(label: 'Policy Term', value: p.term),
                _KvRow(label: 'Payment Frequency', value: p.frequency),
                _KvRow(label: 'Premium', value: p.premium),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _ExpandCard(
            title: 'Insured Information',
            open: _openIndex == 1,
            onToggle: () => setState(() => _openIndex = _openIndex == 1 ? -1 : 1),
            child: _PartyRows(info: p.insured),
          ),
          const SizedBox(height: 10),
          _ExpandCard(
            title: 'Policyholder Information',
            open: _openIndex == 2,
            onToggle: () => setState(() => _openIndex = _openIndex == 2 ? -1 : 2),
            child: _PartyRows(info: p.policyholder),
          ),
          const SizedBox(height: 10),
          _ExpandCard(
            title: 'Beneficiary Information',
            open: _openIndex == 3,
            onToggle: () => setState(() => _openIndex = _openIndex == 3 ? -1 : 3),
            child: _PartyRows(info: p.beneficiary),
          ),
        ],
      ),
    );
  }
}

class _ExpandCard extends StatelessWidget {
  const _ExpandCard({
    required this.title,
    required this.open,
    required this.onToggle,
    required this.child,
    this.status,
  });

  final String title;
  final bool open;
  final VoidCallback onToggle;
  final Widget child;
  final CrmStatus? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: AppColors.lightPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  if (status != null) ...[
                    AppCrmStatusPill(status: status!),
                    const SizedBox(width: 6),
                  ],
                  Icon(
                    open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (open) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: child,
            ),
          ],
        ],
      ),
    );
  }
}

class _PartyRows extends StatelessWidget {
  const _PartyRows({required this.info});

  final PolicyPartyInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final e in info.rows.entries)
          _KvRow(label: e.key, value: e.value),
      ],
    );
  }
}

class _KvRow extends StatelessWidget {
  const _KvRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
