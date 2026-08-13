import 'package:flutter/material.dart';
import 'package:life_insurance/features/components/components.dart'
    show AppBottomNavBar;
import 'package:life_insurance/features/features.dart'
    show DashboardPage, LeadsPage, TaskBoardPage, ProfilePage, CustomersPage;
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';

class LifeInsurancePage extends StatefulWidget {
  const LifeInsurancePage({super.key});

  @override
  State<LifeInsurancePage> createState() => _LifeInsurancePageState();
}

class _LifeInsurancePageState extends State<LifeInsurancePage> {
  late final List<Widget> _pages = [
    const DashboardPage(),
    const LeadsPage(),
    CustomersPage(),
    const TaskBoardPage(),
    const ProfilePage(),
  ];

  int _selectedIndex = 0;

  void _goToTab(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MainTabScope(
      selectedIndex: _selectedIndex,
      goToTab: _goToTab,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _goToTab,
        ),
      ),
    );
  }
}
