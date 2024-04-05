part of 'article_details_bloc.dart';

class ArticleDetailsState extends Equatable {
  final List<SynopseArticlesTV3ArticleGroupsL2>
      synopseArticlesTV3ArticleGroupsL2;
  final ArticleDetailsStatus status;

  const ArticleDetailsState(
      {this.synopseArticlesTV3ArticleGroupsL2 =
          const <SynopseArticlesTV3ArticleGroupsL2>[],
      this.status = ArticleDetailsStatus.initial});

  ArticleDetailsState copyWith({
    List<SynopseArticlesTV3ArticleGroupsL2>? synopseArticlesTV3ArticleGroupsL2,
    ArticleDetailsStatus? status,
  }) {
    return ArticleDetailsState(
      synopseArticlesTV3ArticleGroupsL2: synopseArticlesTV3ArticleGroupsL2 ??
          this.synopseArticlesTV3ArticleGroupsL2,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseArticlesTV3ArticleGroupsL2, status];
}
