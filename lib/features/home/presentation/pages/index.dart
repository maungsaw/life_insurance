import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, GuestQuoteDraft, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart'
    show AppBottomNavBar;
import 'package:life_insurance/features/features.dart'
    show DashboardPage, LeadsPage, TaskBoardPage, ProfilePage, CustomersPage;
import 'package:life_insurance/features/home/presentation/main_tab_scope.dart';
import 'package:life_insurance/features/home/presentation/pages/product_hub.dart';
import 'package:life_insurance/features/customer/presentation/models/customer_hub_session.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart'
    show ProductSession;
import 'package:life_insurance/features/task/presentation/pages/index.dart'
    show TaskFormArgs;

/// App shell — pill bottom nav + center FAB (docs/44).
class LifeInsurancePage extends StatefulWidget {
  const LifeInsurancePage({super.key});

  @override
  State<LifeInsurancePage> createState() => _LifeInsurancePageState();
}

class _LifeInsurancePageState extends State<LifeInsurancePage> {
  late final List<Widget> _pages = [
    const DashboardPage(),
    const CustomersPage(),
    const ProductHubPage(),
    const ProfilePage(),
    const LeadsPage(),
    const TaskBoardPage(),
  ];

  int _selectedIndex = PrototypeConfig.tabHome;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resumeGuestQuote());
  }

  void _resumeGuestQuote() {
    if (!mounted || !GuestQuoteDraft.pendingResume) return;
    GuestQuoteDraft.pendingResume = false;
    final product =
        ProductSession.byProductId(GuestQuoteDraft.current?.productId) ??
        ProductSession.lastOrDefaultProduct;
    context.push(AppRoute.productQuote, extra: product);
  }

  void _goToTab(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() => _selectedIndex = index);
  }

  void _openLeads() {
    CustomerHubSession.openLeads();
    _goToTab(PrototypeConfig.tabCustomer);
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: AppColors.lightPrimary,
                  ),
                  title: const Text('New Proposal'),
                  subtitle: const Text('Open Product catalog'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _goToTab(PrototypeConfig.tabProduct);
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
                    _openLeads();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.task_alt_outlined,
                    color: AppColors.lightPrimary,
                  ),
                  title: const Text('New Task'),
                  subtitle: const Text('Create a task'),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(
                      AppRoute.taskForm,
                      extra: const TaskFormArgs(),
                    );
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
      openLeads: _openLeads,
      openTasks: () => _goToTab(PrototypeConfig.tabTasks),
      openFabSheet: _openFabSheet,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.background(context),
        body: Stack(
          children: [
            IndexedStack(index: _selectedIndex, children: _pages),
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
