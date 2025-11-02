import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbService {
  static const String USER_REGISTRATION_BOX = 'user_registration_box';

  
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    if (!Hive.isBoxOpen(USER_REGISTRATION_BOX)) {
      await Hive.openBox(USER_REGISTRATION_BOX);
    }
  }

  Future<void> saveUser(String username, String encryptedPassword) async {
    final box = Hive.box(USER_REGISTRATION_BOX);
    await box.put(username, encryptedPassword);
  }

  String? getEncryptedPassword(String username) {
    final box = Hive.box(USER_REGISTRATION_BOX);
    return box.get(username);
  }

  bool userExists(String username) {
    final box = Hive.box(USER_REGISTRATION_BOX);
    return box.containsKey(username);
  }

  Future<void> deleteUser(String username) async {
    final box = Hive.box(USER_REGISTRATION_BOX);
    await box.delete(username);
  }

  Map<dynamic, dynamic> getAllUsers() {
    final box = Hive.box(USER_REGISTRATION_BOX);
    return box.toMap();
  }
}
