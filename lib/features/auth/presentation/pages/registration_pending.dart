import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';

/// Terminal pending state — wait for KBZ invitation (docs/43 · 45). HOME → Login.
class RegistrationPendingPage extends StatelessWidget {
  const RegistrationPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.lightPrimary,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '···',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightPrimary,
                      letterSpacing: 2,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Registration Inprogress',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Your registration is in pending stage and please kindly wait invitation from KBZLIFE Insurance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 36),
              AppButton(
                label: 'HOME',
                onPressed: () => context.go(AppRoute.login),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
