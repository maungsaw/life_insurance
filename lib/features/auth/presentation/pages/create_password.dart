import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Create / Update password with live wireframe rules checklist.
class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key, required this.args});

  final AuthPasswordArgs args;

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _password = '';
  String? _passwordError;
  String? _confirmError;
  bool _submitting = false;

  bool get _isUpdate => widget.args.mode == AuthPasswordMode.update;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final match = _passwordCtrl.text == _confirmCtrl.text;
    final rulesOk = PasswordRulesCatalog.allPassed(_password);

    setState(() {
      _passwordError = !rulesOk ? 'Password does not meet all requirements' : null;
      _confirmError = !match ? 'Passwords do not match' : null;
    });
    if (_passwordError != null || _confirmError != null) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.mediumDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    await AppStatusDialog.show(
      context,
      type: AppStatusType.success,
      title: _isUpdate ? 'Password updated' : 'Password created',
      message: _isUpdate
          ? 'You can sign in with your new password.'
          : 'Your account is ready. Sign in to continue.',
      actionLabel: 'Go to Login',
      onAction: () {
        Navigator.of(context).pop();
        context.go(AppRoute.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdate ? 'Update password' : 'Create password'),
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
            Text(
              _isUpdate ? 'Set a new password' : 'Create your password',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              _isUpdate && widget.args.resetRemark != null
                  ? 'Reset reason on file: ${widget.args.resetRemark}'
                  : 'Use a strong password that meets the rules below.',
              style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 22),
            AppTextField(
              label: _isUpdate ? 'New password' : 'Password',
              hintText: 'Enter password',
              controller: _passwordCtrl,
              obscureable: true,
              prefixIcon: Icons.lock_outline,
              errorText: _passwordError,
              textInputAction: TextInputAction.next,
              onChanged: (v) => setState(() {
                _password = v;
                if (_passwordError != null) _passwordError = null;
              }),
            ),
            const SizedBox(height: 12),
            AppPasswordRules(password: _password),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Confirm password',
              hintText: 'Re-enter password',
              controller: _confirmCtrl,
              obscureable: true,
              prefixIcon: Icons.lock_outline,
              errorText: _confirmError,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_confirmError != null) setState(() => _confirmError = null);
              },
            ),
            const SizedBox(height: 28),
            AppButton(
              label: _isUpdate ? 'Update password' : 'Create password',
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
