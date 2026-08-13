import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        'label': 'More',
      },
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: .6),
      selectedFontSize: 12,
      unselectedFontSize: 10,
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item['icon'] as IconData),
          activeIcon: Icon(item['activeIcon'] as IconData),
          label: item['label'] as String,
        );
      }).toList(),
    );
  }
}
