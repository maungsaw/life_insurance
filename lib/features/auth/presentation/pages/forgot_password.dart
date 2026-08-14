import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Forgot Password — mobile + inline OTP + CONFIRM on one screen (docs/52).
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _mobileCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _otpFocus = FocusNode();

  String? _mobileError;
  String? _otpError;
  bool _gettingCode = false;
  bool _submitting = false;
  bool _codeSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _mobileCtrl.dispose();
    _otpCtrl.dispose();
    _otpFocus.dispose();
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

  Future<void> _getCode() async {
    setState(() {
      _mobileError =
          _mobileNormalized.isEmpty ? 'Enter your mobile number' : null;
      _otpError = null;
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
    _otpFocus.requestFocus();
  }

  Future<void> _confirm() async {
    final code = _otpCtrl.text.trim();
    setState(() {
      _mobileError =
          _mobileNormalized.isEmpty ? 'Enter your mobile number' : null;
      if (!_codeSent) {
        _otpError = 'Get a code first';
      } else if (code.length != PrototypeConfig.otpLength) {
        _otpError = 'Enter the ${PrototypeConfig.otpLength}-digit OTP';
      } else {
        _otpError = null;
      }
    });
    if (_mobileError != null || _otpError != null) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    context.push(
      AppRoute.createPassword,
      extra: AuthPasswordArgs(
        mobile: _mobileNormalized,
        mode: AuthPasswordMode.update,
        resetRemark: 'Password reset (forgot)',
      ),
    );
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
              textInputAction: TextInputAction.next,
              errorText: _mobileError,
              onChanged: (_) {
                if (_mobileError != null) setState(() => _mobileError = null);
              },
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'OTP Code',
                    isRequired: true,
                    hintText: 'Enter OTP',
                    controller: _otpCtrl,
                    focusNode: _otpFocus,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLength: PrototypeConfig.otpLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    errorText: _otpError,
                    onChanged: (_) {
                      if (_otpError != null) setState(() => _otpError = null);
                    },
                    onSubmitted: (_) => _confirm(),
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 29),
                  child: SizedBox(
                    width: 128,
                    child: AppButton(
                      label: 'GET CODE',
                      height: 50,
                      fontSize: 13,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      isLoading: _gettingCode,
                      onPressed: _getCode,
                    ),
                  ),
                ),
              ],
            ),
            if (_codeSent) ...[
              const SizedBox(height: 10),
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
                          onPressed: canResend ? _getCode : null,
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
              label: 'CONFIRM',
              isLoading: _submitting,
              onPressed: _confirm,
            ),
          ],
        ),
      ),
    );
  }
}
