import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// OTP verification — prototype timer + local verify (docs/38).
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
    setState(() => _secondsLeft = PrototypeConfig.otpResendSeconds);
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

  Future<void> _verify([String? completed]) async {
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
        resetRemark: widget.args.resetRemark,
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
    await AppStatusDialog.show(
      context,
      type: AppStatusType.success,
      title: 'OTP sent',
      message: 'A new code was sent to ${widget.args.mobile}. (Prototype — any ${PrototypeConfig.otpLength} digits work.)',
      actionLabel: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    final masked = _maskMobile(widget.args.mobile);
    final canResend = _secondsLeft == 0 && !_resending;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: AppAuthShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppBrandMark(logoHeight: 48),
            const SizedBox(height: 24),
            const Text(
              'Enter verification code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'We sent a ${PrototypeConfig.otpLength}-digit code to $masked',
              style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 28),
            AppOtpField(
              length: PrototypeConfig.otpLength,
              onChanged: (v) {
                _code = v;
                if (_error != null) setState(() => _error = null);
              },
              onCompleted: _verify,
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
            const SizedBox(height: 28),
            AppButton(
              label: 'Verify',
              isLoading: _submitting,
              onPressed: _verify,
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
            else if (!canResend)
              Text(
                'Resend code in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
              )
            else
              AppTextLink(
                prefix: "Didn't receive the code? ",
                linkLabel: 'Resend',
                onTap: _resend,
              ),
          ],
        ),
      ),
    );
  }

  String _maskMobile(String mobile) {
    final t = mobile.trim();
    if (t.length < 4) return t;
    return '${t.substring(0, 2)}******${t.substring(t.length - 2)}';
  }
}
