import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, AppExternalLaunch, ExternalLaunchResult;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';
import 'package:life_insurance/features/customer/presentation/widgets/app_crm_status_pill.dart';
import 'package:life_insurance/features/customer/presentation/widgets/customer_filter_sheet.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/eapp_launch.dart';

/// Customer Details — identity · actions · policies (docs/51).
class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({super.key, required this.customer});

  final CustomerMock customer;

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  late CustomerMock _customer;
  CustomerFilterSelection _policyFilter = CustomerFilterSelection.all;
  bool _launching = false;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

  Future<void> _openPolicyFilter() async {
    final result = await showCustomerFilterSheet(
      context,
      initial: _policyFilter,
    );
    if (result == null || !mounted) return;
    setState(() => _policyFilter = result);
  }

  Future<void> _openProfile() async {
    await context.push(AppRoute.customerProfile, extra: _customer);
    if (mounted) setState(() {});
  }

  Future<void> _phone() async {
    if (_launching) return;
    setState(() => _launching = true);
    final result = await AppExternalLaunch.phone(_customer.phone);
    if (!mounted) return;
    setState(() => _launching = false);
    if (result == ExternalLaunchResult.opened) return;
    await AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: result == ExternalLaunchResult.empty
          ? 'No phone on file'
          : 'Couldn’t open Phone',
      message: result == ExternalLaunchResult.empty
          ? 'This customer has no mobile number.'
          : _customer.phone,
      actionLabel: 'OK',
    );
  }

  Future<void> _email() async {
    if (_launching) return;
    setState(() => _launching = true);
    final result = await AppExternalLaunch.email(_customer.email);
    if (!mounted) return;
    setState(() => _launching = false);
    if (result == ExternalLaunchResult.opened) return;
    await AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: result == ExternalLaunchResult.empty
          ? 'No email on file'
          : 'Couldn’t open Mail',
      message: result == ExternalLaunchResult.empty
          ? 'This customer has no email address.'
          : _customer.email,
      actionLabel: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    final policies = CustomerMockData.filterPolicies(
      _customer.policies,
      _policyFilter,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Customer Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                AppInitialAvatar(initials: _customer.initials, radius: 40),
                const SizedBox(height: 12),
                Text(
                  _customer.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AppCrmStatusPill(status: _customer.status),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionBubble(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      color: const Color(0xFF22C55E),
                      onTap: _phone,
                    ),
                    _ActionBubble(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      color: AppColors.lightPrimary,
                      onTap: _email,
                    ),
                    _ActionBubble(
                      icon: Icons.manage_accounts_outlined,
                      label: 'Profile',
                      color: const Color(0xFFEAB308),
                      onTap: _openProfile,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final hasBook = _customer.policies.any(
                        (p) => p.status != CrmStatus.pending,
                      );
                      EappLaunch.startEappForParty(
                        context,
                        EappLaunch.partyFromCustomer(_customer),
                        intent: hasBook
                            ? EappLaunchIntent.repurchase
                            : EappLaunchIntent.newSale,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Start e-App',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Policies List',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _openPolicyFilter,
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (policies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Text(
                      'No policies match this filter.',
                      style: TextStyle(color: AppColors.lightTextSecondary),
                    ),
                  )
                else
                  for (var i = 0; i < policies.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                        indent: 72,
                      ),
                    _PolicyTile(
                      policy: policies[i],
                      onTap: () => context.push(
                        AppRoute.policyDetail,
                        extra: policies[i],
                      ),
                      onRenew: policies[i].isRenewalEligible
                          ? () => EappLaunch.startRenewalEapp(
                              context,
                              policies[i],
                            )
                          : null,
                    ),
                  ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBubble extends StatelessWidget {
  const _ActionBubble({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.policy, required this.onTap, this.onRenew});

  final PolicyMock policy;
  final VoidCallback onTap;
  final VoidCallback? onRenew;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      isThreeLine: onRenew != null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.lightPrimary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.medical_services_outlined,
          color: AppColors.lightPrimary,
          size: 22,
        ),
      ),
      title: Text(
        policy.id,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        policy.productName,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.lightTextSecondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppCrmStatusPill(status: policy.status),
          if (onRenew != null)
            GestureDetector(
              onTap: onRenew,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  EappLaunch.renewalCta(policy),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
