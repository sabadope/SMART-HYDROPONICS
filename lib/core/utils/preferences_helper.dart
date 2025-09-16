import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class PreferencesHelper {
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Onboarding
  static Future<bool> getHasSeenOnboarding() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.hasSeenOnboardingKey) ?? false;
  }

  static Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.hasSeenOnboardingKey, value);
  }

  // Authentication
  static Future<String?> getUserToken() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.userTokenKey);
  }

  static Future<void> setUserToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.userTokenKey, token);
  }

  static Future<void> clearUserToken() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.userTokenKey);
  }

  // User Data
  static Future<String?> getUserData() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.userDataKey);
  }

  static Future<void> setUserData(String data) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.userDataKey, data);
  }

  static Future<void> clearUserData() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.userDataKey);
  }

  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}