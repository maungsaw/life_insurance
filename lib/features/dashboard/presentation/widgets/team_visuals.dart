import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/dashboard/presentation/models/team_mock_data.dart';

class TeamRing extends StatelessWidget {
  const TeamRing({
    super.key,
    required this.value,
    this.size = 88,
    this.label,
    this.color = AppColors.lightPrimary,
  });

  final double value;
  final double size;
  final String? label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: v,
            strokeWidth: size > 80 ? 8 : 6,
            color: color,
            backgroundColor: color.withValues(alpha: 0.12),
          ),
          Text(
            label ?? '${(v * 100).round()}%',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: size > 80 ? 16 : 13,
              color: AppColors.onSurface(context),
            ),
          ),
        ],
      ),
    );
  }
}

class TeamKpiBar extends StatelessWidget {
  const TeamKpiBar({
    super.key,
    required this.label,
    required this.actual,
    required this.target,
    required this.pct,
    this.pctValue,
  });

  final String label;
  final String actual;
  final String target;
  final String pct;
  final double? pctValue;

  @override
  Widget build(BuildContext context) {
    final v = (pctValue ?? _parsePct(pct)).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
              ),
              Text(
                pct,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            actual,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface(context),
            ),
          ),
          Text(
            'Target $target',
            style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: v,
              minHeight: 6,
              color: AppColors.lightPrimary,
              backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }

  static double _parsePct(String pct) {
    final n = double.tryParse(pct.replaceAll('%', '').trim());
    if (n == null) return 0;
    return n > 1 ? n / 100 : n;
  }
}

class TeamMdrtBadge extends StatelessWidget {
  const TeamMdrtBadge({super.key, required this.member});

  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, text) = switch (member.badgeKind) {
      TeamBadgeKind.qualified => (
        const Color(0xFFFFF7ED),
        const Color(0xFFB45309),
        'MDRT Qualified',
      ),
      TeamBadgeKind.inProgress => (
        AppColors.lightPrimary.withValues(alpha: 0.12),
        AppColors.lightPrimary,
        'MDRT In Progress',
      ),
      TeamBadgeKind.belowTarget => (
        const Color(0xFFF59E0B).withValues(alpha: 0.16),
        const Color(0xFFB45309),
        'Below target',
      ),
      TeamBadgeKind.notYet => (
        const Color(0xFFF1F5F9),
        AppColors.onSurfaceSecondary(context),
        'Not Yet',
      ),
      TeamBadgeKind.onTrack => (
        const Color(0xFFF1F5F9),
        AppColors.onSurfaceSecondary(context),
        'On Track',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class TeamCountChip extends StatelessWidget {
  const TeamCountChip({
    super.key,
    required this.value,
    required this.label,
    this.caption,
    this.icon,
  });

  final String value;
  final String label;
  final String? caption;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(icon, size: 16, color: AppColors.gold)
          else
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.lightPrimary,
              ),
            ),
          if (icon != null) ...[
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.lightPrimary,
              ),
            ),
          ],
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface(context),
            ),
          ),
          if (caption != null)
            Text(
              caption!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: AppColors.hint(context)),
            ),
        ],
      ),
    );
  }
}
