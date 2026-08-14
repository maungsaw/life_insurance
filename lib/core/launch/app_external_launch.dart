import 'package:url_launcher/url_launcher.dart';

enum ExternalLaunchResult { opened, empty, failed }

/// Opens the system Phone dialer / Mail composer (docs/56). No CALL_PHONE.
abstract final class AppExternalLaunch {
  static String? telUri(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    var digits = trimmed.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.isEmpty) return null;
    if (digits.startsWith('+')) return 'tel:$digits';
    if (digits.startsWith('09') && digits.length >= 8) {
      return 'tel:+95${digits.substring(1)}';
    }
    if (digits.startsWith('959')) return 'tel:+$digits';
    return 'tel:$digits';
  }

  static Future<ExternalLaunchResult> phone(String raw) async {
    final href = telUri(raw);
    if (href == null) return ExternalLaunchResult.empty;
    return _open(Uri.parse(href));
  }

  static Future<ExternalLaunchResult> email(String raw) async {
    final address = raw.trim();
    if (address.isEmpty) return ExternalLaunchResult.empty;
    return _open(Uri(scheme: 'mailto', path: address));
  }

  static Future<ExternalLaunchResult> _open(Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      return ok ? ExternalLaunchResult.opened : ExternalLaunchResult.failed;
    } catch (_) {
      return ExternalLaunchResult.failed;
    }
  }
}
