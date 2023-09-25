import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:rss1_v2/domain/07_usecases/get_article_feed_usecase.dart';

@module
abstract class UseCaseModule {
  GetArticleRss1ListUseCase get getArticleRss1ListUseCase =>
      GetArticleRss1ListUseCase(GetIt.instance.get());
}
