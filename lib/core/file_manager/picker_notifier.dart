import 'dart:io';
import 'package:flutter/foundation.dart';
import 'file_picker.dart'; // import your service class

class FilePickerNotifier extends ChangeNotifier {
  List<File> _selectedFiles = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<File> get selectedFiles => List.unmodifiable(_selectedFiles);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasFiles => _selectedFiles.isNotEmpty;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Pick files with custom extensions and multi/single flag
  /// Pass `null` or empty `extensions` to allow any file type.
  Future<void> pickFiles({
    List<String>? extensions,
    bool allowMultiple = true,
  }) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      if (allowMultiple) {
        final newFiles = await FilePickerService.pickMultiFile(
          extensions ?? [],
        );
        if (newFiles != null && newFiles.isNotEmpty) {
          final existingPaths = _selectedFiles.map((f) => f.path).toSet();
          for (final file in newFiles) {
            if (!existingPaths.contains(file.path)) {
              _selectedFiles.add(file);
            }
          }
        }
      } else {
        final newFile = await FilePickerService.pickFile(extensions ?? []);
        if (newFile != null) {
          _selectedFiles = [newFile]; // Single mode replaces previous selection
        }
      }
    } catch (e) {
      _errorMessage = "Failed to pick files: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// Clear existing and pick again with desired rules
  Future<void> repickFiles({
    List<String>? extensions,
    bool allowMultiple = true,
  }) async {
    clearAllFiles();
    await pickFiles(extensions: extensions, allowMultiple: allowMultiple);
  }

  /// Remove single file by index
  void removeFileAt(int index) {
    if (index >= 0 && index < _selectedFiles.length) {
      _selectedFiles.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear all selected files
  void clearAllFiles() {
    if (_selectedFiles.isNotEmpty) {
      _selectedFiles.clear();
      _errorMessage = null;
      notifyListeners();
    }
  }
}
