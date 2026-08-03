import 'package:flutter/foundation.dart';
import 'package:life_insurance/core/core.dart' show EncryptionService;
import 'package:life_insurance/core/remote_wipe/remote_wipe.dart'
    show VerifyWideDataResponse, RemoteWipeHandler;

abstract class NotificationActions {
  static Future<void> _performRemoteWipeIfRequested(
    VerifyWideDataResponse data,
  ) async {
    final validation = EncryptionService.verifySignature(
      data.action,
      data.issuedAt.toString(),
      data.nonce,
      data.signature,
    );

    debugPrint('Security alert: Verified remote wipe command received.');
    if (validation) {
      final handler = RemoteWipeHandler(
        // Injection.sl<RemoteWipeBloc>(),
        // Injection.sl<AuthBloc>(),
      );
      await handler.executeWipe(data);
    } else {}
  }

  static void handleNotificationNavigation(Map<String, dynamic> data) {
    // final screen = data['screen'];
    // if (screen == AppRoutes.calculator) {
    //   AppRouter.router.push(AppRoutes.calculator);
    // }
  }

  static Future<void> checkWipePermission(
    String? action,
    VerifyWideDataResponse data,
  ) async {
    if (action == null || action.isEmpty) {
      debugPrint('No action specified in the notification data.');
      return;
    }
    if (action == 'WIPE_DATA') {
      await _performRemoteWipeIfRequested(data);
    }
  }
}
