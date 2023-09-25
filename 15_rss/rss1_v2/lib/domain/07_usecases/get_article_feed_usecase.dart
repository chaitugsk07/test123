import 'dart:async';

import 'package:rss1_v2/core/clean_architecture/usecase.dart';
import 'package:rss1_v2/core/utils/api_response.dart';
import 'package:rss1_v2/core/utils/validations.dart';
import 'package:rss1_v2/domain/02_entities/feed/artical_feed.dart';
import 'package:rss1_v2/domain/05_repositories/feed/articles_feed_repo.dart';

class ArticleRss1ListReqParams {
  final int? limit;
  final int? offset;

  const ArticleRss1ListReqParams({required this.limit, required this.offset});
}

class ArticleRss1ListUseCaseResponse {
  final ApiResponse<Rss1ArticalList> rss1ArticleList;

  ArticleRss1ListUseCaseResponse(this.rss1ArticleList);
}

class GetArticleRss1ListUseCase
    extends UseCase<ArticleRss1ListUseCaseResponse, ArticleRss1ListReqParams> {
  final ArticalsRss1Repository repo;

  GetArticleRss1ListUseCase(this.repo);

  @override
  Future<Stream<ArticleRss1ListUseCaseResponse>> buildUseCaseStream(
      ArticleRss1ListReqParams? params) async {
    final controller = StreamController<ArticleRss1ListUseCaseResponse>();
    try {
      if (params != null) {
        // Fetch from repository
        final articlesRss1List = await repo.getArticlesRss1List(
            params.limit ?? 0, params.offset ?? 0);
        // Adding it triggers the .onNext() in the `Observer`
        controller.add(ArticleRss1ListUseCaseResponse(articlesRss1List));
        logger.finest('GetArticleRss1ListUseCase successful.');
        controller.close();
      } else {
        logger.severe('page is null.');
        controller.addError(InvalidRequestException());
      }
    } catch (e) {
      logger.severe('GetArticleRss1ListUseCase failure.');
      controller.addError(e);
    }
    return controller.stream;
  }
}
