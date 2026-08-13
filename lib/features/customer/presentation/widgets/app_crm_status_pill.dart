import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/customer/presentation/models/customer_mock_data.dart';

/// Active / Pending / Expired pill (docs/51).
class AppCrmStatusPill extends StatelessWidget {
  const AppCrmStatusPill({super.key, required this.status});

  final CrmStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      CrmStatus.active => (
          const Color(0xFFDCFCE7),
          const Color(0xFF15803D),
          'Active',
        ),
      CrmStatus.pending => (
          const Color(0xFFFEF3C7),
          const Color(0xFFB45309),
          'Pending',
        ),
      CrmStatus.expired => (
          const Color(0xFFF3F4F6),
          const Color(0xFF6B7280),
          'Expired',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class AppInitialAvatar extends StatelessWidget {
  const AppInitialAvatar({
    super.key,
    required this.initials,
    this.radius = 26,
  });

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightPrimary,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
