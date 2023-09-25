import 'package:injectable/injectable.dart';
import 'package:rss1_v5/core/utils/api_response.dart';
import 'package:rss1_v5/features/feed/domain/entities/dm_article_feed.dart';

import '../../domain/repositories/article_feed_repo.dart';
import '../mapper/article_feed_mapper.dart';
import '../models/dt_artical_feed_list.dart';
import '../source/rss_feed_service.dart';

@Injectable(as: ArticleFeedRepository)
class ArticleFeedRepositoryImpl implements ArticleFeedRepository {
  ArticleFeedRepositoryImpl(
    this.services,
    this.articleMapper,
  );
  final RssFeedServices services;
  final ArticleMapper articleMapper;

  @override
  Future<ApiResponse<ArticleFeedList>> getArticleFeedList(int limit, int offset) async {
    final response = await services.getArticleRssFeed(limit, offset);
    if (response is Success) {
      try {
        final aticlefeed = (response).data as DTRss1ArticalsList;
        return Success(data: articleMapper.mapToDomain(aticlefeed));
      } on Exception catch (e, _) {
        return Failure(error: e);
      }
    } else {
      return Failure(error: Exception((response as Failure).error));
    }
  }
}
