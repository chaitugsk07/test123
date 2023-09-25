import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:rss1_v8/feed/15_domain_usecase/get_articlesrss1_usecase.dart';

@module
abstract class UseCaseModule {
  GetArticleRss1ListUseCase get getRickMortyCharactersUseCase =>
      GetArticleRss1ListUseCase(GetIt.instance.get());
}
