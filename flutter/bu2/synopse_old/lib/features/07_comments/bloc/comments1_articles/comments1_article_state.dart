part of 'comments1_article_bloc.dart';

class Comments1ArticleState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2Detail>
      synopseArticlesTV4ArticleGroupsL2Detail;
  final bool hasReachedMax;
  final Comments1ArticleStatus status;

  const Comments1ArticleState(
      {this.synopseArticlesTV4ArticleGroupsL2Detail =
          const <SynopseArticlesTV4ArticleGroupsL2Detail>[],
      this.hasReachedMax = false,
      this.status = Comments1ArticleStatus.initial});

  Comments1ArticleState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2Detail>?
        synopseArticlesTV4ArticleGroupsL2Detail,
    bool? hasReachedMax,
    Comments1ArticleStatus? status,
  }) {
    return Comments1ArticleState(
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
