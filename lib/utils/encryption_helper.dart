import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:kinetic/services/secure_storage_service.dart';

class EncryptionHelper {

  static Future<String> _getSecretKey() async {
    return await SecureStorageService.getXorSecretKey();
  }

  static Future<String> encrypt(String plainText) async {
    try {
      final secretKey = await _getSecretKey();
      final key = utf8.encode(secretKey);
      final bytes = utf8.encode(plainText);

      // Use SHA-256 for key derivation
      final keyHash = sha256.convert(key).bytes;
      final encrypted = <int>[];

      // Simple XOR cipher with key rotation
      for (int i = 0; i < bytes.length; i++) {
        encrypted.add(bytes[i] ^ keyHash[i % keyHash.length]);
      }

      return base64Encode(encrypted);
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  static Future<String> decrypt(String encryptedBase64) async {
    try {
      final secretKey = await _getSecretKey();
      final key = utf8.encode(secretKey);
      final keyHash = sha256.convert(key).bytes;
      final encrypted = base64Decode(encryptedBase64);

      final decrypted = <int>[];
      for (int i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ keyHash[i % keyHash.length]);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }
}
