import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

enum AppButtonVariant { primary, secondary, text }

/// Full-width CTA used across LoginRegister and the rest of the app.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.height = 50,
    this.icon,
    this.fontSize = 16,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double height;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final labelStyle = TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700);
    final labelChild = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        style: labelStyle,
      ),
    );
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
          )
        : icon == null
            ? labelChild
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Flexible(child: labelChild),
                ],
              );

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: enabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.lightPrimary.withValues(alpha: 0.45),
              elevation: 0,
              padding: padding,
              minimumSize: Size(0, height),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: child,
          ),
        );
      case AppButtonVariant.secondary:
        return SizedBox(
          width: double.infinity,
          height: height,
          child: OutlinedButton(
            onPressed: enabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.lightPrimary,
              side: const BorderSide(color: AppColors.lightPrimary, width: 1.4),
              padding: padding,
              minimumSize: Size(0, height),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.lightPrimary,
                    ),
                  )
                : child,
          ),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: enabled ? onPressed : null,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.lightPrimary,
            ),
          ),
        );
    }
  }
}
