import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';
import 'package:life_insurance/features/dashboard/presentation/widgets/team_visuals.dart';

class TeamMemberTile extends StatelessWidget {
  const TeamMemberTile({super.key, required this.member, required this.onTap});

  final TeamMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.15),
                child: Text(
                  member.initials,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                    Text(
                      member.actualCompact.isEmpty
                          ? member.code
                          : '${member.actualCompact} / ${member.targetCompact}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceSecondary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: member.ringValue,
                        minHeight: 5,
                        color: AppColors.lightPrimary,
                        backgroundColor:
                            AppColors.lightPrimary.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    member.achievementLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TeamMdrtBadge(member: member),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
