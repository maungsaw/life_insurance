import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Floating pill bottom nav + center FAB notch (docs/44).
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.fabSize = 58,
  });

  /// Highlight among the four labeled tabs (0..3). Use `-1` for none.
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double fabSize;

  static const double barHeight = 64;
  static const double horizontalInset = 16;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final notchRadius = fabSize / 2 + 6;

    final items = <_NavSpec>[
      const _NavSpec(Icons.home_outlined, Icons.home_rounded, 'Home'),
      const _NavSpec(Icons.people_outline, Icons.people, 'Customer'),
      const _NavSpec(
        Icons.grid_view_outlined,
        Icons.grid_view_rounded,
        'Product',
      ),
      const _NavSpec(Icons.person_outline, Icons.person_rounded, 'Profile'),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalInset,
        0,
        horizontalInset,
        math.max(bottom, 10),
      ),
      child: SizedBox(
        height: barHeight,
        child: CustomPaint(
          painter: _PillNotchPainter(
            notchRadius: notchRadius,
            color: Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.12),
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i == 2) SizedBox(width: notchRadius * 2),
                Expanded(
                  child: _NavItem(
                    spec: items[i],
                    selected: selectedIndex == i,
                    onTap: () => onTap(i),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Docks the center FAB into the floating pill notch (docs/44).
class AppPillFabLocation extends FloatingActionButtonLocation {
  const AppPillFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final fabSize = scaffoldGeometry.floatingActionButtonSize;
    final scaffoldSize = scaffoldGeometry.scaffoldSize;
    final bottomPad = math.max(scaffoldGeometry.minInsets.bottom, 10.0);
    final barCenterY =
        scaffoldSize.height - bottomPad - AppBottomNavBar.barHeight / 2;
    final fabY = barCenterY - fabSize.height / 2;
    final fabX = (scaffoldSize.width - fabSize.width) / 2;
    return Offset(fabX, fabY);
  }
}

/// Center-docked shield+ FAB for the pill nav (docs/44).
class AppNavCenterFab extends StatelessWidget {
  const AppNavCenterFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Material(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: const CircleBorder(),
        color: Colors.white,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shield_rounded,
                  size: 34,
                  color: AppColors.lightPrimary,
                ),
                Text(
                  '+',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavSpec {
  const _NavSpec(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _NavSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.lightPrimary : const Color(0xFF2D2D2D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? spec.activeIcon : spec.icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 2),
          Text(
            spec.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillNotchPainter extends CustomPainter {
  _PillNotchPainter({
    required this.notchRadius,
    required this.color,
    required this.shadowColor,
  });

  final double notchRadius;
  final Color color;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.height / 2;
    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(size.width / 2 - notchRadius - 4, 0)
      ..arcToPoint(
        Offset(size.width / 2 + notchRadius + 4, 0),
        radius: Radius.circular(notchRadius + 4),
        clockwise: false,
      )
      ..lineTo(size.width - r, 0)
      ..arcToPoint(
        Offset(size.width - r, size.height),
        radius: Radius.circular(r),
      )
      ..lineTo(r, size.height)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..close();

    canvas.drawShadow(path, shadowColor, 8, true);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _PillNotchPainter oldDelegate) =>
      oldDelegate.notchRadius != notchRadius ||
      oldDelegate.color != color ||
      oldDelegate.shadowColor != shadowColor;
}
