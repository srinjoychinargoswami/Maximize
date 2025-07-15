import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final _key = Key.fromUtf8('32charlongsecureencryptionkey!'); // 32 chars
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  static String decrypt(String encryptedBase64) {
    return _encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: _iv);
  }
}
