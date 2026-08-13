import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Forgot password — mobile + mandatory reset remark (FR-01).
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _mobileCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();
  String? _mobileError;
  String? _remarkError;
  bool _submitting = false;

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _remarkCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _mobileError =
          _mobileCtrl.text.trim().isEmpty ? 'Enter your registered mobile number' : null;
      _remarkError =
          _remarkCtrl.text.trim().isEmpty ? 'Remark / reason is required (FR-01)' : null;
    });
    if (_mobileError != null || _remarkError != null) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    context.push(
      AppRoute.otp,
      extra: AuthOtpArgs(
        mobile: _mobileCtrl.text.trim(),
        purpose: AuthOtpPurpose.forgotPassword,
        resetRemark: _remarkCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
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
              'Reset via SMS OTP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'We will send a 6-digit code to your registered mobile. A remark is required for audit.',
              style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Mobile number',
              hintText: '09xxxxxxxxx',
              controller: _mobileCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_android_outlined,
              errorText: _mobileError,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_mobileError != null) setState(() => _mobileError = null);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Remark / reason *',
              hintText: 'Why are you resetting?',
              controller: _remarkCtrl,
              prefixIcon: Icons.notes_outlined,
              errorText: _remarkError,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_remarkError != null) setState(() => _remarkError = null);
              },
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'Send OTP',
              isLoading: _submitting,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            AppTextLink(
              prefix: 'Remembered it? ',
              linkLabel: 'Back to Login',
              onTap: () => context.go(AppRoute.login),
            ),
          ],
        ),
      ),
    );
  }
}
