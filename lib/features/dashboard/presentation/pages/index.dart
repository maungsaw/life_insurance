import 'package:flutter/material.dart';

import '../widgets/widgets.dart'
    show
        HeaderSection,
        TotalPremiumCard,
        MetricsView,
        ChartCard,
        RecentActivitiesCard;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80.0,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: HeaderSection(),
              ),
            ),
          ),

          // 2. SliverList containing the body cards
          SliverPadding(
            padding: const .symmetric(horizontal: 20.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const TotalPremiumCard(),
                const SizedBox(height: 16),
                const MetricsView(),
                const SizedBox(height: 20),
                const ChartCard(),
                const SizedBox(height: 20),
                const RecentActivitiesCard(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
