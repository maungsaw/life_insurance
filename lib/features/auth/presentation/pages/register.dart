import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Register Account — wireframe 5 fields (docs/40 · 45). Prototype · no API.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String? _nameError;
  String? _idError;
  String? _mobileError;
  bool _checking = false;
  bool _showBusy = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _mobileCtrl.dispose();
    _licenseCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _nameError = _nameCtrl.text.trim().isEmpty ? 'Name is required' : null;
      _idError =
          _idCtrl.text.trim().isEmpty ? 'Identification is required' : null;
      _mobileError =
          _mobileCtrl.text.trim().isEmpty ? 'Mobile number is required' : null;
    });
    if (_nameError != null || _idError != null || _mobileError != null) return;

    setState(() => _checking = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;

    final mobile = PrototypeConfig.normalizeMobile(_mobileCtrl.text);
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
          Navigator.of(context).pop(true);
          context.go(AppRoute.login);
        },
      );
      return;
    }

    // Already waiting for KBZ invitation — same pending screen, no OTP.
    if (PrototypeConfig.isRegistrationPending(mobile)) {
      context.go(AppRoute.registrationPending);
      return;
    }

    // Password already created — send to Login.
    if (PrototypeConfig.isRegistrationActive(mobile)) {
      await AppStatusDialog.show(
        context,
        type: AppStatusType.info,
        title: 'Already registered',
        message: 'This mobile already has an account. Please log in.',
        actionLabel: 'Login Now',
        onAction: () {
          Navigator.of(context).pop(true);
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
          message: 'Please wait…',
          detail: 'Checking your details…',
        ),
      );
    }

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
              'Register Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Name',
              isRequired: true,
              hintText: 'May Chan Myae',
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              errorText: _nameError,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Identification',
              isRequired: true,
              hintText: '12/KaMaNa(N)127487',
              controller: _idCtrl,
              textInputAction: TextInputAction.next,
              errorText: _idError,
              onChanged: (_) {
                if (_idError != null) setState(() => _idError = null);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Mobile Number',
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
            AppTextField(
              label: 'License No.',
              hintText: 'LA-IO-09834',
              controller: _licenseCtrl,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email',
              hintText: 'maychan@gmail.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _register(),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'REGISTER',
              isLoading: _checking,
              onPressed: _register,
            ),
            const SizedBox(height: 20),
            const Text(
              'Already have an account?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 4),
            AppTextLink(
              linkLabel: 'Login Now',
              onTap: () => context.go(AppRoute.login),
            ),
          ],
        ),
      ),
    );
  }
}
