/// Shared navigation args for FR-01 auth flows (docs/35).
enum AuthOtpPurpose { forgotPassword, register }

class AuthOtpArgs {
  const AuthOtpArgs({
    required this.mobile,
    required this.purpose,
    this.resetRemark,
  });

  final String mobile;
  final AuthOtpPurpose purpose;
  /// BRD FR-01: mandatory remark/reason for password reset.
  final String? resetRemark;
}

enum AuthPasswordMode { create, update }

class AuthPasswordArgs {
  const AuthPasswordArgs({
    required this.mobile,
    required this.mode,
    this.resetRemark,
  });

  final String mobile;
  final AuthPasswordMode mode;
  final String? resetRemark;
}
