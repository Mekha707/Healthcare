import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  // بننادي الميثود دي في الـ main قبل الـ runApp
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // ميثود لجلب الـ Token
  static String? getToken() {
    return sharedPreferences.getString('token');
  }

  // ميثود لحفظ الـ Token (هتحتاجها وقت الـ Login)
  static Future<bool> saveToken(String token) async {
    return await sharedPreferences.setString('token', token);
  }
}
