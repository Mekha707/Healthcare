import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/post_service.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc(this.repository) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    try {
      final result = await repository.fetchPosts(event.params);
      print('✅ Total posts: ${result.items.length}'); // كام بوست اتجاب؟
      print('✅ Total count: ${result.totalCount}');
      print(
        '✅ First post: ${result.items.isNotEmpty ? result.items.first.title : 'فاضي'}',
      );
      emit(
        PostLoaded(
          posts: result.items,
          hasNextPage: result.hasNextPage,
          hasPreviousPage: result.hasPreviousPage,
          currentPage: result.pageNumber,
          totalCount: result.totalCount,
          activeParams: event.params,
        ),
      );
    } on DioException catch (e) {
      emit(PostError(_mapDioError(e)));
    } catch (e) {
      emit(PostError('حدث خطأ غير متوقع'));
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال، تأكد من الإنترنت';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      default:
        final status = e.response?.statusCode;
        if (status == 401) return 'غير مصرح، يرجى تسجيل الدخول مجدداً';
        if (status == 403) return 'ليس لديك صلاحية';
        if (status == 404) return 'لم يتم العثور على البيانات';
        return 'فشل تحميل البوستات ($status)';
    }
  }
}
