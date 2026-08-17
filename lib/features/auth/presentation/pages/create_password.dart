import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/auth/presentation/models/auth_flow_args.dart';
import 'package:life_insurance/features/components/components.dart';

/// Update / Create password — wireframe checklist + SAVE (docs/42 · 43).
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
      _passwordError =
          !rulesOk ? 'Password does not meet all requirements' : null;
      _confirmError = !match ? 'Passwords do not match' : null;
    });
    if (_passwordError != null || _confirmError != null) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.mediumDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (_isUpdate) {
      final proceed = await AppStatusDialog.show(
        context,
        type: AppStatusType.warning,
        title: 'Warning Message',
        message:
            'Your password will be updated on self-service. Do you want to proceed?',
        actionLabel: 'YES',
        secondaryLabel: 'NO',
      );
      if (!mounted || proceed != true) return;

      await AppStatusDialog.show(
        context,
        type: AppStatusType.success,
        title: 'Password Updated',
        message:
            'The password has also changed for self-service. Please log in again.',
        actionLabel: 'OK',
        onAction: () {
          Navigator.of(context).pop(true);
          context.go(AppRoute.login);
        },
      );
      return;
    }

    await AppStatusDialog.show(
      context,
      type: AppStatusType.success,
      title: 'Success!',
      message: 'The password has been created successfully.',
      actionLabel: 'OK',
      onAction: () {
        PrototypeConfig.markActive(widget.args.mobile);
        Navigator.of(context).pop(true);
        context.go(AppRoute.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              _isUpdate ? 'Update Password' : 'Create Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'New Password',
              isRequired: true,
              hintText: 'Enter new password',
              controller: _passwordCtrl,
              obscureable: true,
              errorText: _passwordError,
              textInputAction: TextInputAction.next,
              onChanged: (v) => setState(() {
                _password = v;
                if (_passwordError != null) _passwordError = null;
              }),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Confirm Password',
              isRequired: true,
              hintText: 'Re-enter password',
              controller: _confirmCtrl,
              obscureable: true,
              errorText: _confirmError,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_confirmError != null) setState(() => _confirmError = null);
              },
            ),
            const SizedBox(height: 20),
            AppPasswordRules(password: _password),
            const SizedBox(height: 28),
            AppButton(
              label: 'SAVE',
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
