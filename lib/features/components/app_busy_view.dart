import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Full-screen busy state (e.g. Registration in progress).
class AppBusyView extends StatelessWidget {
  const AppBusyView({
    super.key,
    this.message = 'Please wait…',
    this.detail,
  });

  final String message;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.lightPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface(context),
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceSecondary(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
