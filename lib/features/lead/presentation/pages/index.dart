import 'package:flutter/material.dart';
import 'package:life_insurance/features/components/components.dart'
    show AppFooterLineTab, AppBottomNavBar;

import '../../data/repository/repository.dart' show leadsData;
import 'item.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All', 'New', 'Contacted', 'Qualified'];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFFF4F6FB),
          elevation: 0,
          pinned: true, // Set to false if you want it to scroll away
          title: const Text(
            'Leads',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.add, size: 24), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.search, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, size: 24),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),

        // 2. Top Tabs Row inside a SliverToBoxAdapter
        SliverToBoxAdapter(
          child: AppFooterLineTab(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            onTabSelected: (index) => setState(() => _selectedTabIndex = index),
          ),
        ),

        // 3. Convert ListView.separated to SliverList.separated
        SliverList.separated(
          itemCount: leadsData.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final lead = leadsData[index];
            return LeadItemPage(lead: lead);
          },
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: AppBottomNavBar.scrollClearance(context)),
        ),
      ],
    );
  }
}
