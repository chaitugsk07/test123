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

import '../../feed/06_data_mapper/articlerss1_mapper.dart' as _i5;
import '../../feed/08_domain_source/articlesrss1_service.dart' as _i6;
import '../../feed/10_domain_repositories/articlesrss1_repo.dart' as _i8;
import '../../feed/12_data_repositories/articlesrss1_repo_impl.dart' as _i9;
import '../../feed/15_domain_usecase/get_articlesrss1_usecase.dart' as _i3;
import '../../feed/17_data_usecase/articlesrss1_module.dart' as _i10;
import '../../feed/20_presentation_mapping/ui_articlesrss1_mapping.dart' as _i7;
import '../graphql/graphql_service.dart' as _i4;

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
    gh.factory<_i3.GetArticleRss1ListUseCase>(
        () => useCaseModule.getRickMortyCharactersUseCase);
    gh.singleton<_i4.GraphQLService>(_i4.GraphQLService());
    gh.factory<_i5.Rss1ArticleMapper>(() => _i5.Rss1ArticleMapper());
    gh.factory<_i6.RssFeedServices>(
        () => _i6.RssFeedServices(gh<_i4.GraphQLService>()));
    gh.factory<_i7.UiArticlesRss1Mapper>(() => _i7.UiArticlesRss1Mapper());
    gh.factory<_i5.Rss1ArticleListMapper>(
        () => _i5.Rss1ArticleListMapper(gh<_i5.Rss1ArticleMapper>()));
    gh.factory<_i8.ArticalsRss1Repository>(() => _i9.ArticalsRss1RepositoryImpl(
          gh<_i6.RssFeedServices>(),
          gh<_i5.Rss1ArticleListMapper>(),
        ));
    return this;
  }
}

class _$UseCaseModule extends _i10.UseCaseModule {}
