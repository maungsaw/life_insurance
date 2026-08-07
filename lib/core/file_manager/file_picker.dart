import 'dart:io' show File;

import 'package:file_selector/file_selector.dart'
    show XFile, XTypeGroup, openFile, openFiles;
import 'package:flutter/foundation.dart' show debugPrint;

abstract class FilePickerService {
  /// Pick a single file using `file_selector`
  static Future<File?> pickFile(List<String> extensions) async {
    try {
      final XTypeGroup typeGroup = XTypeGroup(
        label: 'files',
        extensions: extensions,
      );

      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (file != null) {
        return File(file.path);
      }
    } catch (e) {
      debugPrint('Pick error -> $e');
    }

    return null;
  }

  /// Pick multiple files using `file_selector`
  static Future<List<File>?> pickMultiFile(List<String> extensions) async {
    try {
      final XTypeGroup typeGroup = XTypeGroup(
        label: 'files',
        extensions: extensions,
      );

      final List<XFile> files = await openFiles(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (files.isNotEmpty) {
        return files.map((xFile) => File(xFile.path)).toList();
      }
    } catch (e) {
      debugPrint('Pick error -> $e');
    }

    return null;
  }
}
