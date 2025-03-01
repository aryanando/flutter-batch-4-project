import 'package:flutter_batch_4_project/models/user_model.dart';
import 'package:hive/hive.dart';

class AuthLocalStorage {
  late final Box box;

  AuthLocalStorage(this.box);

  // Save token
  Future<void> setToken(String value) async {
    await box.put('token', value);
  }

  // Get token
  String? getToken() {
    return box.get('token');
  }

  // Save full User object (store as JSON map)
  Future<void> setUser(User value) async {
    await box.put('user', value.toJson());
  }

  // Get full User object
  User? getUser() {
    final userJson = box.get('user');
    print('🟢 Retrieved User Data: $userJson');
    if (userJson != null) {
      return User.fromJson(Map<String, dynamic>.from(userJson));
    }
    return null;
  }

  // Clear everything
  Future<void> clear() async {
    await box.delete('token');
    await box.delete('user');
  }
}
