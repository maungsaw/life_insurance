import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/customer/presentation/models/customer_hub_session.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/eapp_launch.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductTrackerPage extends StatefulWidget {
  const ProductTrackerPage({super.key});

  @override
  State<ProductTrackerPage> createState() => _ProductTrackerPageState();
}

class _ProductTrackerPageState extends State<ProductTrackerPage> {
  EappStatus? _filter;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final list = ProductSession.applications.where((a) {
      final statusOk = _filter == null || a.status == _filter;
      final textOk =
          q.isEmpty ||
          a.quote.party.name.toLowerCase().contains(q) ||
          a.id.toLowerCase().contains(q) ||
          a.quote.productName.toLowerCase().contains(q);
      return statusOk && textOk;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: const ProductSubAppBar(title: 'App tracker'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search applications',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.background(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _chip(
                  'All',
                  _filter == null,
                  () => setState(() => _filter = null),
                ),
                _chip(
                  'Draft',
                  _filter == EappStatus.draft,
                  () => setState(() => _filter = EappStatus.draft),
                ),
                _chip(
                  'Submitted',
                  _filter == EappStatus.submitted,
                  () => setState(() => _filter = EappStatus.submitted),
                ),
                _chip(
                  'Correction',
                  _filter == EappStatus.correction,
                  () => setState(() => _filter = EappStatus.correction),
                ),
                _chip(
                  'Approved',
                  _filter == EappStatus.approved,
                  () => setState(() => _filter = EappStatus.approved),
                ),
                _chip(
                  'Rejected',
                  _filter == EappStatus.rejected,
                  () => setState(() => _filter = EappStatus.rejected),
                ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text(
                      'No applications yet',
                      style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
                    ),
                  )
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final a = list[i];
                      return ListTile(
                        title: Text(
                          '${a.quote.productName} · ${a.quote.party.name}',
                        ),
                        subtitle: Text(
                          a.isRenewal
                              ? 'Renews ${a.sourcePolicyId} · ${a.statusLabel}'
                              : '${a.id} · ${a.nextHint}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (a.isRenewal) ...[
                              const EappRenewalPill(),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              a.status == EappStatus.draft ||
                                      a.status == EappStatus.correction
                                  ? 'Continue'
                                  : a.statusLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.lightPrimary,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (a.status == EappStatus.draft ||
                              a.status == EappStatus.correction) {
                            context.push(AppRoute.productEapp, extra: a);
                          } else {
                            context.push(
                              AppRoute.productTrackerDetail,
                              extra: a,
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool on, VoidCallback tap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: on,
        onSelected: (_) => tap(),
        selectedColor: AppColors.lightPrimary.withValues(alpha: 0.18),
      ),
    );
  }
}

class ProductTrackerDetailPage extends StatefulWidget {
  const ProductTrackerDetailPage({super.key, required this.draft});

  final EappDraft draft;

  @override
  State<ProductTrackerDetailPage> createState() =>
      _ProductTrackerDetailPageState();
}

class _ProductTrackerDetailPageState extends State<ProductTrackerDetailPage> {
  EappDraft get draft => widget.draft;

  void _markApproved() {
    draft.status = EappStatus.approved;
    if (draft.quote.party.kind == QuotePartyKind.lead) {
      CustomerHubSession.convertLeadFromPartyId(draft.quote.party.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const pipeline = [
      EappStatus.draft,
      EappStatus.submitted,
      EappStatus.correction,
      EappStatus.approved,
      EappStatus.rejected,
    ];
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: const ProductSubAppBar(title: 'Underwriting'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          if (draft.isRenewal) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: EappRenewalPill(),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            '${draft.quote.productName} · ${draft.quote.party.name}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            draft.isRenewal
                ? 'Renews ${draft.sourcePolicyId} · ${draft.appRef ?? draft.id}'
                : '${draft.quote.productName} · ${draft.appRef ?? draft.id}',
            style: TextStyle(color: AppColors.onSurfaceSecondary(context)),
          ),
          const SizedBox(height: 12),
          Text(
            draft.statusLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The proposal is being reviewed during working hours. You will get a notification when the status changes. No fake countdown.',
            style: TextStyle(height: 1.4, color: AppColors.onSurfaceSecondary(context)),
          ),
          const SizedBox(height: 20),
          for (final s in pipeline)
            if (s != EappStatus.correction ||
                draft.status == EappStatus.correction)
              ListTile(
                leading: Icon(
                  _done(draft.status, s)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: _done(draft.status, s)
                      ? AppColors.lightPrimary
                      : AppColors.hint(context),
                ),
                title: Text(_label(s)),
              ),
          if (draft.status == EappStatus.submitted) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _markApproved,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Mark approved',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static bool _done(EappStatus current, EappStatus row) {
    const order = {
      EappStatus.draft: 0,
      EappStatus.submitted: 1,
      EappStatus.correction: 2,
      EappStatus.approved: 3,
      EappStatus.rejected: 3,
    };
    return (order[current] ?? 0) >= (order[row] ?? 0);
  }

  static String _label(EappStatus s) => switch (s) {
    EappStatus.draft => 'Proposal',
    EappStatus.submitted => 'Underwrite',
    EappStatus.correction => 'Correction',
    EappStatus.approved => 'Approved',
    EappStatus.rejected => 'Rejected',
  };
}
