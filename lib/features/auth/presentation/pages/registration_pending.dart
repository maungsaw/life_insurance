import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';

/// Terminal pending state — wait for KBZ invitation (docs/43). HOME → Login.
class RegistrationPendingPage extends StatelessWidget {
  const RegistrationPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 44,
                  color: AppColors.lightPrimary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Registration Inprogress',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your registration is in pending stage and please kindly wait invitation from KBZLIFE Insurance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'HOME',
                onPressed: () => context.go(AppRoute.login),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
