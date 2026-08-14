import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';

/// Unsigned Profile tab on Guest Home (docs/74).
class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.lightPrimary.withValues(
                        alpha: 0.12,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 36,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You’re not signed in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Log in with your agent account to see profile, commission, and settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppButton(
                      label: 'Login',
                      onPressed: () => context.push(AppRoute.login),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: 'Register',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.push(AppRoute.register),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(height: AppBottomNavBar.scrollClearance(context)),
            ],
          ),
        ),
      ),
    );
  }
}
