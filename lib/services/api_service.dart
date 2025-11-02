import '../services/local_db_service.dart';
import '../services/encryption_service.dart';

class ApiService {
  final LocalDbService _localDb = LocalDbService();

  
  Future<String?> register(String username, String password) async {
    if (_localDb.userExists(username)) {
      return 'Username sudah terdaftar';
    }

    final encrypted = EncryptionService.encryptText(password);
    await _localDb.saveUser(username, encrypted);
    return null; 
  }

  
  Future<String?> login(String username, String password) async {
    final storedEnc = _localDb.getEncryptedPassword(username);
    if (storedEnc == null) {
      return 'Username tidak ditemukan';
    }
  
    final storedPlain = EncryptionService.decryptText(storedEnc);
    if (storedPlain != password) {
      return 'Password salah';
    }

    return null; 
  }
}
