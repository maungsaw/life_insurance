import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

class PasswordRule {
  const PasswordRule({required this.id, required this.label, required this.validator});

  final String id;
  final String label;
  final bool Function(String value) validator;
}

/// Wireframe defaults: 8–16 · uppercase · number · special.
abstract final class PasswordRulesCatalog {
  static List<PasswordRule> get wireframeDefaults => [
        PasswordRule(
          id: 'length',
          label: 'At least 8–16 characters',
          validator: (v) => v.length >= 8 && v.length <= 16,
        ),
        PasswordRule(
          id: 'upper',
          label: 'Must contain at least 1 uppercase letter',
          validator: (v) => RegExp(r'[A-Z]').hasMatch(v),
        ),
        PasswordRule(
          id: 'number',
          label: 'Must contain at least 1 number',
          validator: (v) => RegExp(r'[0-9]').hasMatch(v),
        ),
        PasswordRule(
          id: 'special',
          label: 'Must contain at least 1 special character',
          validator: (v) => RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\]\\;/+=~`]').hasMatch(v),
        ),
      ];

  static bool allPassed(String password, [List<PasswordRule>? rules]) {
    final list = rules ?? wireframeDefaults;
    return list.every((r) => r.validator(password));
  }
}

/// Live checklist under Create / Update Password screens.
class AppPasswordRules extends StatelessWidget {
  const AppPasswordRules({
    super.key,
    required this.password,
    this.rules,
  });

  final String password;
  final List<PasswordRule>? rules;

  @override
  Widget build(BuildContext context) {
    final list = rules ?? PasswordRulesCatalog.wireframeDefaults;
    return Column(
      children: list.map((rule) {
        final ok = rule.validator(password);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                ok ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color: ok ? AppColors.successGreen : AppColors.lightTextHint,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rule.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: ok ? AppColors.lightTextPrimary : AppColors.lightTextSecondary,
                    fontWeight: ok ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
