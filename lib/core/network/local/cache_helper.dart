import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool get isInitialized => _prefs != null;

  static Future<bool> saveData({required String key, required dynamic value}) async {
    await init();
    if (value is String) {
      return _prefs!.setString(key, value);
    }
    if (value is int) {
      return _prefs!.setInt(key, value);
    }
    if (value is bool) {
      return _prefs!.setBool(key, value);
    }
    if (value is double) {
      return _prefs!.setDouble(key, value);
    }
    return _prefs!.setString(key, value.toString());
  }

  static T? getData<T>({required String key}) {
    if (_prefs == null) {
      return null;
    }
    return _prefs!.get(key) as T?;
  }

  static Future<T?> getDataAsync<T>({required String key}) async {
    await init();
    return _prefs!.get(key) as T?;
  }

  static Future<bool> removeData({required String key}) async {
    await init();
    return _prefs!.remove(key);
  }
}
