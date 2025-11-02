import 'package:encrypt/encrypt.dart';

class EncryptionService {
  
  static final _keyString = '1234567890abcdef1234567890abcdef'; 
  
  static final _ivString = 'abcdef1234567890'; 

  static final Key _key = Key.fromUtf8(_keyString);
  static final IV _iv = IV.fromUtf8(_ivString);
  static final Encrypter _encrypter =
      Encrypter(AES(_key, mode: AESMode.cbc, padding: 'PKCS7'));

  
  static String encryptText(String plain) {
    final encrypted = _encrypter.encrypt(plain, iv: _iv);
    return encrypted.base64;
  }

  
  static String decryptText(String base64Str) {
    final encrypted = Encrypted.fromBase64(base64Str);
    final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
    return decrypted;
  }
}
