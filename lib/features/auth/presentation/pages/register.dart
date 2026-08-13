import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Register gate — CORE mobile must exist & be active (FR-01 · docs/34).
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _nameError;
  String? _mobileError;
  bool _checking = false;
  bool _showBusy = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() {
      _nameError = _nameCtrl.text.trim().isEmpty ? 'Enter your full name' : null;
      _mobileError =
          _mobileCtrl.text.trim().isEmpty ? 'Enter mobile number registered in CORE' : null;
    });
    if (_nameError != null || _mobileError != null) return;

    setState(() => _checking = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;

    final mobile = _mobileCtrl.text.trim();
    final coreOk = PrototypeConfig.isCoreMobileOk(mobile);
    setState(() => _checking = false);

    if (!coreOk) {
      await AppStatusDialog.show(
        context,
        type: AppStatusType.warning,
        title: 'Cannot self-register',
        message:
            'This mobile is not active in CORE. Registration must be handled via the backend Application List (FR-01).',
        actionLabel: 'Back to Login',
        onAction: () {
          Navigator.of(context).pop();
          context.go(AppRoute.login);
        },
      );
      return;
    }

    setState(() => _showBusy = true);
    await Future<void>.delayed(PrototypeConfig.mediumDelay);
    if (!mounted) return;
    setState(() => _showBusy = false);

    context.push(
      AppRoute.otp,
      extra: AuthOtpArgs(
        mobile: mobile,
        purpose: AuthOtpPurpose.register,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showBusy) {
      return const Scaffold(
        body: AppBusyView(
          message: 'Registration in progress',
          detail: 'Checking CORE and preparing OTP…',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
            const SizedBox(height: 20),
            const Text(
              'Create agent account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Only agents already active in CORE can continue. Others are directed to backend Application List.',
              style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 22),
            AppTextField(
              label: 'Full name',
              hintText: 'True name as in CORE',
              controller: _nameCtrl,
              prefixIcon: Icons.person_outline,
              errorText: _nameError,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 14),
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
              label: 'Email (optional)',
              hintText: 'name@example.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'Continue',
              isLoading: _checking,
              onPressed: _continue,
            ),
            const SizedBox(height: 16),
            AppTextLink(
              prefix: 'Already registered? ',
              linkLabel: 'Login',
              onTap: () => context.go(AppRoute.login),
            ),
          ],
        ),
      ),
    );
  }
}
