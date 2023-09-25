import 'dart:async';

import '../../../../core/clean_architecture/clean_architecture.dart';
import '../../../../core/utils/api_response.dart';
import '../entities/dm_article_feed.dart';
import '../repositories/article_feed_repo.dart';

class ArticleFeedReqParams {
  final int limit;
  final int offset;

  const ArticleFeedReqParams(this.limit, this.offset);
}

class ArticleFeedUseCaseResponse {
  final ApiResponse<Article> articleFeed;

  ArticleFeedUseCaseResponse(this.articleFeed);
}

class GetArticleRssFeedUseCase
    extends UseCase<ArticleFeedUseCaseResponse, ArticleFeedReqParams> {
  final ArticleFeedRepository repo;

  GetArticleRssFeedUseCase(this.repo);

  @override
  Future<Stream<ArticleFeedUseCaseResponse?>> buildUseCaseStream(
      ArticleFeedReqParams? params) async {
    final controller = StreamController<ArticleFeedUseCaseResponse>();
    try {
      // Fetch from repository
      final articlefeed =
          await repo.getArticleFeed(params!.limit, params.offset);
      // Adding it triggers the .onNext() in the `Observer`
      controller.add(ArticleFeedUseCaseResponse(articlefeed));
      logger.finest('GetRickMortyCharactersUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetRickMortyCharactersUseCase failure.');
      controller.addError(e);
    }
    return controller.stream;
  }
}
