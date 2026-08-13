import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
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

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final mobile = _mobileCtrl.text.trim();
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

    context.go(AppRoute.home);
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
              'Login to your account',
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
              label: 'Login',
              isLoading: _submitting,
              onPressed: _onLogin,
            ),
            const SizedBox(height: 28),
            AppTextLink(
              prefix: "Don't have an account? ",
              linkLabel: 'Register',
              onTap: () => context.push(AppRoute.register),
            ),
          ],
        ),
      ),
    );
  }
}
