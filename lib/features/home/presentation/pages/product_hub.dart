import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:life_insurance/features/components/components.dart';

/// Product tab stub — FR-04 hub later (docs/44).
class ProductHubPage extends StatelessWidget {
  const ProductHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Browse products, run quotes, and start e-App from here.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 28),
              _StubTile(
                icon: Icons.inventory_2_outlined,
                title: 'Product library',
                subtitle: 'FR-04 — coming in next prototype pass',
                onTap: () => AppStatusDialog.show(
                  context,
                  type: AppStatusType.info,
                  title: 'Product library',
                  message: 'Core product catalog stub — no API yet.',
                ),
              ),
              const SizedBox(height: 12),
              _StubTile(
                icon: Icons.calculate_outlined,
                title: 'Premium calculator',
                subtitle: 'Quote spine after login',
                onTap: () => AppStatusDialog.show(
                  context,
                  type: AppStatusType.info,
                  title: 'Calculator',
                  message: 'Premium calculator stub (FR-04).',
                ),
              ),
              const SizedBox(height: 12),
              _StubTile(
                icon: Icons.description_outlined,
                title: 'Start e-App',
                subtitle: 'FR-05 application hub',
                onTap: () => AppStatusDialog.show(
                  context,
                  type: AppStatusType.info,
                  title: 'e-App',
                  message: 'Start e-Application hub stub (FR-05).',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StubTile extends StatelessWidget {
  const _StubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.lightPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.lightTextHint),
            ],
          ),
        ),
      ),
    );
  }
}
