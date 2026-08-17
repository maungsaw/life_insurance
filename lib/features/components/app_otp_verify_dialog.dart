import 'dart:async';

import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors, PrototypeConfig;
import 'package:life_insurance/features/components/app_button.dart';
import 'package:life_insurance/features/components/app_otp_field.dart';

/// OTP Verification modal — LoginRegister overlay artboard (docs/41).
/// Not used on the primary auth journey (docs/43 uses full-screen [OtpVerifyPage]).
class AppOtpVerifyDialog extends StatefulWidget {
  const AppOtpVerifyDialog({
    super.key,
    required this.mobileDisplay,
    required this.onConfirmed,
    this.resendSeconds = PrototypeConfig.otpResendSecondsForgot,
  });

  final String mobileDisplay;
  final ValueChanged<String> onConfirmed;
  final int resendSeconds;

  static Future<String?> show(
    BuildContext context, {
    required String mobileDisplay,
    int resendSeconds = PrototypeConfig.otpResendSecondsForgot,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppOtpVerifyDialog(
        mobileDisplay: mobileDisplay,
        resendSeconds: resendSeconds,
        onConfirmed: (code) => Navigator.of(ctx).pop(code),
      ),
    );
  }

  @override
  State<AppOtpVerifyDialog> createState() => _AppOtpVerifyDialogState();
}

class _AppOtpVerifyDialogState extends State<AppOtpVerifyDialog> {
  String _code = '';
  String? _error;
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  String get _mmss {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _confirm() {
    if (_code.length != PrototypeConfig.otpLength) {
      setState(() => _error = 'Enter the ${PrototypeConfig.otpLength}-digit code');
      return;
    }
    widget.onConfirmed(_code);
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft == 0;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'OTP Verification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'Please Enter the code sent to ${widget.mobileDisplay}',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: AppColors.onSurfaceSecondary(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppOtpField(
              length: PrototypeConfig.otpLength,
              onChanged: (v) {
                _code = v;
                if (_error != null) setState(() => _error = null);
              },
              onCompleted: (v) {
                _code = v;
                _confirm();
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _mmss,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceSecondary(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(label: 'CONFIRM', onPressed: _confirm),
            const SizedBox(height: 12),
            if (canResend)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't get a code? ",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceSecondary(context),
                    ),
                  ),
                  TextButton(
                    onPressed: _startTimer,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.lightPrimary,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't get a code? ",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.hint(context),
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      disabledForegroundColor: AppColors.hint(context),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
