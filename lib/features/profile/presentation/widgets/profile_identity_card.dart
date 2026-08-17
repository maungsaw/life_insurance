import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors, PrototypeRole;
import 'package:life_insurance/features/profile/presentation/models/profile_mock_data.dart';

class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.lightPrimary,
            child: Text(
              ProfileMockData.initials,
              style: TextStyle(
                color: AppColors.surface(context),
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProfileMockData.displayName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ProfileMockData.agentCode,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  PrototypeRole.previewTitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
