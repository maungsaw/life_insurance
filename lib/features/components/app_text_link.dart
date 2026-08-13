import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Inline / footer text + tappable link (Forgot, Register, Resend OTP).
class AppTextLink extends StatelessWidget {
  const AppTextLink({
    super.key,
    required this.linkLabel,
    required this.onTap,
    this.prefix,
    this.align = TextAlign.center,
  });

  final String? prefix;
  final String linkLabel;
  final VoidCallback onTap;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final link = GestureDetector(
      onTap: onTap,
      child: Text(
        linkLabel,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.lightPrimary,
        ),
      ),
    );

    if (prefix == null) {
      return Align(
        alignment: _alignment,
        child: link,
      );
    }

    return Align(
      alignment: _alignment,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            prefix!,
            style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
          ),
          link,
        ],
      ),
    );
  }

  Alignment get _alignment {
    switch (align) {
      case TextAlign.left:
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }
}
