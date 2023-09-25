import 'package:injectable/injectable.dart';
import 'package:rss1_v8/core/utils/api_response.dart';
import 'package:rss1_v8/feed/02_data_model/dt_articalsrss1_list.dart';
import 'package:rss1_v8/feed/04_domain_entities/dm_articlerss1.dart';
import 'package:rss1_v8/feed/06_data_mapper/articlerss1_mapper.dart';
import 'package:rss1_v8/feed/08_domain_source/articlesrss1_service.dart';
import 'package:rss1_v8/feed/10_domain_repositories/articlesrss1_repo.dart';

@Injectable(as: ArticalsRss1Repository)
class ArticalsRss1RepositoryImpl extends ArticalsRss1Repository {
  ArticalsRss1RepositoryImpl(
    this.services,
    this.rss1ArticleListMapper,
  );
  final RssFeedServices services;
  final Rss1ArticleListMapper rss1ArticleListMapper;
  @override
  Future<ApiResponse<Rss1ArticleList>> getArticlesRss1List(
      int limit, int offset) async {
    final response = await services.getArticleRssFeed(limit, offset);
    if (response is Success) {
      try {
        final rss1ArticleList =
            (response as Success).data as DTArticalsRss1List;
        return Success(
            data: rss1ArticleListMapper.mapToDomain(rss1ArticleList));
      } on Exception catch (e, _) {
        return Failure(error: e);
      }
    } else {
      return Failure(error: Exception((response as Failure).error));
    }
  }
}
