// lib/Bloc/ReviewSubmit/review_submit_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Models/Logic/exception_class.dart';

abstract class ReviewSubmitState {}

class ReviewSubmitInitial extends ReviewSubmitState {}

class ReviewSubmitLoading extends ReviewSubmitState {}

class ReviewSubmitSuccess extends ReviewSubmitState {}

class ReviewSubmitError extends ReviewSubmitState {
  final String message;
  ReviewSubmitError(this.message);
}

class ReviewSubmitCubit extends Cubit<ReviewSubmitState> {
  final UserService _userService;
  ReviewSubmitCubit(this._userService) : super(ReviewSubmitInitial());

  Future<void> submit({
    required String targetId,
    required String targetType,
    required int rating,
    String? comment,
    required String token,
    String? reviewId,
  }) async {
    emit(ReviewSubmitLoading());
    try {
      await _userService.submitReview(
        targetId: targetId,
        targetType: targetType,
        rating: rating,
        comment: comment,
        token: token,
      );
      emit(ReviewSubmitSuccess());
    } on AppException catch (e) {
      emit(ReviewSubmitError(e.message));
    } catch (_) {
      emit(ReviewSubmitError('حدث خطأ غير متوقع'));
    }
  }
}
