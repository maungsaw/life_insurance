import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Floating pill bottom nav with center shield FAB seated in the notch (docs/44).
/// FAB is composed inside this widget (not Scaffold.floatingActionButton) so
/// alignment and z-order stay correct on Android gesture / 3-button nav.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.onFabPressed,
  });

  /// Highlight among the four labeled tabs (0..3). Use `-1` for none.
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabPressed;

  static const double barHeight = 64;
  static const double horizontalInset = 16;
  static const double fabSize = 56;
  /// How far the FAB sits above the bar top (into the notch).
  static const double fabOverlap = 22;
  /// Extra paint above the pill so the halo is not clipped (docs/54).
  static const double shadowSpread = 16;

  /// Overlay height (FAB clearance + pill + system inset). docs/57.
  static double overlayHeight(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final bottomPad = math.max(bottom, 12.0);
    final topClearance = fabSize - fabOverlap;
    return topClearance + barHeight + bottomPad;
  }

  /// Bottom spacer so tab content can rest above the floating pill.
  static double scrollClearance(BuildContext context, {double extra = 16}) {
    return overlayHeight(context) + extra;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final bottomPad = math.max(bottom, 12.0);
    final notchRadius = fabSize / 2 + 8;
    // Extra top space so FAB is not clipped by the nav slot.
    final topClearance = fabSize - fabOverlap;

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

    // Transparent host — only the painted pill is opaque (docs/47).
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: topClearance + barHeight + bottomPad,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPad,
              height: barHeight + shadowSpread,
              child: CustomPaint(
                painter: _PillNotchPainter(
                  notchRadius: notchRadius,
                  color: Colors.white,
                  horizontalInset: horizontalInset,
                  topInset: shadowSpread,
                ),
              ),
            ),
            Positioned(
              left: horizontalInset,
              right: horizontalInset,
              bottom: bottomPad,
              height: barHeight,
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i == 2) SizedBox(width: notchRadius * 2 - 4),
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
            Positioned(
              bottom: bottomPad + barHeight - fabOverlap,
              child: _NavCenterFab(onPressed: onFabPressed),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCenterFab extends StatelessWidget {
  const _NavCenterFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: Colors.black38,
      shape: const CircleBorder(),
      color: Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: AppBottomNavBar.fabSize,
          height: AppBottomNavBar.fabSize,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shield_rounded,
                  size: 32,
                  color: AppColors.lightPrimary,
                ),
                const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 15,
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

/// White pill with a circular bite taken from the **top** center for the FAB.
class _PillNotchPainter extends CustomPainter {
  _PillNotchPainter({
    required this.notchRadius,
    required this.color,
    required this.horizontalInset,
    required this.topInset,
  });

  final double notchRadius;
  final Color color;
  final double horizontalInset;
  final double topInset;

  @override
  void paint(Canvas canvas, Size size) {
    final pillHeight = size.height - topInset;
    final pillWidth = size.width - horizontalInset * 2;
    final r = pillHeight / 2;
    final cx = size.width / 2;

    final pill = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(horizontalInset, topInset, pillWidth, pillHeight),
          Radius.circular(r),
        ),
      );

    final notch = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(cx, topInset), radius: notchRadius),
      );

    final path = Path.combine(PathOperation.difference, pill, notch);

    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.12),
      16,
      false,
    );
    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.20),
      8,
      false,
    );
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _PillNotchPainter oldDelegate) =>
      oldDelegate.notchRadius != notchRadius ||
      oldDelegate.color != color ||
      oldDelegate.horizontalInset != horizontalInset ||
      oldDelegate.topInset != topInset;
}
