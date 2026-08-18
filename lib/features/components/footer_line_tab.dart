import 'package:flutter/material.dart';

class AppFooterLineTab extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const AppFooterLineTab({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerLow),
      child: Row(
        mainAxisAlignment: .start,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return InkWell(
            onTap: () => onTabSelected(index),
            splashFactory: InkRipple.splashFactory,
            child: Container(
              padding: const .symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? .bold : .w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
