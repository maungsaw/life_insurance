import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../core.dart' show EncryptionService;
import 'const.dart' show FileKeyConstants, FileTypeConstants;

class FileStorageService {
  static Future<void> createFolders() async {
    final appDir = await getApplicationDocumentsDirectory();
    await Directory(
      p.join(appDir.path, FileKeyConstants.imageFolder),
    ).create(recursive: true);

    await Directory(
      p.join(appDir.path, FileKeyConstants.excelFolder),
    ).create(recursive: true);
    await Directory(
      p.join(appDir.path, FileKeyConstants.pdfFolder),
    ).create(recursive: true);
  }

  static Future<void> removeFolders() async {
    final appDir = await getApplicationDocumentsDirectory();

    // Define the directories
    final imageDir = Directory(
      p.join(appDir.path, FileKeyConstants.imageFolder),
    );
    final excelDir = Directory(
      p.join(appDir.path, FileKeyConstants.excelFolder),
    );
    final pdfDir = Directory(p.join(appDir.path, FileKeyConstants.pdfFolder));

    // Delete the 'images' folder if it exists
    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
    }

    // Delete the 'docs' folder if it exists
    if (await excelDir.exists()) {
      await excelDir.delete(recursive: true);
    }
    if (await pdfDir.exists()) {
      await pdfDir.delete(recursive: true);
    }
  }

  static Future<String> getPath(String type) async {
    final appDir = await getApplicationDocumentsDirectory();

    switch (type.toLowerCase()) {
      case FileTypeConstants.image:
        return p.join(appDir.path, FileKeyConstants.imageFolder);
      case FileTypeConstants.excel:
        return p.join(appDir.path, FileKeyConstants.excelFolder);
      case FileTypeConstants.pdf:
        return p.join(appDir.path, FileKeyConstants.pdfFolder);
      default:
        return appDir.path;
    }
  }

  static Future<String> getFilePath(String type, String fileName) async {
    final folderPath = await getPath(type);
    return p.join(folderPath, fileName);
  }

  static Future<String> setDocumentSecurely(
    String type,
    File rawDownloadedFile,
  ) async {
    final String docDir = await getPath(type);
    final String originalName = p.basename(rawDownloadedFile.path);
    final String secureFilePath = p.join(
      docDir,
      '${FileKeyConstants.vaultPrefix}$originalName${FileKeyConstants.encryptedExtension}',
    );
    await EncryptionService.encryptFile(
      inputFile: rawDownloadedFile,
      outputPath: secureFilePath,
      key: '',
    );
    if (await rawDownloadedFile.exists()) {
      await rawDownloadedFile.delete();
    }

    return secureFilePath;
  }

  static Future<String> getSecureDocument(String secureFilePath) async {
    final File encryptedFile = File(secureFilePath);

    if (!await encryptedFile.exists()) {
      throw Exception("Target secure cryptographic asset not found at path.");
    }
    final String outputPath = await EncryptionService.decryptFile(
      inputFile: encryptedFile,
      outputPath: secureFilePath.replaceAll('.enc', ''),
      key: '',
    );

    return outputPath;
  }
}
