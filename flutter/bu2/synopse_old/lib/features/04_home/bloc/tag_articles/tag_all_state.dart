part of 'tag_all_bloc.dart';

class TagAllState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2Detail>
      synopseArticlesTV4ArticleGroupsL2Detail;
  final bool hasReachedMax;
  final TagAllStatus status;

  const TagAllState(
      {this.synopseArticlesTV4ArticleGroupsL2Detail =
          const <SynopseArticlesTV4ArticleGroupsL2Detail>[],
      this.hasReachedMax = false,
      this.status = TagAllStatus.initial});

  TagAllState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2Detail>?
        synopseArticlesTV4ArticleGroupsL2Detail,
    bool? hasReachedMax,
    TagAllStatus? status,
  }) {
    return TagAllState(
      synopseArticlesTV4ArticleGroupsL2Detail:
          synopseArticlesTV4ArticleGroupsL2Detail ??
              this.synopseArticlesTV4ArticleGroupsL2Detail,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesTV4ArticleGroupsL2Detail, hasReachedMax, status];
}
