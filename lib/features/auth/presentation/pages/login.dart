import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:life_insurance/core/core.dart'
    show AppRoute, GuestSession, PrototypeConfig;
import 'package:life_insurance/core/secure/biometric_prefs.dart';
import 'package:life_insurance/features/components/components.dart';

/// Login — prototype local auth (docs/38 · LoginRegister.png). No API.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _mobileError;
  String? _passwordError;
  bool _submitting = false;
  bool _unlocking = false;
  bool _bioReady = false;

  @override
  void initState() {
    super.initState();
    _loadBiometrics();
  }

  Future<void> _loadBiometrics() async {
    await BiometricPrefs.load();
    if (!mounted) return;
    setState(() => _bioReady = true);
  }

  bool get _showUnlock =>
      _bioReady &&
      BiometricPrefs.enabled &&
      (BiometricPrefs.hardwareReady || BiometricPrefs.allowPrototypeMock);

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final mobile = PrototypeConfig.normalizeMobile(_mobileCtrl.text);
    final password = _passwordCtrl.text;

    setState(() {
      _mobileError = mobile.isEmpty ? 'Enter agent ID or mobile number' : null;
      _passwordError = password.isEmpty ? 'Enter your password' : null;
    });
    if (_mobileError != null || _passwordError != null) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.shortDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    // Pending invite — never open FA Home (docs/45).
    if (PrototypeConfig.isRegistrationPending(mobile)) {
      context.go(AppRoute.registrationPending);
      return;
    }

    if (PrototypeConfig.isWrongPassword(password)) {
      setState(() => _passwordError = 'Incorrect password');
      await AppStatusDialog.show(
        context,
        type: AppStatusType.warning,
        title: 'Login failed',
        message:
            'Incorrect password. Tip for prototype: any password works except “${PrototypeConfig.wrongPasswordDemo}”.',
        actionLabel: 'Try again',
      );
      return;
    }

    GuestSession.signIn();
    context.go(AppRoute.home);
  }

  Future<void> _onUnlock() async {
    setState(() => _unlocking = true);
    var ok = false;
    if (BiometricPrefs.hardwareReady) {
      ok = await BiometricPrefs.authenticate(
        reason: 'Unlock with ${BiometricPrefs.kindLabel}',
      );
    } else if (BiometricPrefs.allowPrototypeMock) {
      await Future<void>.delayed(PrototypeConfig.shortDelay);
      ok = true;
    }
    if (!mounted) return;
    setState(() => _unlocking = false);
    if (ok) {
      GuestSession.signIn();
      context.go(AppRoute.home);
      return;
    }
    await AppStatusDialog.show(
      context,
      type: AppStatusType.warning,
      title: 'Couldn’t verify',
      message: 'Try again or use password.',
      actionLabel: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppAuthShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 28),
            const AppBrandMark.login(),
            const SizedBox(height: 36),
            const Text(
              'Login Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Use your agent mobile number and password',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Agent ID / Mobile number',
              hintText: '09xxxxxxxxx',
              controller: _mobileCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.phone_android_outlined,
              errorText: _mobileError,
              autofillHints: const [AutofillHints.telephoneNumber],
              onChanged: (_) {
                if (_mobileError != null) setState(() => _mobileError = null);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Password',
              hintText: 'Enter password',
              controller: _passwordCtrl,
              obscureable: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.lock_outline,
              errorText: _passwordError,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _onLogin(),
              onChanged: (_) {
                if (_passwordError != null) setState(() => _passwordError = null);
              },
            ),
            const SizedBox(height: 10),
            AppTextLink(
              linkLabel: 'Forgot Password?',
              align: TextAlign.right,
              onTap: () => context.push(AppRoute.forgotPassword),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'LOGIN',
              isLoading: _submitting,
              onPressed: _unlocking ? null : _onLogin,
            ),
            if (_showUnlock) ...[
              const SizedBox(height: 12),
              AppButton(
                label: BiometricPrefs.unlockCtaLabel,
                variant: AppButtonVariant.secondary,
                icon: BiometricPrefs.kindLabel == 'Face ID'
                    ? Icons.face_rounded
                    : Icons.fingerprint_rounded,
                isLoading: _unlocking,
                onPressed: _submitting ? null : _onUnlock,
              ),
              const SizedBox(height: 6),
              const Text(
                'Use password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
            ],
            const SizedBox(height: 28),
            AppTextLink(
              prefix: 'Not account yet? ',
              linkLabel: 'Register here',
              onTap: () => context.push(AppRoute.register),
            ),
          ],
        ),
      ),
    );
  }
}
