// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DioClient {
//   static Dio createDio({required String token}) {
//     final dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://unalterably-unasphalted-felton.ngrok-free.dev',
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );

//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final prefs = await SharedPreferences.getInstance();
//           final String? token = prefs.getString('token');

//           print('===== TOKEN =====');
//           print(token); // شوف إيه اللي بيطلع
//           print('=================');

//           if (token != null) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           return handler.next(options);
//         },
//         onError: (DioException error, handler) {
//           if (error.response?.statusCode == 401) {
//             // handle token expired - navigate to login
//           }
//           return handler.next(error);
//         },
//       ),
//     );

//     return dio;
//   }
// }

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://unalterably-unasphalted-felton.ngrok-free.dev',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final String? token = prefs.getString('token');

          log('TOKEN: $token'); // مؤقت للـ debug

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            // navigate to login
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
