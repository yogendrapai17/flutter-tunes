import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService();

  /// Save String list to cache
  Future<bool> saveStringToCache(
      {required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  /// Save string list to cache
  Future<bool> saveStringListToCache(
      {required String key, required List<String> value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  /// Try reading [String] data from the key. If it doesn't exist, returns null.
  Future<String?> readStringFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Try reading [List]<[String]> data from the key. If it doesn't exist, returns null.
  Future<List<String>?> readListFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  /// Remove a value from cache for the key
  Future<bool> removeValueFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
