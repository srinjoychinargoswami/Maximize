import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

/// Encryption Service - Handles AES-256 encryption/decryption of sensitive data
/// All Firebase data is encrypted before upload and decrypted after download
class EncryptionService {
  static final EncryptionService instance = EncryptionService._();
  EncryptionService._();

  late encrypt.Key _key;
  late encrypt.IV _iv;
  late encrypt.Encrypter _encrypter;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize encryption service with AES-256
  /// Uses a default key - in production, should use platform-specific secure storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // IMPORTANT: In production, store this key in:
      // - iOS: Keychain
      // - Android: Keystore
      // - macOS: Keychain
      // - Windows: Credential Manager
      // For now using a derived key (NOT PRODUCTION SECURE)

      const String masterKey = 'maximize_secure_key_256bit_length_needed';

      // Ensure key is exactly 32 bytes (256 bits) for AES-256
      final keyBytes = utf8.encode(masterKey);
      final paddedKey = List<int>.from(keyBytes);
      while (paddedKey.length < 32) {
        paddedKey.add(0);
      }
      final finalKey = paddedKey.sublist(0, 32);

      // IV (Initialization Vector) - must be 16 bytes
      const String ivString = 'maximize_iv_16byt';
      final ivBytes = utf8.encode(ivString.padRight(16, '0').substring(0, 16));

      _key = encrypt.Key(Uint8List.fromList(finalKey));
      _iv = encrypt.IV(Uint8List.fromList(ivBytes));
      _encrypter = encrypt.Encrypter(encrypt.AES(_key));

      _isInitialized = true;
      debugPrint('[EncryptionService] Initialized AES-256 encryption');
    } catch (e) {
      debugPrint('[EncryptionService] Initialization error: $e');
      rethrow;
    }
  }

  /// Encrypt JSON data to base64 string
  Future<String> encryptJson(Map<String, dynamic> jsonData) async {
    if (!_isInitialized) await initialize();

    try {
      final jsonString = jsonEncode(jsonData);
      final encrypted = _encrypter.encrypt(jsonString, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      debugPrint('[EncryptionService] JSON encryption error: $e');
      rethrow;
    }
  }

  /// Decrypt base64 string to JSON
  Future<Map<String, dynamic>> decryptJson(String encryptedData) async {
    if (!_isInitialized) await initialize();

    try {
      final decrypted = _encrypter.decrypt64(encryptedData, iv: _iv);
      final jsonData = jsonDecode(decrypted);
      return jsonData as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[EncryptionService] JSON decryption error: $e');
      rethrow;
    }
  }

  /// Encrypt string to base64
  Future<String> encryptString(String plaintext) async {
    if (!_isInitialized) await initialize();

    try {
      final encrypted = _encrypter.encrypt(plaintext, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      debugPrint('[EncryptionService] String encryption error: $e');
      rethrow;
    }
  }

  /// Decrypt base64 string to plaintext
  Future<String> decryptString(String encryptedData) async {
    if (!_isInitialized) await initialize();

    try {
      final decrypted = _encrypter.decrypt64(encryptedData, iv: _iv);
      return decrypted;
    } catch (e) {
      debugPrint('[EncryptionService] String decryption error: $e');
      rethrow;
    }
  }

  /// Encrypt a map to encrypted payload structure
  Future<Map<String, dynamic>> encryptPayload(Map<String, dynamic> data) async {
    try {
      final encryptedJson = await encryptJson(data);
      return {
        'v': 1, // Version for future compatibility
        'data': encryptedJson, // Encrypted base64 data
      };
    } catch (e) {
      debugPrint('[EncryptionService] Payload encryption error: $e');
      rethrow;
    }
  }

  /// Decrypt encrypted payload structure
  Future<Map<String, dynamic>> decryptPayload(Map<String, dynamic> payload) async {
    try {
      if (payload['v'] != 1) {
        throw Exception('Unsupported payload version: ${payload['v']}');
      }

      final encryptedJson = payload['data'] as String;
      return await decryptJson(encryptedJson);
    } catch (e) {
      debugPrint('[EncryptionService] Payload decryption error: $e');
      rethrow;
    }
  }
}
