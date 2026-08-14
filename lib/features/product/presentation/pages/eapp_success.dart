import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppColors, AppRoute;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/product/presentation/models/product_mock_data.dart';
import 'package:life_insurance/features/product/presentation/widgets/product_widgets.dart';
import 'package:life_insurance/features/product/presentation/widgets/success_confetti.dart';

class ProductEappSuccessPage extends StatefulWidget {
  const ProductEappSuccessPage({super.key, required this.draft});

  final EappDraft draft;

  @override
  State<ProductEappSuccessPage> createState() => _ProductEappSuccessPageState();
}

class _ProductEappSuccessPageState extends State<ProductEappSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entry;
  late final Animation<double> _confetti;
  late final Animation<double> _checkScale;
  late final Animation<double> _checkFade;

  @override
  void initState() {
    super.initState();
    // Longer flight so confetti can fall off-screen; check pops early.
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _confetti = CurvedAnimation(parent: _entry, curve: Curves.linear);
    _checkScale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(
        parent: _entry,
        curve: const Interval(0, 0.18, curve: Curves.easeOutBack),
      ),
    );
    _checkFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entry,
        curve: const Interval(0, 0.12, curve: Curves.easeOut),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _entry.value = 1;
      } else {
        _entry.forward();
      }
    });
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  void _goProposal() => popToShell(context);

  void _goTracking() {
    final router = GoRouter.of(context);
    popToShell(context);
    router.push(AppRoute.productTracker);
  }

  void _share() {
    AppStatusDialog.show(
      context,
      type: AppStatusType.info,
      title: 'Share',
      message: 'Share stub — prototype, no API.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _entry,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: SuccessCornerConfetti(progress: _confetti.value),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 36),
                      FadeTransition(
                        opacity: _checkFade,
                        child: ScaleTransition(
                          scale: _checkScale,
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: AppColors.successGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Success',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your proposal has been successfully submitted.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.lightTextSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${draft.appRef ?? draft.id} · Submitted',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: 'PROPOSAL',
                              variant: AppButtonVariant.secondary,
                              onPressed: _goProposal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              label: 'TRACKING',
                              variant: AppButtonVariant.secondary,
                              onPressed: _goTracking,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const _SuccessStepper(),
                      const SizedBox(height: 10),
                      const Text(
                        'Track underwriting on App tracker — not a live countdown.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.lightTextHint,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton.filled(
                        onPressed: _share,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.lightPrimary,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(48, 48),
                        ),
                        icon: const Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuccessStepper extends StatelessWidget {
  const _SuccessStepper();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MiniStep(done: true, label: 'Proposal'),
        _connector(active: true, dashed: false),
        const _MiniStep(number: 2, current: true, label: 'Underwrite'),
        _connector(active: false, dashed: true),
        const _MiniStep(number: 3, label: 'Payment'),
        _connector(active: false, dashed: false),
        const _MiniStep(number: 4, label: 'Policy'),
      ],
    );
  }

  static Widget _connector({required bool active, required bool dashed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          height: 2,
          child: dashed
              ? CustomPaint(
                  painter: _DashedLinePainter(
                    color: AppColors.lightPrimary.withValues(alpha: 0.45),
                  ),
                )
              : ColoredBox(
                  color: active
                      ? AppColors.lightPrimary
                      : AppColors.lightBorder,
                ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const dash = 4.0;
    const gap = 3.0;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset((x + dash).clamp(0, size.width), y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _MiniStep extends StatelessWidget {
  const _MiniStep({
    required this.label,
    this.done = false,
    this.current = false,
    this.number,
  });

  final String label;
  final bool done;
  final bool current;
  final int? number;

  @override
  Widget build(BuildContext context) {
    final on = done || current;
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? AppColors.lightPrimary : Colors.white,
            border: Border.all(
              color: on
                  ? AppColors.lightPrimary
                  : AppColors.lightPrimary.withValues(alpha: 0.45),
            ),
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  '${number ?? ''}',
                  style: TextStyle(
                    color: on
                        ? Colors.white
                        : AppColors.lightPrimary.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
