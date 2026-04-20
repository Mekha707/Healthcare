class PostQueryParams {
  final String? search;
  final String? specialtyId;
  final bool? pendingPosts;
  final int page;
  final int pageSize;

  const PostQueryParams({
    this.search,
    this.specialtyId,
    this.pendingPosts,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toMap() {
    return {
      if (search != null && search!.isNotEmpty) 'Search': search,
      if (specialtyId != null) 'SpecialtyId': specialtyId,
      if (pendingPosts != null) 'PendingPosts': pendingPosts,
      'Page': page,
      'PageSize': pageSize,
    };
  }

  PostQueryParams copyWith({
    String? search,
    String? specialtyId,
    bool? pendingPosts,
    int? page,
    int? pageSize,
  }) {
    return PostQueryParams(
      search: search ?? this.search,
      specialtyId: specialtyId ?? this.specialtyId,
      pendingPosts: pendingPosts ?? this.pendingPosts,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
