import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// One pick language: cyan border + inset corner dot (docs/98).
class AppSelectChip extends StatelessWidget {
  const AppSelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.expand = false,
    this.mutedWhenIdle = false,
    this.outlinedWhenIdle = false,
    this.minHeight,
    this.fontSize = 13,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expand;
  final bool mutedWhenIdle;
  final bool outlinedWhenIdle;
  final double? minHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final idleFill = mutedWhenIdle
        ? AppColors.mutedFill(context)
        : AppColors.surface(context);
    final idleBorder = outlinedWhenIdle
        ? AppColors.border(context)
        : Colors.transparent;
    final borderColor = selected ? AppColors.lightPrimary : idleBorder;
    final borderWidth = selected ? 1.6 : (outlinedWhenIdle ? 1.0 : 0.0);

    final chip = Material(
      color: idleFill,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              width: expand ? double.infinity : null,
              constraints: minHeight == null
                  ? null
                  : BoxConstraints(minHeight: minHeight!),
              alignment: expand ? Alignment.center : null,
              padding: const EdgeInsets.fromLTRB(14, 10, 16, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: borderWidth == 0
                    ? null
                    : Border.all(color: borderColor, width: borderWidth),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: expand ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                  height: 1.2,
                  color: selected
                      ? AppColors.lightPrimary
                      : AppColors.onSurface(context),
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: idleFill,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (expand) return chip;
    return Align(
      alignment: Alignment.centerLeft,
      widthFactor: 1,
      heightFactor: 1,
      child: chip,
    );
  }
}
