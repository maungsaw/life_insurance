import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:life_insurance/life_insurance/agent_main.dart';
import 'package:life_insurance/life_insurance/customer_main.dart';
import 'package:life_insurance/life_insurance/lead_main.dart';
import 'package:life_insurance/life_insurance/profile_main.dart';
import 'package:life_insurance/life_insurance/task_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        fontFamily: 'Roboto',
      ),
      home: const LifeInsurance(),
    );
  }
}

class LifeInsurance extends StatefulWidget {
  const LifeInsurance({super.key});

  @override
  State<LifeInsurance> createState() => _LifeInsuranceState();
}

class _LifeInsuranceState extends State<LifeInsurance> {
  final List<Widget> _pages = [
    const DashboardScreen(),
    const LeadsScreen(),
    const CustomersScreen(),
    const TaskBoardScreen(),
    const ProfileScreen(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for floating/glass effect over screen content
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = const Color(0xFF1E3A8A); // Your brand color

    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home_rounded,
        'label': 'Home',
      },
      {
        'icon': Icons.people_outline,
        'activeIcon': Icons.people,
        'label': 'Leads',
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Customers',
      },
      {
        'icon': Icons.check_circle_outline,
        'activeIcon': Icons.check_circle,
        'label': 'Tasks',
      },
      {
        'icon': Icons.menu,
        'activeIcon': Icons.menu_open_sharp,
        'label': 'Profile',
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: .75),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final isSelected = selectedIndex == index;
                  final iconData =
                      (isSelected
                              ? items[index]['activeIcon']
                              : items[index]['icon'])
                          as IconData;
                  final label = items[index]['label'] as String;

                  return InkWell(
                    onTap: () => onTap(index),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? activeColor.withValues(alpha: .12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            color: isSelected
                                ? activeColor
                                : Colors.grey.shade600,
                            size: 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: isSelected ? 12 : 10,
                              color: isSelected
                                  ? activeColor
                                  : Colors.grey.shade600,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
