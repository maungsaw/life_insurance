import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/widgets/app_crm_status_pill.dart';
import 'package:life_insurance/features/customer/presentation/widgets/customer_filter_sheet.dart';

/// Customer list tab — search + filter (docs/51 · Customer.png).
class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _searchCtrl = TextEditingController();
  CustomerFilterSelection _filter = CustomerFilterSelection.all;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFilter() async {
    final result = await showCustomerFilterSheet(
      context,
      initial: _filter,
    );
    if (result == null || !mounted) return;
    setState(() => _filter = result);
  }

  void _clearFilters() {
    setState(() {
      _searchCtrl.clear();
      _filter = CustomerFilterSelection.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = CustomerMockData.filtered(
      query: _searchCtrl.text,
      filter: _filter,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Customer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search..',
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextHint,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        suffixIcon: const Icon(
                          Icons.search,
                          color: AppColors.lightTextSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.lightBorder,
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
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _openFilter,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lightBorder),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'No customers',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear filters'),
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
                      itemCount: list.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                        indent: 78,
                      ),
                      itemBuilder: (context, index) {
                        final customer = list[index];
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
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          subtitle: Text(
                            customer.phone,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
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
