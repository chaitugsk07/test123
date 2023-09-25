import 'package:injectable/injectable.dart';
import 'package:rss1_v2/core/utils/api_response.dart';
import 'package:rss1_v2/data/01_models/feed/dt_artical_feed_list.dart';
import 'package:rss1_v2/data/03_mapper/feed/article_feed_mapper.dart';
import 'package:rss1_v2/data/04_sources/feed/article_feed_services.dart';
import 'package:rss1_v2/domain/02_entities/feed/artical_feed.dart';
import 'package:rss1_v2/domain/05_repositories/feed/articles_feed_repo.dart';

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
