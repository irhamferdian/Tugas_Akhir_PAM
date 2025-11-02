import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/encryption_service.dart';
import '../services/local_db_service.dart';

class AuthProvider with ChangeNotifier {
  final LocalDbService _db = LocalDbService();
  String? _username;
  bool _isLoading = false;

  String? get username => _username;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _username != null;

  AuthProvider(this._username);

  
  Future<String?> register(String username, String password) async {
    try {
      _setLoading(true);

      
      if (_db.userExists(username)) {
        return "Username sudah digunakan";
      }

      
      final encryptedPass = EncryptionService.encryptText(password);
      await _db.saveUser(username, encryptedPass);

      return null; // sukses
    } catch (e) {
      return "Terjadi kesalahan: $e";
    } finally {
      _setLoading(false);
    }
  }

 
  Future<String?> login(String username, String password) async {
    try {
      _setLoading(true);

      if (!_db.userExists(username)) {
        return "Username tidak ditemukan";
      }

      final encryptedStoredPass = _db.getEncryptedPassword(username);
      if (encryptedStoredPass == null) {
        return "Data user rusak atau tidak valid";
      }

      final decryptedStoredPass =
          EncryptionService.decryptText(encryptedStoredPass);

      if (decryptedStoredPass != password) {
        return "Password salah";
      }

      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user', username);
      _username = username;

      return null; // sukses
    } catch (e) {
      return "Terjadi kesalahan login: $e";
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> logout() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('logged_in_user');
      _username = null;
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      _setLoading(false);
    }
  }

  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
