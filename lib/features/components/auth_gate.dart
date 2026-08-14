import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, GuestQuoteDraft, GuestSession;
import 'package:life_insurance/features/components/app_button.dart';

/// Guest lock — Login / Register / Cancel (docs/74).
Future<void> showAuthGate(
  BuildContext context, {
  String message =
      'Partner tools — quotes, customers, and commission — need your agent login.',
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: 'Login',
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(AppRoute.login);
                },
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Register',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(AppRoute.register);
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Returns true when the guest was blocked (gate shown).
bool gateIfGuest(
  BuildContext context, {
  String message =
      'Partner tools — quotes, customers, and commission — need your agent login.',
}) {
  if (!GuestSession.isGuest) return false;
  showAuthGate(context, message: message);
  return true;
}

/// Guest Get A Quote — PNG Buy maps here (docs/75).
Future<void> showLoginToSaveSheet(
  BuildContext context, {
  required String premiumLabel,
  required String frequency,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Save this estimate',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Premium ($frequency): $premiumLabel MMK',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to save the quote and link a Lead or Client.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: 'Login',
                onPressed: () {
                  Navigator.pop(ctx);
                  GuestQuoteDraft.pendingResume = true;
                  context.push(AppRoute.login);
                },
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Register',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  Navigator.pop(ctx);
                  GuestQuoteDraft.pendingResume = true;
                  context.push(AppRoute.register);
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Keep editing'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
