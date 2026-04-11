import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/review_model.dart';
import 'package:healthcareapp_try1/Models/Logic/exception_class.dart';
import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final PaginatedList<ReviewModel> reviewsData;
  ReviewsLoaded(this.reviewsData);
}

class ReviewsError extends ReviewsState {
  final String message;
  ReviewsError(this.message);
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final UserService _userService;
  ReviewsCubit(this._userService) : super(ReviewsInitial());

  Future<void> fetchReviews(String id, String type, {int page = 1}) async {
    emit(ReviewsLoading());
    try {
      final result = await _userService.getReviews(
        id,
        type.capitalize(),
        page: page,
      );
      emit(ReviewsLoaded(result));
    } on AppException catch (e) {
      emit(ReviewsError(e.message));
    } catch (_) {
      emit(ReviewsError("حدث خطأ غير متوقع"));
    }
  }
}

extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
