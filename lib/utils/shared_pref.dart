import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String loggedIn = "logged_in";
  static const String accessToken = "token";
  static const String link = "link";
  static const String theme = "theme";

  static Future<SharedPreferences> _instance() async =>
      await SharedPreferences.getInstance();

  static Future<String> getAccessToken() async => await getString(accessToken);
  static Future<bool> setAccessToken(String token) async =>
      await putString(accessToken, token);

  static Future<String> getLinkURL() async => await getString(link);
  static Future<bool> setLinkURL(String _link) async =>
      await putString(link, _link);

  static Future<String> getTheme() async => await getString(theme);
  static Future<bool> setTheme(String token) async =>
      await putString(theme, token);

  static Future<String> getString(String key, {String def = ''}) async =>
      (await _instance()).getString(key) ?? def;

  static Future<bool> putString(String key, String? val) async =>
      (await _instance()).setString(key, val ?? '');

  static Future<int> getInt(String key, {int def = 0}) async =>
      (await _instance()).getInt(key) ?? def;

  static Future<bool> putInt(String key, int? val) async =>
      (await _instance()).setInt(key, val ?? 0);

  static Future<double> getDouble(String key, {double def = 0}) async =>
      (await _instance()).getDouble(key) ?? def;

  static Future<bool> putDouble(String key, double? val) async =>
      (await _instance()).setDouble(key, val ?? 0);

  static Future<bool> getBool(String key, {bool def = false}) async =>
      (await _instance()).getBool(key) ?? def;

  static Future<bool> putBool(String key, bool? val) async =>
      (await _instance()).setBool(key, val ?? false);

  static Future clearVariable() async {
    for (String key in (await _instance()).getKeys()) {
      if (key != theme) {
        (await _instance()).remove(key);
      }
    }
  }
}
