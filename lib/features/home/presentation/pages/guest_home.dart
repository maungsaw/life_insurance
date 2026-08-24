import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/dashboard/presentation/models/home_mock_data.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';

/// Before-login Home — Partner banner + teaser services (docs/74).
class GuestHomePage extends StatelessWidget {
  const GuestHomePage({super.key, required this.onOpenProduct});

  final VoidCallback onOpenProduct;

  void _stub(BuildContext context, String title, String message) {
    AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: title,
      message: message,
      actionLabel: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      AppServiceItem(
        label: 'New Proposal',
        icon: Icons.note_add_outlined,
        onTap: () => showAuthGate(
          context,
          message:
              'Partner tools — quotes, customers, and commission — need your agent login.',
        ),
      ),
      AppServiceItem(
        label: 'Product',
        icon: Icons.grid_view_outlined,
        onTap: onOpenProduct,
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
        onTap: () => showAuthGate(context),
      ),
      AppServiceItem(
        label: 'Proposal Status',
        icon: Icons.assignment_outlined,
        onTap: () => showAuthGate(context),
      ),
      AppServiceItem(
        label: 'CRM',
        icon: Icons.groups_outlined,
        onTap: () => showAuthGate(context),
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
                  name: '',
                  guest: true,
                  hasUnread: false,
                  onNotifTap: () => showAuthGate(
                    context,
                    message: 'Sign in to see notifications.',
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ServicesPanel(services: services),
                  const SizedBox(height: 22),
                  const AppSectionHeader(title: 'Promotion & Campaign'),
                  const SizedBox(height: 10),
                  AppPromoCarousel(
                    items: HomeMockData.promos,
                    onTap: (i) {
                      if (i == 0) {
                        showAuthGate(context);
                        return;
                      }
                      _stub(
                        context,
                        HomeMockData.promos[i].title,
                        HomeMockData.promos[i].subtitle,
                      );
                    },
                  ),
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

/// One continuous card: the "Partner With Us" pitch as a gradient header
/// strip, flowing straight into the service icons below — instead of two
/// separate cards with a gap between them (docs/74).
class _ServicesPanel extends StatelessWidget {
  const _ServicesPanel({required this.services});

  final List<AppServiceItem> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PartnerBannerStrip(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSectionHeader(title: 'Our Services'),
                  const SizedBox(height: 12),
                  AppServiceGrid(
                    items: services,
                    crossAxisCount: 4,
                    flat: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerBannerStrip extends StatelessWidget {
  const _PartnerBannerStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lightPrimary, Color(0xFF00A6FB)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To unlock more opportunities',
                  style: TextStyle(
                    color: AppColors.surface(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Partner With Us',
                  style: TextStyle(
                    color: AppColors.surface(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 128),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surface(context),
                foregroundColor: AppColors.lightPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                shape: const StadiumBorder(),
              ),
              onPressed: () => context.push(AppRoute.login),
              child: const Text(
                'Login or Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
