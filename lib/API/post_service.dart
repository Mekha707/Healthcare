// import 'package:dio/dio.dart';
// import 'package:healthcareapp_try1/API/dio_client.dart';
// import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';
// import 'package:healthcareapp_try1/Models/Posts/post_query_params.dart';
// import 'package:healthcareapp_try1/Models/Posts/posts_model.dart';

// class PostRepository {
//   final Dio _dio;

//   PostRepository({required String token})
//     : _dio = DioClient.createDio(token: token);

//   Future<PaginatedList<PostModel>> fetchPosts(PostQueryParams params) async {
//     final response = await _dio.get(
//       '/api/Posts',
//       queryParameters: params.toMap(),
//     );
//     return PaginatedList.fromJson(response.data, PostModel.fromJson);
//   }
// }

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/API/dio_client.dart';
import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';
import 'package:healthcareapp_try1/Models/Posts/post_query_params.dart';
import 'package:healthcareapp_try1/Models/Posts/posts_model.dart';

class PostRepository {
  final Dio _dio;

  // ✅ مفيش token هنا، الـ interceptor بيجيبه أوتوماتيك
  PostRepository() : _dio = DioClient.createDio();

  Future<PaginatedList<PostModel>> fetchPosts(PostQueryParams params) async {
    final response = await _dio.get(
      '/api/Posts',
      queryParameters: params.toMap(),
    );
    return PaginatedList.fromJson(response.data, PostModel.fromJson);
  }
}
