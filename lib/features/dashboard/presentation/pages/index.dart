import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/dashboard/presentation/models/home_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/chart.dart';
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';

/// FA Home — wireframe + FR-02 layout, mock data only (docs/36 · docs/38).
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

  @override
  Widget build(BuildContext context) {
    final services = [
      AppServiceItem(
        label: 'Leads',
        icon: Icons.person_add_alt_1_outlined,
        onTap: () => MainTabScope.maybeOf(context)?.openLeads(),
      ),
      AppServiceItem(
        label: 'Quote',
        icon: Icons.calculate_outlined,
        onTap: () => _goTab(context, PrototypeConfig.tabProduct),
      ),
      AppServiceItem(
        label: 'e-App',
        icon: Icons.description_outlined,
        onTap: () => _goTab(context, PrototypeConfig.tabProduct),
      ),
      AppServiceItem(
        label: 'Customers',
        icon: Icons.policy_outlined,
        onTap: () => _goTab(context, PrototypeConfig.tabCustomer),
      ),
      AppServiceItem(
        label: 'Tasks',
        icon: Icons.task_alt_outlined,
        onTap: () => MainTabScope.maybeOf(context)?.openTasks(),
      ),
      AppServiceItem(
        label: 'Profile',
        icon: Icons.person_outline,
        onTap: () => _goTab(context, PrototypeConfig.tabProfile),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                child: AppHomeHeader(
                  name: HomeMockData.agentName,
                  greeting: HomeMockData.greeting,
                  periodLabel: HomeMockData.periodLabel,
                  initials: HomeMockData.initials,
                  onPeriodTap: () => _stub(
                    context,
                    'Period',
                    'Month / YTD filter will bind to dashboard API later.',
                  ),
                  onNotifTap: () => _stub(
                    context,
                    'Notifications',
                    'Inbox UI (FR-08) — next Flutter prototype pass.',
                  ),
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
                  const SizedBox(height: 20),
                  const AppSectionHeader(title: 'Our services'),
                  const SizedBox(height: 12),
                  AppServiceGrid(items: services),
                  const SizedBox(height: 8),
                  const AppSectionHeader(title: 'This month'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppKpiTile(
                          label: 'New policies',
                          value: HomeMockData.newPolicies,
                          hint: 'vs last month +2',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppKpiTile(
                          label: 'Active',
                          value: HomeMockData.activePolicies,
                          hint: 'In force',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppKpiTile(
                          label: 'FYP',
                          value: HomeMockData.fypPercent,
                          hint: 'of target',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppMdrtBar(
                    percent: HomeMockData.mdrtPercent,
                    subtitle: HomeMockData.mdrtSubtitle,
                  ),
                  const SizedBox(height: 20),
                  AppSoftBanner(
                    title: HomeMockData.dueAlertTitle,
                    subtitle: HomeMockData.dueAlertSubtitle,
                    icon: Icons.notifications_active_outlined,
                    onTap: () => _stub(
                      context,
                      'Premium due',
                      'Due / renewal reminders — prototype stub (FR-08).',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AppSectionHeader(title: 'Performance trend'),
                  const SizedBox(height: 10),
                  const ChartCard(),
                  const SizedBox(height: 20),
                  AppSectionHeader(
                    title: 'News & campaigns',
                    actionLabel: 'See all',
                    onAction: () => _stub(
                      context,
                      'Announcements',
                      'Read-only feed stub (FR-09 / FR-10).',
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppPromoCarousel(
                    items: HomeMockData.promos,
                    onTap: (i) => _stub(
                      context,
                      HomeMockData.promos[i].title,
                      HomeMockData.promos[i].subtitle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSoftBanner(
                    title: 'Team performance',
                    subtitle: 'Personal Team · Total Group · MDRT',
                    onTap: () => _stub(
                      context,
                      'Manager view',
                      'Flutter team hub (docs/32) — next pass. Prototype stub.',
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Clearance for floating pill nav + FAB (docs/44).
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
