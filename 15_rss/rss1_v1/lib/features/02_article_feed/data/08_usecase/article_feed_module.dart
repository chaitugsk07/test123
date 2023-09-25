import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:rss1_v1/features/02_article_feed/domain/07_usecase/get_article_feed_usecase.dart';

@module
abstract class UseCaseModule {
  GetArticleRss1ListUseCase get getArticleRss1ListUseCase =>
      GetArticleRss1ListUseCase(GetIt.instance.get());
}
