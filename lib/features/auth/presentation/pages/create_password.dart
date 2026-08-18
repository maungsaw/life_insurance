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
  String _confirm = '';
  String? _passwordError;
  String? _confirmError;
  String? _reasonError;
  bool _submitting = false;

  bool get _isUpdate => widget.args.mode == AuthPasswordMode.update;

  static const _reasons = [
    'Forgot current password',
    'Account security concern',
    'Password expired',
    'Other',
  ];

  String? _updateReason;
  final _otherReasonCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _otherReasonCtrl.dispose();
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

    if (_isUpdate) {
      final hasSelected = _updateReason != null;
      final otherOk = _updateReason != 'Other' ||
          _otherReasonCtrl.text.trim().isNotEmpty;
      if (!hasSelected || !otherOk) {
        setState(() {
          if (_updateReason == null) {
            _reasonError = 'Remark reason is required';
          } else if (_updateReason == 'Other' &&
              _otherReasonCtrl.text.trim().isEmpty) {
            _reasonError = 'Please enter your reason';
          } else {
            _reasonError = 'Remark reason is required';
          }
        });
        return;
      }
      _reasonError = null;
    }

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _isUpdate ? 'Update Password' : 'Create Password',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
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
              onChanged: (v) {
                setState(() {
                  _confirm = v;
                  if (_confirmError != null) _confirmError = null;
                  if (_reasonError != null) _reasonError = null;
                });
              },
            ),
            const SizedBox(height: 20),
            AppPasswordRules(password: _password),
            if (_isUpdate) ...[
              const SizedBox(height: 16),
              Builder(
                builder: (_) {
                  final showReason = _password.isNotEmpty &&
                          _confirm.isNotEmpty ||
                      _reasonError != null;
                  if (!showReason) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remark reason',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (final r in _reasons)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _updateReason = r;
                              if (r != 'Other') {
                                _otherReasonCtrl.clear();
                              }
                              _reasonError = null;
                            });
                          },
                          splashFactory: InkRipple.splashFactory,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  _updateReason == r
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  size: 20,
                                  color: _updateReason == r
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    r,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_updateReason == 'Other') ...[
                        const SizedBox(height: 4),
                        AppTextField(
                          label: 'Reason',
                          hintText: 'Enter your reason',
                          controller: _otherReasonCtrl,
                          errorText: _reasonError,
                          onChanged: (_) {
                            if (_reasonError != null) {
                              setState(() => _reasonError = null);
                            }
                          },
                        ),
                      ] else if (_reasonError != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _reasonError!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
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

