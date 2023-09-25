// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/03_mapper/feed/article_feed_mapper.dart' as _i3;
import '../../data/04_sources/feed/article_feed_services.dart' as _i6;
import '../../data/04_sources/graphql/graphql_service.dart' as _i5;
import '../../data/06_repositories/feed/article_feed_repo.dart' as _i8;
import '../../data/08_usecases/usecases_module.dart' as _i9;
import '../../domain/05_repositories/feed/articles_feed_repo.dart' as _i7;
import '../../domain/07_usecases/get_article_feed_usecase.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initGetIt({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final useCaseModule = _$UseCaseModule();
    gh.factory<_i3.ArticleFeedMapper>(() => _i3.ArticleFeedMapper());
    gh.factory<_i4.GetArticleRss1ListUseCase>(
        () => useCaseModule.getArticleRss1ListUseCase);
    gh.singleton<_i5.GraphQLService>(_i5.GraphQLService());
    gh.factory<_i3.ArticleFeedListMapper>(
        () => _i3.ArticleFeedListMapper(gh<_i3.ArticleFeedMapper>()));
    gh.factory<_i6.ArticleFeedServices>(
        () => _i6.ArticleFeedServices(gh<_i5.GraphQLService>()));
    gh.factory<_i7.ArticalsRss1Repository>(() => _i8.ArticalsRss1RepositoryImpl(
          gh<_i6.ArticleFeedServices>(),
          gh<_i3.ArticleFeedListMapper>(),
        ));
    return this;
  }
}

class _$UseCaseModule extends _i9.UseCaseModule {}
