import 'package:flutter/foundation.dart' show debugPrint;

import 'model.dart';

class RemoteWipeHandler {
  // final RemoteWipeBloc _wipeBloc;
  // final AuthBloc _authBloc;

  RemoteWipeHandler();

  Future<void> executeWipe(VerifyWideDataResponse data) async {
    // await DatabaseFileService.cleanDatabase();
    // await FileStorageService.removeFolders();
    try {
      // final response = await _wipeBloc.wipeUserUseCase(userId: data.userId);
      //   _authBloc.add(LogoutEvent());
    } catch (e) {
      debugPrint("Hello Remote Wipe");
    }
  }
}
