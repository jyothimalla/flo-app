import 'package:shared_preferences/shared_preferences.dart';

class LocalAuth {
  static const String _kLoggedIn = 'logged_in';
  static const String _kEmail = 'email';

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  static Future<void> login(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kEmail, email);
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kEmail);
  }

  static Future<String?> email() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmail);
  }
}
