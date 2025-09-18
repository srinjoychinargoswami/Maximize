import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class EncryptionHelper {
  static const String _secretKey = 'ProductivityApp2024SecretKey!!'; // Exactly 32 characters
  
  static String encrypt(String plainText) {
    try {
      final key = utf8.encode(_secretKey);
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
  
  static String decrypt(String encryptedBase64) {
    try {
      final key = utf8.encode(_secretKey);
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
