import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig, PrototypeRole;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart'
    show CrmStatus, CustomerMockData;
import 'package:life_insurance/features/dashboard/presentation/models/home_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_pulse_card.dart';
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';
import 'package:life_insurance/features/notification/presentation/models/notification_mock_data.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/profile/presentation/models/commission_mock_data.dart';

/// FA Home — wireframe layout, mock data only (docs/36 · docs/46 · docs/49).
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _stub(BuildContext context, String title, String message) {
    AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: title,
      message: message,
      actionLabel: 'OK',
    );
  }

  void _goTab(BuildContext context, int index) {
    MainTabScope.maybeOf(context)?.goToTab(index);
  }

  void _openNotifications(BuildContext context) {
    context.push(AppRoute.notifications);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PrototypeRole.current,
      builder: (context, _, _) {
        return _buildBody(context);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final services = [
      AppServiceItem(
        label: 'New Proposal',
        icon: Icons.note_add_outlined,
        onTap: () => _goTab(context, PrototypeConfig.tabProduct),
      ),
      AppServiceItem(
        label: 'Product',
        icon: Icons.grid_view_outlined,
        onTap: () => _goTab(context, PrototypeConfig.tabProduct),
      ),
      AppServiceItem(
        label: 'Calculator',
        icon: Icons.calculate_outlined,
        onTap: () => context.push(
          AppRoute.productQuote,
          extra: ProductSession.lastOrDefaultProduct,
        ),
      ),
      AppServiceItem(
        label: 'Commission',
        icon: Icons.account_balance_wallet_outlined,
        onTap: () => context.push(AppRoute.commissionHistory),
      ),
      AppServiceItem(
        label: 'Proposal Status',
        icon: Icons.assignment_outlined,
        onTap: () => context.push(AppRoute.productTracker),
      ),
      AppServiceItem(
        label: 'Task Management',
        icon: Icons.task_alt_outlined,
        onTap: () => MainTabScope.maybeOf(context)?.openTasks(),
      ),
      AppServiceItem(
        label: 'CRM',
        icon: Icons.groups_outlined,
        onTap: () => _goTab(context, PrototypeConfig.tabCustomer),
      ),
      AppServiceItem(
        label: 'Online',
        icon: Icons.language_outlined,
        onTap: () =>
            _stub(context, 'Online', 'Resources / portal stub — later pass.'),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
                child: AppHomeHeader(
                  name: HomeMockData.agentName,
                  greeting: HomeMockData.greeting,
                  roleLabel: PrototypeRole.chipLabel,
                  hasUnread: NotificationMockData.unreadCount > 0,
                  onNotifTap: () => _openNotifications(context),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  AppCommissionCard(
                    amountLabel: CommissionMockData.totalLabel,
                    deltaLabel: CommissionMockData.deltaLabel,
                    onDetails: () => context.push(AppRoute.commissionHistory),
                  ),
                  const SizedBox(height: 14),
                  const AppSectionHeader(title: 'Promotion & Campaign'),
                  const SizedBox(height: 10),
                  AppPromoCarousel(
                    items: HomeMockData.promos,
                    onTap: (i) => _stub(
                      context,
                      HomeMockData.promos[i].title,
                      HomeMockData.promos[i].subtitle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AppSectionHeader(title: 'Our Services'),
                  const SizedBox(height: 12),
                  AppServiceGrid(items: services, crossAxisCount: 4),
                  const SizedBox(height: 8),
                  AppSectionHeader(
                    title: 'Policy',
                    actionLabel: 'See all >',
                    onAction: () => context.push(AppRoute.policyList),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppPolicyStatCard(
                          label: 'Active',
                          value: HomeMockData.policyActive,
                          accent: AppColors.successGreen,
                          icon: Icons.gpp_good_rounded,
                          onTap: () => context.push(
                            AppRoute.policyList,
                            extra: CrmStatus.active,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppPolicyStatCard(
                          label: 'Pending',
                          value: HomeMockData.policyPending,
                          accent: const Color(0xFFF59E0B),
                          icon: Icons.schedule_rounded,
                          onTap: () => context.push(
                            AppRoute.policyList,
                            extra: CrmStatus.pending,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppPolicyStatCard(
                          label: 'Expired',
                          value: HomeMockData.policyExpired,
                          accent: const Color(0xFFE11D48),
                          icon: Icons.cancel_rounded,
                          onTap: () => context.push(
                            AppRoute.policyList,
                            extra: CrmStatus.expired,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppSoftBanner(
                    title: HomeMockData.renewalTitle,
                    subtitle: HomeMockData.renewalBody,
                    icon: Icons.notifications_none_rounded,
                    timeLabel: HomeMockData.renewalTime,
                    onTap: () {
                      final policy = CustomerMockData.firstRenewalPolicy;
                      if (policy == null) return;
                      context.push(AppRoute.policyDetail, extra: policy);
                    },
                  ),
                  if (PrototypeRole.canViewTeam) ...[
                    const SizedBox(height: 16),
                    TeamPulseCard(
                      onOpenTeam: () => context.push(AppRoute.teamHub),
                    ),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(height: AppBottomNavBar.scrollClearance(context)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
