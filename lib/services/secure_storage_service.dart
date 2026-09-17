import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service to manage sensitive keys stored in device-encrypted secure storage.
/// On first run, loads from .env file and encrypts to device.
/// On subsequent runs, reads from device secure storage (faster, never re-reads .env).
class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  /// Encryption Master Key - AES-256
  static Future<String> getMasterKey() async {
    String? key = await _storage.read(key: 'encryption_master_key');
    if (key == null) {
      // First run: load from .env
      key = dotenv.env['ENCRYPTION_MASTER_KEY'] ?? '';
      if (key.isNotEmpty) {
        await _storage.write(key: 'encryption_master_key', value: key);
      }
    }
    return key;
  }

  /// Encryption IV - 16 bytes
  static Future<String> getEncryptionIV() async {
    String? iv = await _storage.read(key: 'encryption_iv');
    if (iv == null) {
      // First run: load from .env
      iv = dotenv.env['ENCRYPTION_IV'] ?? '';
      if (iv.isNotEmpty) {
        await _storage.write(key: 'encryption_iv', value: iv);
      }
    }
    return iv;
  }

  /// XOR Cipher Secret Key
  static Future<String> getXorSecretKey() async {
    String? key = await _storage.read(key: 'xor_secret_key');
    if (key == null) {
      // First run: load from .env
      key = dotenv.env['XOR_SECRET_KEY'] ?? '';
      if (key.isNotEmpty) {
        await _storage.write(key: 'xor_secret_key', value: key);
      }
    }
    return key;
  }
}
