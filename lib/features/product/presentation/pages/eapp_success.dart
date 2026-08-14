import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';

class ProductEappSuccessPage extends StatelessWidget {
  const ProductEappSuccessPage({super.key, required this.draft});

  final EappDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            children: [
              const Text(
                '✦  ✦  ✦',
                style: TextStyle(fontSize: 22, color: AppColors.lightPrimary),
              ),
              const SizedBox(height: 16),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 18),
              const Text(
                'Success',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your proposal has been successfully submitted.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.lightTextSecondary, height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                '${draft.appRef ?? draft.id} · Submitted',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'PROPOSAL',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  popToShell(context);
                },
              ),
              const Spacer(),
              Row(
                children: [
                  const _MiniStep(done: true, label: 'Proposal'),
                  _line(true),
                  const _MiniStep(done: false, current: true, label: 'Underwrite'),
                  _line(false),
                  const _MiniStep(done: false, label: 'Payment'),
                  _line(false),
                  const _MiniStep(done: false, label: 'Policy'),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Track underwriting on App tracker — not a live countdown.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.lightTextHint),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'TRACKING',
                      onPressed: () {
                        final router = GoRouter.of(context);
                        popToShell(context);
                        router.push(AppRoute.productTracker);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: () {
                      AppStatusDialog.show(
                        context,
                        type: AppStatusType.info,
                        title: 'Share',
                        message: 'Share stub — prototype, no API.',
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.lightPrimary,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _line(bool on) {
    return Expanded(
      child: Container(
        height: 2,
        color: on ? AppColors.lightPrimary : AppColors.lightBorder,
      ),
    );
  }
}

class _MiniStep extends StatelessWidget {
  const _MiniStep({
    required this.label,
    required this.done,
    this.current = false,
  });

  final String label;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done || current ? AppColors.lightPrimary : Colors.white,
            border: Border.all(color: AppColors.lightPrimary),
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  current ? '2' : '',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
