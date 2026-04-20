import 'package:equatable/equatable.dart';
import 'package:healthcareapp_try1/Models/Posts/post_query_params.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {
  final PostQueryParams params;

  FetchPostsEvent({PostQueryParams? params})
    : params = params ?? const PostQueryParams();

  @override
  List<Object?> get props => [params];
}
