import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show PrototypeConfig, AppColors;
import 'package:life_insurance/features/components/components.dart';
import 'package:life_insurance/features/profile/presentation/widgets/profile_sub_app_bar.dart';

/// Logged-in change password — current + new + confirm (docs/50).
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _password = '';
  String? _currentError;
  String? _passwordError;
  String? _confirmError;
  bool _submitting = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final current = _currentCtrl.text;
    final match = _passwordCtrl.text == _confirmCtrl.text;
    final rulesOk = PasswordRulesCatalog.allPassed(_password);

    setState(() {
      _currentError = current.isEmpty ? 'Current password is required' : null;
      _passwordError =
          !rulesOk ? 'Password does not meet all requirements' : null;
      _confirmError = !match ? 'Passwords do not match' : null;
    });
    if (_currentError != null ||
        _passwordError != null ||
        _confirmError != null) {
      return;
    }

    if (PrototypeConfig.isWrongPassword(current)) {
      await AppStatusDialog.show(
        context,
        type: AppStatusType.warning,
        title: 'Incorrect password',
        message: 'Current password is not correct. Please try again.',
        actionLabel: 'OK',
      );
      return;
    }

    setState(() => _submitting = true);
    await Future<void>.delayed(PrototypeConfig.mediumDelay);
    if (!mounted) return;
    setState(() => _submitting = false);

    await AppStatusDialog.show(
      context,
      type: AppStatusType.success,
      title: 'Password updated',
      message: 'Your password has been changed.',
      actionLabel: 'OK',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: const ProfileSubAppBar(title: 'Change Password'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          AppTextField(
            label: 'Current Password',
            isRequired: true,
            controller: _currentCtrl,
            obscureable: true,
            errorText: _currentError,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_currentError != null) setState(() => _currentError = null);
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'New Password',
            isRequired: true,
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
    );
  }
}
