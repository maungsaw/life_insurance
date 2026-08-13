import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Forgot Password — mobile + GET CODE → OTP Verification (docs/43).
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _mobileCtrl = TextEditingController();

  String? _mobileError;
  bool _gettingCode = false;
  bool _codeSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _mobileCtrl.dispose();
    super.dispose();
  }

  String get _mmss {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _mobileNormalized =>
      _mobileCtrl.text.trim().replaceAll(' ', '');

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = PrototypeConfig.otpResendSecondsForgot);
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

  Future<void> _getCode({bool isResend = false}) async {
    setState(() {
      _mobileError =
          _mobileNormalized.isEmpty ? 'Enter your mobile number' : null;
    });
    if (_mobileError != null) return;

    setState(() => _gettingCode = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;
    setState(() {
      _gettingCode = false;
      _codeSent = true;
    });
    _startTimer();

    if (!isResend) {
      context.push(
        AppRoute.otp,
        extra: AuthOtpArgs(
          mobile: _mobileNormalized,
          purpose: AuthOtpPurpose.forgotPassword,
          resetRemark: 'Password reset (forgot)',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _codeSent && _secondsLeft == 0 && !_gettingCode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const SizedBox.shrink(),
        elevation: 0,
      ),
      body: AppAuthShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Enter Your Mobile Number',
              isRequired: true,
              hintText: '09 750337968',
              controller: _mobileCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              errorText: _mobileError,
              onChanged: (_) {
                if (_mobileError != null) setState(() => _mobileError = null);
              },
              onSubmitted: (_) => _getCode(),
            ),
            if (_codeSent) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Don't get a code? ",
                          style: TextStyle(
                            fontSize: 13,
                            color: canResend
                                ? AppColors.lightTextSecondary
                                : AppColors.lightTextHint,
                          ),
                        ),
                        TextButton(
                          onPressed:
                              canResend ? () => _getCode(isResend: true) : null,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.lightPrimary,
                            disabledForegroundColor: AppColors.lightTextHint,
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
                  ),
                  Text(
                    _mmss,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            AppButton(
              label: 'GET CODE',
              isLoading: _gettingCode,
              onPressed: () => _getCode(),
            ),
          ],
        ),
      ),
    );
  }
}
