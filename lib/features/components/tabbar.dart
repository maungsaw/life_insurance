import 'package:flutter/material.dart';

import 'dot_indicator.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final double dotRadius;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.dotRadius = 3.0, // Adjust dot size here
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && widget.onTabChanged != null) {
        widget.onTabChanged!(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),

        // --- CUSTOM DOT INDICATOR CONFIGURATION ---
        indicator: DotIndicator(radius: widget.dotRadius),
        indicatorSize: TabBarIndicatorSize.label,

        // ------------------------------------------
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.only(right: 20.0),
        tabs: widget.tabs.map((title) => Tab(text: title)).toList(),
      ),
    );
  }
}
