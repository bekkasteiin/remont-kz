
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = "token";
  static const String _seen = 'seen';

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  static Future<bool?> getSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seen)??false;
  }

  static Future<void> removeAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_seen);
  }

  static Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('setToken');
    return prefs.setString(_tokenKey, value);
  }

  static Future<bool> setSeen(bool value) async {
    print('taps');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('setSeen');
    return prefs.setBool(_seen, value);
  }
}