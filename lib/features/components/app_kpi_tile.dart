import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Compact Policy KPI (Active / Pending / Expired) — docs/46, icon chip docs/58.
class AppPolicyStatCard extends StatelessWidget {
  const AppPolicyStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.icon = Icons.gpp_good_rounded,
    this.onTap,
  });

  final String label;
  final String value;
  final Color accent;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accent,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashFactory: InkRipple.splashFactory,
        child: card,
      ),
    );
  }
}

// P1 sparkline (docs/55) — not on the icon-count chip (docs/58).
// class _SparklinePainter extends CustomPainter {
//   _SparklinePainter({required this.color});
//
//   final Color color;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 1.6
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//
//     final path = Path()
//       ..moveTo(0, size.height * 0.7)
//       ..quadraticBezierTo(
//         size.width * 0.2,
//         size.height * 0.15,
//         size.width * 0.4,
//         size.height * 0.45,
//       )
//       ..quadraticBezierTo(
//         size.width * 0.65,
//         size.height * 0.9,
//         size.width,
//         size.height * 0.35,
//       );
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
//       oldDelegate.color != color;
// }

class AppKpiTile extends StatelessWidget {
  const AppKpiTile({
    super.key,
    required this.label,
    required this.value,
    this.hint,
  });

  final String label;
  final String value;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: AppColors.onSurfaceSecondary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface(context),
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(
              hint!,
              style: TextStyle(fontSize: 11, color: AppColors.hint(context)),
            ),
          ],
        ],
      ),
    );
  }
}

class AppMdrtBar extends StatelessWidget {
  const AppMdrtBar({
    super.key,
    required this.percent,
    this.title = 'Road to MDRT',
    this.subtitle,
  });

  final double percent;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface(context),
                  ),
                ),
              ),
              Text(
                '${(p * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightPrimary,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceSecondary(context)),
            ),
          ],
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 8,
              backgroundColor: AppColors.border(context),
              color: AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
