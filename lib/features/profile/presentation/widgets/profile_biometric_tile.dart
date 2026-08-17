import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/core/secure/biometric_prefs.dart';

/// Preference row — switch, not a chevron tile (docs/70).
class ProfileBiometricTile extends StatelessWidget {
  const ProfileBiometricTile({
    super.key,
    required this.value,
    required this.subtitle,
    this.onChanged,
    this.busy = false,
  });

  final bool value;
  final String subtitle;
  final ValueChanged<bool>? onChanged;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final icon = BiometricPrefs.kindLabel == 'Face ID'
        ? Icons.face_rounded
        : Icons.fingerprint_rounded;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.lightPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biometric login',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          if (busy)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          else
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.lightPrimary,
            ),
        ],
      ),
    );
  }
}
