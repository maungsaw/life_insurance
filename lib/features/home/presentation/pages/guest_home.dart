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
        label: 'Claim',
        icon: Icons.verified_outlined,
        onTap: () => showAuthGate(
          context,
          message: 'Commission and servicing after you sign in.',
        ),
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
      backgroundColor: const Color(0xFFF8FAFC),
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
                  const _PartnerBanner(),
                  const SizedBox(height: 22),
                  const AppSectionHeader(title: 'Our Services'),
                  const SizedBox(height: 12),
                  AppServiceGrid(items: services, crossAxisCount: 4),
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

class _PartnerBanner extends StatelessWidget {
  const _PartnerBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lightPrimary, Color(0xFF00A6FB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To unlock more opportunities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Partner With Us',
                  style: TextStyle(
                    color: Colors.white,
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
                backgroundColor: Colors.white,
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
