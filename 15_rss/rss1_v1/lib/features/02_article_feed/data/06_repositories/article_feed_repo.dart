import 'package:injectable/injectable.dart';
import 'package:rss1_v1/core/graphql/api_response.dart';
import 'package:rss1_v1/features/02_article_feed/data/01_model/dt_artical_feed_list.dart';
import 'package:rss1_v1/features/02_article_feed/data/03_mapper/article_feed_mapper.dart';
import 'package:rss1_v1/features/02_article_feed/data/04_source/article_feed_services.dart';
import 'package:rss1_v1/features/02_article_feed/domain/02_entity/artical_feed.dart';
import 'package:rss1_v1/features/02_article_feed/domain/05_repositories/articles_feed_repo.dart';

@Injectable(as: ArticalsRss1Repository)
class ArticalsRss1RepositoryImpl extends ArticalsRss1Repository {
  ArticalsRss1RepositoryImpl(
    this.services,
    this.articleFeedListMapper,
  );
  final ArticleFeedServices services;
  final ArticleFeedListMapper articleFeedListMapper;
  @override
  Future<ApiResponse<Rss1ArticalList>> getArticlesRss1List(
      int limit, int offset) async {
    final response = await services.getArticleRssFeed(limit, offset);
    if (response is Success) {
      try {
        final rss1ArticleList = (response as Success).data as DTRss1ArticalList;
        return Success(
            data: articleFeedListMapper.mapToDomain(rss1ArticleList));
      } on Exception catch (e, _) {
        return Failure(error: e);
      }
    } else {
      return Failure(error: Exception((response as Failure).error));
    }
  }
}
