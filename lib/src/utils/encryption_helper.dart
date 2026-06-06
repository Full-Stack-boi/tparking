import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  // Use a 32-character key for AES-256 and a 16-character IV
  static final _key = Key.fromUtf8('tparking_secure_secret_key_2026_');
  static final _iv = IV.fromUtf8('tparking_iv_16ch');
  static final _encrypter = Encrypter(AES(_key));

  /// Encrypts the plaintext string to AES-256 Base64 ciphertext
  static String encrypt(String text) {
    if (text.isEmpty) return text;
    try {
      final encrypted = _encrypter.encrypt(text, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      return text;
    }
  }

  /// Decrypts the Base64 ciphertext back to plaintext. 
  /// Returns the original text if decryption fails (backwards compatibility).
  static String decrypt(String cipherText) {
    if (cipherText.isEmpty) return cipherText;
    try {
      final decrypted = _encrypter.decrypt64(cipherText, iv: _iv);
      return decrypted;
    } catch (e) {
      return cipherText;
    }
  }
}
