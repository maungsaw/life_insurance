import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/app_button.dart';

enum AppStatusType { success, warning, info }

/// Centered status modal (Success / Warning / Info) from LoginRegister.
/// Returns `true` on primary (YES/OK), `false` on secondary (NO).
class AppStatusDialog extends StatelessWidget {
  const AppStatusDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel = 'OK',
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final AppStatusType type;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// Shows dialog. `true` = primary tapped, `false` = secondary, `null` = dismissed.
  static Future<bool?> show(
    BuildContext context, {
    required AppStatusType type,
    required String title,
    required String message,
    String actionLabel = 'OK',
    VoidCallback? onAction,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppStatusDialog(
        type: type,
        title: title,
        message: message,
        actionLabel: actionLabel,
        secondaryLabel: secondaryLabel,
        onAction: onAction ?? () => Navigator.of(ctx).pop(true),
        onSecondary: onSecondary ??
            (secondaryLabel != null
                ? () => Navigator.of(ctx).pop(false)
                : null),
      ),
    );
  }

  (IconData, Color) get _visual {
    switch (type) {
      case AppStatusType.success:
        return (Icons.check_circle_rounded, AppColors.successGreen);
      case AppStatusType.warning:
        return (Icons.warning_amber_rounded, const Color(0xFFF59E0B));
      case AppStatusType.info:
        return (Icons.chat_bubble_outline_rounded, AppColors.lightPrimary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _visual;
    final hasSecondary = secondaryLabel != null && secondaryLabel!.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: color),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.onSurfaceSecondary(context),
              ),
            ),
            const SizedBox(height: 22),
            if (hasSecondary)
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: secondaryLabel!,
                      variant: AppButtonVariant.secondary,
                      onPressed: onSecondary ??
                          () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: actionLabel,
                      onPressed:
                          onAction ?? () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              )
            else
              AppButton(
                label: actionLabel,
                onPressed: onAction ?? () => Navigator.of(context).pop(true),
              ),
          ],
        ),
      ),
    );
  }
}
