import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppAssets, AppColors;

enum AppBrandMarkStyle {
  /// Full PNG wordmark (`AppAssets.mainLogo`) — no duplicate title text.
  wordmark,

  /// Icon mark + optional title / subtitle text.
  markAndTitle,
}

/// Splash / Login brand block (LoginRegister wireframe · docs/39).
class AppBrandMark extends StatelessWidget {
  const AppBrandMark({
    super.key,
    this.style = AppBrandMarkStyle.wordmark,
    this.title = 'KBZ LIFE',
    this.subtitle,
    this.logoHeight = 64,
    this.compact = false,
  });

  /// Splash: large centered wordmark.
  const AppBrandMark.splash({super.key})
      : style = AppBrandMarkStyle.wordmark,
        title = 'KBZ LIFE',
        subtitle = null,
        logoHeight = 120,
        compact = false;

  /// Login header: medium wordmark.
  const AppBrandMark.login({super.key})
      : style = AppBrandMarkStyle.wordmark,
        title = 'KBZ LIFE',
        subtitle = null,
        logoHeight = 72,
        compact = true;

  final AppBrandMarkStyle style;
  final String title;
  final String? subtitle;
  final double logoHeight;
  final bool compact;

  String get _asset =>
      style == AppBrandMarkStyle.wordmark ? AppAssets.mainLogo : AppAssets.brandMark;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      _asset,
      height: logoHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.shield_moon_outlined,
        size: logoHeight,
        color: AppColors.lightPrimary,
      ),
    );

    if (style == AppBrandMarkStyle.wordmark) {
      return image;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        image,
        SizedBox(height: compact ? 8 : 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 20 : 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: AppColors.lightPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
