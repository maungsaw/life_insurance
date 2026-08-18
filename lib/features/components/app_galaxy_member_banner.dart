import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppAssets;

/// Galaxy Member status banner — in-flow under Commission (docs/48).
class AppGalaxyMemberBanner extends StatelessWidget {
  const AppGalaxyMemberBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashFactory: InkRipple.splashFactory,
        child: Ink(
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              AppAssets.galaxyMember,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 96,
              alignment: Alignment.centerLeft,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 96,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: const Color(0xFFE8B923),
                child: const Text(
                  'Galaxy Member',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5C4A12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
