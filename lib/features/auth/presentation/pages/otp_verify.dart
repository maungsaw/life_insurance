import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// OTP Verification full screen — wireframe (docs/42).
class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key, required this.args});

  final AuthOtpArgs args;

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String _code = '';
  String? _error;
  bool _submitting = false;
  bool _resending = false;
  late int _secondsLeft;
  Timer? _timer;

  /// Wireframe OTP Verification always shows 06:00 (docs/43).
  int get _resendTotal => PrototypeConfig.otpResendSecondsForgot;

  String get _mmss {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendTotal);
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

  Future<void> _confirm([String? completed]) async {
    final code = completed ?? _code;
    if (code.length != PrototypeConfig.otpLength) {
      setState(() => _error = 'Enter the ${PrototypeConfig.otpLength}-digit OTP');
      return;
    }
    setState(() {
      _error = null;
      _submitting = true;
    });
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    final mode = widget.args.purpose == AuthOtpPurpose.forgotPassword
        ? AuthPasswordMode.update
        : AuthPasswordMode.create;

    context.push(
      AppRoute.createPassword,
      extra: AuthPasswordArgs(
        mobile: widget.args.mobile,
        mode: mode,
        resetRemark: mode == AuthPasswordMode.update
            ? (widget.args.resetRemark ?? 'Password reset (forgot)')
            : widget.args.resetRemark,
      ),
    );
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    await Future<void>.delayed(PrototypeConfig.mediumDelay);
    if (!mounted) return;
    setState(() => _resending = false);
    _startResendCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft == 0 && !_resending;
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
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 28),
            AppOtpField(
              length: PrototypeConfig.otpLength,
              onChanged: (v) {
                _code = v;
                if (_error != null) setState(() => _error = null);
              },
              onCompleted: _confirm,
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _mmss,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'CONFIRM',
              isLoading: _submitting,
              onPressed: _confirm,
            ),
            const SizedBox(height: 16),
            if (_resending)
              const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    onPressed: canResend ? _resend : null,
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
          ],
        ),
      ),
    );
  }
}
