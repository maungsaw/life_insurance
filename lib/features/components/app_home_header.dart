import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppAssets, AppColors;

/// Home top bar — brand mark · welcome · notification bell (docs/46).
class AppHomeHeader extends StatelessWidget {
  const AppHomeHeader({
    super.key,
    required this.name,
    this.greeting = 'Good Morning',
    this.roleLabel,
    this.onNotifTap,
    this.hasUnread = true,
  });

  final String name;
  final String greeting;
  final String? roleLabel;
  final VoidCallback? onNotifTap;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            AppAssets.brandMark,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield_outlined, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome $name! ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightPrimary,
                    height: 1.25,
                  ),
                ),
                TextSpan(
                  text: greeting,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextSecondary,
                    height: 1.25,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (roleLabel != null && roleLabel!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              roleLabel!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
        ],
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
