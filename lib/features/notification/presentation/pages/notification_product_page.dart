import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/notification/presentation/models/notification_mock_data.dart';

/// Universal Life product info from notification (docs/49 · Notification.png).
class NotificationProductPage extends StatelessWidget {
  const NotificationProductPage({super.key, this.item});

  final NotificationItem? item;

  static const _who = [
    'Individuals aged 16–65 seeking accident protection',
    'Families who want payout certainty',
    'Employers covering staff welfare',
  ];

  static const _why = [
    'Comprehensive Coverage',
    'Peace of Mind',
    'Financial Security',
    'Affordable Premium',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.umbrella_outlined,
                  color: AppColors.lightPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Universal Life',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Protects you with the payouts from 71 category of accidents.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Coverage for accidental death and total permanent disability, with clear benefit categories designed for field agents to explain with confidence.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.family_restroom_rounded,
                  size: 56,
                  color: AppColors.lightPrimary,
                ),
                SizedBox(height: 8),
                Text(
                  'UNIVERSAL LIFE INSURANCE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Who Should Take This Policy?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final line in _who) ...[
            _BulletRow(text: line, icon: Icons.person_outline),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          const Text(
            'Why Should You Buy This Policy?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final line in _why) ...[
            _BulletRow(text: line, icon: Icons.check_circle, filled: true),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.text,
    required this.icon,
    this.filled = false,
  });

  final String text;
  final IconData icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.lightPrimary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
