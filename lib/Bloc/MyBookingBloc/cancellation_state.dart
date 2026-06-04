part of 'cancellation_bloc.dart';

abstract class CancellationState extends Equatable {
  const CancellationState();
  @override
  List<Object?> get props => [];
}

class CancellationInitial extends CancellationState {}

class CancellationLoading extends CancellationState {}

class CancellationSuccess extends CancellationState {
  final String message;
  const CancellationSuccess({this.message = 'تم إلغاء الموعد بنجاح'});
  @override
  List<Object?> get props => [message];
}

class CancellationFailure extends CancellationState {
  final String error;
  const CancellationFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
