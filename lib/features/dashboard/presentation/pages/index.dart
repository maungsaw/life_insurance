import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/dashboard/presentation/models/home_mock_data.dart';
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';
import 'package:life_insurance/features/notification/presentation/models/notification_mock_data.dart';

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
        onTap: () => _goTab(context, PrototypeConfig.tabProduct),
      ),
      AppServiceItem(
        label: 'Commission',
        icon: Icons.account_balance_wallet_outlined,
        onTap: () => _stub(
          context,
          'Commission',
          'History list later — display only, no payout (docs/34).',
        ),
      ),
      AppServiceItem(
        label: 'Proposal Status',
        icon: Icons.assignment_outlined,
        onTap: () => _stub(
          context,
          'Proposal Status',
          'Application tracker stub (FR-05).',
        ),
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
        onTap: () => _stub(
          context,
          'Online',
          'Resources / portal stub — later pass.',
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
                child: AppHomeHeader(
                  name: HomeMockData.agentName,
                  greeting: HomeMockData.greeting,
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
                    amountLabel: HomeMockData.commissionAmount,
                    deltaLabel: HomeMockData.commissionDelta,
                    onDetails: () => _stub(
                      context,
                      'Commission',
                      'History list UI later — display only, no payout (docs/34).',
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppGalaxyMemberBanner(
                    onTap: () => _stub(
                      context,
                      'Galaxy Member',
                      'Membership benefits later — prototype stub, no API.',
                    ),
                  ),
                  const SizedBox(height: 22),
                  const AppSectionHeader(title: 'Our Services'),
                  const SizedBox(height: 12),
                  AppServiceGrid(items: services, crossAxisCount: 4),
                  const SizedBox(height: 8),
                  AppSectionHeader(
                    title: 'Policy',
                    actionLabel: 'See all >',
                    onAction: () => _stub(
                      context,
                      'Policies',
                      'Policy list stub (FR-06).',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppPolicyStatCard(
                          label: 'Active',
                          value: HomeMockData.policyActive,
                          accent: AppColors.successGreen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppPolicyStatCard(
                          label: 'Pending',
                          value: HomeMockData.policyPending,
                          accent: const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppPolicyStatCard(
                          label: 'Expired',
                          value: HomeMockData.policyExpired,
                          accent: const Color(0xFFE11D48),
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
                    onTap: () => _openNotifications(context),
                  ),
                  const SizedBox(height: 22),
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
                  const SizedBox(height: 28),
                  const SizedBox(height: 72),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
