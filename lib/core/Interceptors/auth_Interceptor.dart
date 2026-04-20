// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  // هنا نفترض أنك تخزن الـ Tokens في Secure Storage أو SharedPreferences
  // final AuthService authService;

  AuthInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. التحقق إذا كان الخطأ 401
    if (err.response?.statusCode == 401) {
      try {
        // 2. الحصول على الـ Refresh Token المخزن لديك
        String? refreshToken = await _getStoredRefreshToken();

        if (refreshToken != null) {
          // 3. محاولة طلب Token جديد
          final response = await dio.post(
            '/api/Auth/refresh',
            data: {
              'refreshToken': refreshToken,
              'token': await _getStoredAccessToken(), // الـ Token القديم
            },
          );

          if (response.statusCode == 200) {
            // 4. استخراج الـ Tokens الجديدة (حسب شكل الـ JSON اللي بعته)
            final newToken = response.data['token'];
            final newRefreshToken = response.data['refreshToken'];

            // 5. حفظ الـ Tokens الجديدة
            await _saveNewTokens(newToken, newRefreshToken);

            // 6. تحديث رأس الطلب الأصلي (Header) وإعادة تنفيذه
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            // إنشاء طلب جديد بنفس المواصفات
            final opts = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            );

            final cloneReq = await dio.request(
              err.requestOptions.path,
              options: opts,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            );

            return handler.resolve(cloneReq); // إرجاع نتيجة الطلب الناجح
          }
        }
      } catch (e) {
        // إذا فشل الـ Refresh أيضاً (مثلاً الـ Refresh Token انتهى)
        // هنا يجب تسجيل خروج المستخدم وتوجيهه لصفحة الـ Login
        _performLogout();
      }
    }
    return super.onError(err, handler);
  }

  // دوال مساعدة (يجب تنفيذها حسب طريقة تخزينك للبيانات)
  Future<String?> _getStoredRefreshToken() async => "token_from_storage";
  Future<String?> _getStoredAccessToken() async => "old_token_from_storage";
  Future<void> _saveNewTokens(String t, String r) async {
    /* Save to Storage */
  }
  void _performLogout() {
    /* Clear data and navigate to login */
  }
}

class DioConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options.baseUrl = "https://your-api-url.com"; // ضع الرابط الخاص بك هنا

    // إضافة الـ Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة التوكن الحالي لكل طلب يخرج من التطبيق
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // إذا كان الخطأ 401 (التوكن انتهى)
          if (e.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refreshToken');
            final oldToken = prefs.getString('token');

            if (refreshToken != null && oldToken != null) {
              try {
                // محاولة عمل Refresh
                // نستخدم Instance جديدة من Dio لتجنب الدخول في حلقة مفرغة (Infinite Loop)
                final refreshResponse = await Dio().post(
                  "${dio.options.baseUrl}/api/Auth/refresh",
                  data: {"token": oldToken, "refreshToken": refreshToken},
                );

                if (refreshResponse.statusCode == 200) {
                  // استخراج البيانات الجديدة
                  final newToken = refreshResponse.data['token'];
                  final newRefreshToken = refreshResponse.data['refreshToken'];

                  // حفظ البيانات الجديدة في Shared Preferences
                  await prefs.setString('token', newToken);
                  await prefs.setString('refreshToken', newRefreshToken);

                  // تحديث الـ Header في الطلب الأصلي الذي فشل
                  e.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';

                  // إعادة تنفيذ الطلب الأصلي بنفس البيانات
                  final opts = Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers,
                  );

                  final cloneReq = await dio.request(
                    e.requestOptions.path,
                    options: opts,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters,
                  );

                  // إرجاع نتيجة الطلب الناجح للـ Bloc أو الـ UI
                  return handler.resolve(cloneReq);
                }
              } catch (refreshError) {
                // إذا فشل الـ Refresh أيضاً (مثلاً الـ Refresh Token نفسه انتهى)
                // يجب مسح البيانات وتوجيه المستخدم لصفحة تسجيل الدخول
                await prefs.clear();
                // يمكنك هنا استخدام Navigator أو إرسال حدث للـ AuthBloc لعمل Logout
                print("Session expired. Please login again.");
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
