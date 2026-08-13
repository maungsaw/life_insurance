import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart'
    show AppBottomNavBar, AppStatusDialog, AppStatusType;
import 'package:life_insurance/features/features.dart'
    show DashboardPage, LeadsPage, TaskBoardPage, ProfilePage, CustomersPage;
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';
import 'package:life_insurance/features/home/presentation/pages/product_hub.dart';

/// App shell — pill bottom nav + center FAB (docs/44).
class LifeInsurancePage extends StatefulWidget {
  const LifeInsurancePage({super.key});

  @override
  State<LifeInsurancePage> createState() => _LifeInsurancePageState();
}

class _LifeInsurancePageState extends State<LifeInsurancePage> {
  late final List<Widget> _pages = [
    const DashboardPage(),
    CustomersPage(),
    const ProductHubPage(),
    const ProfilePage(),
    const LeadsPage(),
    const TaskBoardPage(),
  ];

  int _selectedIndex = PrototypeConfig.tabHome;

  void _goToTab(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() => _selectedIndex = index);
  }

  /// Map stack index → highlighted nav slot (0..3), or -1 if none.
  int get _navHighlight {
    switch (_selectedIndex) {
      case PrototypeConfig.tabHome:
        return 0;
      case PrototypeConfig.tabCustomer:
      case PrototypeConfig.tabLeads:
        return 1;
      case PrototypeConfig.tabProduct:
        return 2;
      case PrototypeConfig.tabProfile:
        return 3;
      case PrototypeConfig.tabTasks:
        return -1;
      default:
        return 0;
    }
  }

  void _onNavTap(int navSlot) {
    switch (navSlot) {
      case 0:
        _goToTab(PrototypeConfig.tabHome);
        break;
      case 1:
        _goToTab(PrototypeConfig.tabCustomer);
        break;
      case 2:
        _goToTab(PrototypeConfig.tabProduct);
        break;
      case 3:
        _goToTab(PrototypeConfig.tabProfile);
        break;
    }
  }

  Future<void> _openFabSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Quick actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: AppColors.lightPrimary,
                  ),
                  title: const Text('New Proposal'),
                  subtitle: const Text('Product → quote stub'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _goToTab(PrototypeConfig.tabProduct);
                    AppStatusDialog.show(
                      context,
                      type: AppStatusType.info,
                      title: 'New Proposal',
                      message:
                          'Opens Product hub — full quote spine later (FR-04).',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: AppColors.lightPrimary,
                  ),
                  title: const Text('New Lead'),
                  subtitle: const Text('Open leads list'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _goToTab(PrototypeConfig.tabLeads);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.task_alt_outlined,
                    color: AppColors.lightPrimary,
                  ),
                  title: const Text('New Task'),
                  subtitle: const Text('Open task board'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _goToTab(PrototypeConfig.tabTasks);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainTabScope(
      selectedIndex: _selectedIndex,
      goToTab: _goToTab,
      openLeads: () => _goToTab(PrototypeConfig.tabLeads),
      openTasks: () => _goToTab(PrototypeConfig.tabTasks),
      openFabSheet: _openFabSheet,
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFFF8FAFC),
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppBottomNavBar(
                selectedIndex: _navHighlight,
                onTap: _onNavTap,
                onFabPressed: _openFabSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
