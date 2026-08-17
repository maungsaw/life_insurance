import 'package:flutter/material.dart';
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/home/presentation/pages/guest_home.dart';
import 'package:life_insurance/features/home/presentation/pages/guest_profile.dart';
import 'package:life_insurance/features/home/presentation/pages/product_hub.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Guest chrome — same pill + FAB as the agent shell (docs/74).
class GuestShellPage extends StatefulWidget {
  const GuestShellPage({super.key});

  @override
  State<GuestShellPage> createState() => _GuestShellPageState();
}

class _GuestShellPageState extends State<GuestShellPage> {
  int _stackIndex = 0;

  int get _navHighlight {
    switch (_stackIndex) {
      case 0:
        return 0;
      case 1:
        return 2;
      case 2:
        return 3;
      default:
        return 0;
    }
  }

  void _goProduct() => setState(() => _stackIndex = 1);

  void _onNavTap(int navSlot) {
    switch (navSlot) {
      case 0:
        setState(() => _stackIndex = 0);
        break;
      case 1:
        showAuthGate(context);
        break;
      case 2:
        _goProduct();
        break;
      case 3:
        setState(() => _stackIndex = 2);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          IndexedStack(
            index: _stackIndex,
            children: [
              GuestHomePage(onOpenProduct: _goProduct),
              const ProductHubPage(guestMode: true),
              const GuestProfilePage(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomNavBar(
              selectedIndex: _navHighlight,
              onTap: _onNavTap,
              onFabPressed: () => showAuthGate(context),
            ),
          ),
        ],
      ),
    );
  }
}
