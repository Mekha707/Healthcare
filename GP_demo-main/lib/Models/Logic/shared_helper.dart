import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _tokenKey = 'token'; // ✅ نفس الـ key بتاعك

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey); // ✅ نفس الكود بتاعك هنا
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
