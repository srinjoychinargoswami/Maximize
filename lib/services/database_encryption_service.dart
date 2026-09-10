import 'package:flutter/foundation.dart';
import 'package:maximize/services/encryption_service.dart';

/// Platform-specific encryption configuration for database sync
/// - Web: Uses EncryptionService (AES-256) before uploading to Firebase
/// - Native: Uses EncryptionService (AES-256) before uploading to Firebase
///
/// Note: Local database is NOT encrypted
/// Encryption only happens during Firebase sync
class DatabaseEncryptionService {
  static final DatabaseEncryptionService _instance = DatabaseEncryptionService._();

  DatabaseEncryptionService._();

  static DatabaseEncryptionService get instance => _instance;

  /// Get platform-specific encryption info
  String getPlatformType() {
    if (kIsWeb) {
      return 'web_indexdb';  // IndexedDB backend
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'native_sqlite_android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'native_sqlite_ios';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return 'native_sqlite_macos';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'native_sqlite_windows';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return 'native_sqlite_linux';
    }
    return 'unknown';
  }

  /// Encrypt data before sending to Firebase (all platforms)
  Future<String> encryptForSync(String plaintext) async {
    try {
      final encrypted = await EncryptionService.instance.encryptString(plaintext);
      debugPrint('[DatabaseEncryption] Encrypted ${plaintext.length} chars for sync');
      return encrypted;
    } catch (e) {
      debugPrint('[DatabaseEncryption] Encryption error: $e');
      rethrow;
    }
  }

  /// Decrypt data received from Firebase (all platforms)
  Future<String> decryptFromSync(String ciphertext) async {
    try {
      final decrypted = await EncryptionService.instance.decryptString(ciphertext);
      debugPrint('[DatabaseEncryption] Decrypted ${decrypted.length} chars from sync');
      return decrypted;
    } catch (e) {
      debugPrint('[DatabaseEncryption] Decryption error: $e');
      rethrow;
    }
  }

  /// Log platform-specific storage info
  void logStorageInfo() {
    final platform = getPlatformType();
    debugPrint('[DatabaseEncryption] Platform: $platform');

    if (kIsWeb) {
      debugPrint('[DatabaseEncryption] Storage: IndexedDB (500MB-1GB quota)');
      debugPrint('[DatabaseEncryption] Backend: SQLite WASM + IndexedDB');
    } else {
      debugPrint('[DatabaseEncryption] Storage: Native SQLite filesystem');
      debugPrint('[DatabaseEncryption] Backend: Native SQLite');
    }

    debugPrint('[DatabaseEncryption] Encryption: AES-256 for Firebase sync');
    debugPrint('[DatabaseEncryption] Local DB: NOT encrypted (encryption only in transit)');
  }
}
