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

import '../../features/02_article_feed/data/03_mapper/article_feed_mapper.dart'
    as _i3;
import '../../features/02_article_feed/data/04_source/article_feed_services.dart'
    as _i5;
import '../../features/02_article_feed/data/06_repositories/article_feed_repo.dart'
    as _i7;
import '../../features/02_article_feed/domain/05_repositories/articles_feed_repo.dart'
    as _i6;
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
    gh.factory<_i3.ArticleFeedListMapper>(() => _i3.ArticleFeedListMapper());
    gh.factory<_i3.ArticleFeedMapper>(() => _i3.ArticleFeedMapper());
    gh.singleton<_i4.GraphQLService>(_i4.GraphQLService());
    gh.factory<_i5.ArticleFeedServices>(
        () => _i5.ArticleFeedServices(gh<_i4.GraphQLService>()));
    gh.factory<_i6.ArticalsRss1Repository>(() => _i7.ArticalsRss1RepositoryImpl(
          gh<_i5.ArticleFeedServices>(),
          gh<_i3.ArticleFeedListMapper>(),
        ));
    return this;
  }
}
