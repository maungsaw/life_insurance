import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_hub_session.dart';
import 'package:life_insurance/features/customer/presentation/widgets/app_crm_status_pill.dart';
import 'package:life_insurance/features/customer/presentation/widgets/customer_filter_sheet.dart';
import 'package:life_insurance/features/customer/presentation/widgets/lead_filter_sheet.dart';
import 'package:life_insurance/features/lead/data/repository/repository.dart';
import 'package:life_insurance/features/lead/domain/entities/lead.dart';

/// FR-03 CRM hub — two hard-separated, searchable Leads | Clients lists.
class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _leadSearchCtrl = TextEditingController();
  final _clientSearchCtrl = TextEditingController();
  CustomerFilterSelection _clientFilter = CustomerFilterSelection.all;
  String? _leadStage;

  int get _tab => CustomerHubSession.selectedTab.value;
  bool get _showLeads => _tab == 0;

  @override
  void initState() {
    super.initState();
    CustomerHubSession.selectedTab.addListener(_onExternalTabChanged);
  }

  void _onExternalTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    CustomerHubSession.selectedTab.removeListener(_onExternalTabChanged);
    _leadSearchCtrl.dispose();
    _clientSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFilter() async {
    if (_showLeads) {
      final result = await showLeadFilterSheet(context, initial: _leadStage);
      if (result == null || !mounted) return;
      setState(() => _leadStage = result.isEmpty ? null : result);
      return;
    }
    final result = await showCustomerFilterSheet(
      context,
      initial: _clientFilter,
    );
    if (result == null || !mounted) return;
    setState(() => _clientFilter = result);
  }

  void _clearFilters() {
    setState(() {
      if (_showLeads) {
        _leadSearchCtrl.clear();
        _leadStage = null;
      } else {
        _clientSearchCtrl.clear();
        _clientFilter = CustomerFilterSelection.all;
      }
    });
  }

  List<LeadEntity> get _leads {
    final query = _leadSearchCtrl.text.trim().toLowerCase();
    return leadsData.where((lead) {
      final matchesQuery =
          query.isEmpty ||
          lead.name.toLowerCase().contains(query) ||
          lead.phone.toLowerCase().contains(query) ||
          lead.email.toLowerCase().contains(query);
      final matchesStage = _leadStage == null || lead.status == _leadStage;
      return matchesQuery && matchesStage;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final clients = CustomerMockData.filtered(
      query: _clientSearchCtrl.text,
      filter: _clientFilter,
    );
    final leads = _leads;
    final itemCount = _showLeads ? leads.length : clients.length;
    final controller = _showLeads ? _leadSearchCtrl : _clientSearchCtrl;

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Customer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _CrmTabs(
                selectedIndex: _tab,
                leadCount: leadsData.length,
                clientCount: CustomerMockData.customers.length,
                onChanged: (index) {
                  CustomerHubSession.selectedTab.value = index;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: _showLeads
                            ? 'Search leads..'
                            : 'Search clients..',
                        hintStyle: TextStyle(
                          color: AppColors.hint(context),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: AppColors.background(context),
                        suffixIcon: Icon(
                          Icons.search,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.border(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.lightPrimary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.background(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _openFilter,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: AppColors.onSurfaceSecondary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: itemCount == 0
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showLeads
                                ? (_leadStage == null
                                      ? 'No leads'
                                      : 'No leads match this filter')
                                : 'No clients match this filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear search & filters'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        8,
                        8,
                        8,
                        AppBottomNavBar.scrollClearance(context),
                      ),
                      itemCount: itemCount,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: AppColors.border(context),
                        indent: 78,
                      ),
                      itemBuilder: (context, index) {
                        if (_showLeads) {
                          final lead = leads[index];
                          return _LeadRow(
                            lead: lead,
                            onTap: () async {
                              final converted = await context.push<bool>(
                                AppRoute.leadDetail,
                                extra: lead,
                              );
                              if (!context.mounted) return;
                              setState(() {});
                              if (converted == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${lead.name} is now a Client',
                                    ),
                                    action: SnackBarAction(
                                      label: 'View clients',
                                      onPressed: CustomerHubSession.openClients,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
                        final customer = clients[index];
                        return ListTile(
                          onTap: () => context.push(
                            AppRoute.customerDetail,
                            extra: customer,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          leading: AppInitialAvatar(
                            initials: customer.initials,
                          ),
                          title: Text(
                            customer.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface(context),
                            ),
                          ),
                          subtitle: Text(
                            customer.phone,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceSecondary(context),
                            ),
                          ),
                          trailing: AppCrmStatusPill(status: customer.status),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrmTabs extends StatelessWidget {
  const _CrmTabs({
    required this.selectedIndex,
    required this.leadCount,
    required this.clientCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int leadCount;
  final int clientCount;
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
          _tab(context, 'Leads', leadCount, 0),
          _tab(context, 'Clients', clientCount, 1),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String label, int count, int index) {
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
              '$label · $count',
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

class _LeadRow extends StatelessWidget {
  const _LeadRow({required this.lead, required this.onTap});

  final LeadEntity lead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (lead.status) {
      'New' => const Color(0xFF2563EB),
      'Contacted' => const Color(0xFFF59E0B),
      'Quoted' => const Color(0xFF7C3AED),
      'Applied' => AppColors.lightPrimary,
      _ => AppColors.onSurfaceSecondary(context),
    };
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      leading: AppInitialAvatar(initials: lead.initials),
      title: Text(
        lead.name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface(context),
        ),
      ),
      subtitle: Text(
        lead.phone,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.onSurfaceSecondary(context),
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          lead.status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
