import 'dart:math' as math;

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
    final stroke = size > 80 ? 10.0 : 7.0;
    final pct = '${(v * 100).round()}%';
    final track = AppColors.isDark(context)
        ? AppColors.mutedFill(context)
        : color.withValues(alpha: 0.14);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TeamRingPainter(
          value: v,
          color: color,
          trackColor: track,
          stroke: stroke,
        ),
        child: Center(
          child: Text(
            label ?? pct,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: size > 80 ? 22 : 14,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamRingPainter extends CustomPainter {
  const _TeamRingPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.stroke,
  });

  final double value;
  final Color color;
  final Color trackColor;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (math.min(size.width, size.height) - stroke) / 2;
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, track);
    if (value <= 0) return;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _TeamRingPainter old) =>
      old.value != value ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.stroke != stroke;
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
    final isDark = AppColors.isDark(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border(context).withValues(
            alpha: isDark ? 0.55 : 0.85,
          ),
        ),
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
              backgroundColor: isDark
                  ? AppColors.mutedFill(context)
                  : AppColors.lightPrimary.withValues(alpha: 0.12),
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
    final isDark = AppColors.isDark(context);
    final (bg, fg, text) = switch (member.badgeKind) {
      TeamBadgeKind.qualified => (
        const Color(0xFFFFF7ED).withValues(alpha: isDark ? 0.18 : 1),
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
        isDark ? AppColors.mutedFill(context) : const Color(0xFFF1F5F9),
        AppColors.onSurfaceSecondary(context),
        'Not Yet',
      ),
      TeamBadgeKind.onTrack => (
        isDark ? AppColors.mutedFill(context) : const Color(0xFFF1F5F9),
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
    final isDark = AppColors.isDark(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border(context).withValues(
            alpha: isDark ? 0.55 : 0.85,
          ),
        ),
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

/// Self-only figures in the FA-detail language (docs/99).
class TeamOwnPerformanceBody extends StatelessWidget {
  const TeamOwnPerformanceBody({super.key, required this.snap});

  final TeamSnapshot snap;

  @override
  Widget build(BuildContext context) {
    final ringColor = snap.ownOverallPct >= 0.9
        ? AppColors.successGreen
        : AppColors.lightPrimary;
    final momUp = snap.ownMomDelta.startsWith('+');
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border(context).withValues(
                alpha: isDark ? 0.55 : 0.85,
              ),
            ),
          ),
          child: Row(
            children: [
              TeamRing(
                value: snap.ownOverallPct,
                color: ringColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievement',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceSecondary(context),
                      ),
                    ),
                    Text(
                      '${snap.ownActualCompact} / ${snap.ownTargetCompact}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'MoM ${snap.ownMomDelta}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: momUp
                            ? AppColors.successGreen
                            : const Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Performance breakdown',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        TeamKpiBar(
          label: 'APE',
          actual: snap.ownApe,
          target: snap.ownApeTarget,
          pct: snap.ownApePct,
        ),
        const SizedBox(height: 8),
        TeamKpiBar(
          label: 'FYP',
          actual: snap.ownFyp,
          target: snap.ownFypTarget,
          pct: snap.ownFypPct,
        ),
        const SizedBox(height: 8),
        TeamKpiBar(
          label: 'Subsequent FYP',
          actual: snap.ownSfyp,
          target: snap.ownSfypTarget,
          pct: snap.ownSfypPct,
        ),
        const SizedBox(height: 8),
        TeamKpiBar(
          label: 'Weighted Freelance FYP',
          actual: snap.ownWtd,
          target: snap.ownWtdTarget,
          pct: snap.ownWtdPct,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: snap.ownMdrtQualified
                ? const Color(0xFFFFF7ED).withValues(alpha: 0.16)
                : AppColors.surface(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border(context).withValues(
                alpha: isDark ? 0.55 : 0.85,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snap.ownMdrtQualified ? 'MDRT Qualified' : 'Road to MDRT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: snap.ownMdrtQualified
                      ? const Color(0xFFB45309)
                      : AppColors.onSurface(context),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(snap.ownMdrtPct * 100).round()}% of target',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: snap.ownMdrtPct.clamp(0.0, 1.0),
                  minHeight: 8,
                  color: snap.ownMdrtQualified
                      ? AppColors.gold
                      : AppColors.lightPrimary,
                  backgroundColor: isDark
                      ? AppColors.mutedFill(context)
                      : AppColors.lightPrimary.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Policies · New ${snap.ownNewPolicies} · Active ${snap.ownActivePolicies}',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceSecondary(context),
          ),
        ),
      ],
    );
  }
}
