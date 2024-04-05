part of 'article_details_no_bloc.dart';

class ArticleDetailsNoState extends Equatable {
  final List<SynopseArticlesTV3ArticleGroupsL2>
      synopseArticlesTV3ArticleGroupsL2;
  final ArticleDetailsNoStatus status;

  const ArticleDetailsNoState(
      {this.synopseArticlesTV3ArticleGroupsL2 =
          const <SynopseArticlesTV3ArticleGroupsL2>[],
      this.status = ArticleDetailsNoStatus.initial});

  ArticleDetailsNoState copyWith({
    List<SynopseArticlesTV3ArticleGroupsL2>? synopseArticlesTV3ArticleGroupsL2,
    ArticleDetailsNoStatus? status,
  }) {
    return ArticleDetailsNoState(
      synopseArticlesTV3ArticleGroupsL2: synopseArticlesTV3ArticleGroupsL2 ??
          this.synopseArticlesTV3ArticleGroupsL2,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseArticlesTV3ArticleGroupsL2, status];
}
