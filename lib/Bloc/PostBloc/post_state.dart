import 'package:equatable/equatable.dart';
import 'package:healthcareapp_try1/Models/Posts/post_query_params.dart';
import 'package:healthcareapp_try1/Models/Posts/posts_model.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final int currentPage;
  final int totalCount;
  final PostQueryParams activeParams;

  PostLoaded({
    required this.posts,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.currentPage,
    required this.totalCount,
    required this.activeParams,
  });

  @override
  List<Object?> get props => [
    posts,
    hasNextPage,
    hasPreviousPage,
    currentPage,
    totalCount,
    activeParams,
  ];
}

class PostError extends PostState {
  final String message;
  PostError(this.message);

  @override
  List<Object?> get props => [message];
}
