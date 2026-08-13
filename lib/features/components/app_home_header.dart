import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Home top bar — greeting · avatar · period · notifications.
class AppHomeHeader extends StatelessWidget {
  const AppHomeHeader({
    super.key,
    required this.name,
    this.greeting = 'Good day',
    this.periodLabel = 'This month',
    this.initials = 'FA',
    this.onPeriodTap,
    this.onNotifTap,
    this.hasUnread = true,
  });

  final String name;
  final String greeting;
  final String periodLabel;
  final String initials;
  final VoidCallback? onPeriodTap;
  final VoidCallback? onNotifTap;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.lightPrimary,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onPeriodTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  periodLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onNotifTap,
          icon: Badge(
            isLabelVisible: hasUnread,
            smallSize: 8,
            child: const Icon(Icons.notifications_none_rounded, size: 26),
          ),
        ),
      ],
    );
  }
}
