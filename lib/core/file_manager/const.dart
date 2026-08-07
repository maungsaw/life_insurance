abstract class FileKeyConstants {
  static const String signatureKey = 'your_signature_key_here';
  static const String encryptionKey = 'your_encryption_key_here';
  static const String imageFolder = 'images';
  static const String excelFolder = 'excels';
  static const String pdfFolder = 'pdfs';
  static const String vaultPrefix = 'vault_';
  static const String encryptedExtension = '.enc';
}

abstract class FileTypeConstants {
  static const String image = 'image';
  static const String excel = 'xlsx';
  static const String pdf = 'pdf';
  static const String png = 'png';
  static const String jpg = 'jpg';
  static const String jpeg = 'jpeg';
  static const List<String> imageExtensions = [png, jpg, jpeg];
  static const List<String> excelExtensions = [excel];
  static const List<String> pdfExtensions = [pdf];
}
