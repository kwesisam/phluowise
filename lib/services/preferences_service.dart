import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static final PreferenceService _instance = PreferenceService._internal();
  static SharedPreferences? _prefs;

  factory PreferenceService() => _instance;

  PreferenceService._internal();

  /// Call this once during app startup
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // Example: Remove key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
