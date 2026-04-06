import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  late FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _selectedChildKey = 'selected_child';

  Future<void> init() async {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> setUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> setUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  Future<void> setSelectedChild(int childId) async {
    await _storage.write(key: _selectedChildKey, value: childId.toString());
  }

  Future<int?> getSelectedChild() async {
    final value = await _storage.read(key: _selectedChildKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}