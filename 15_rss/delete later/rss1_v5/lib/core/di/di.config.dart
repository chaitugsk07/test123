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

import '../../features/feed/data/mapper/article_feed_mapper.dart' as _i8;
import '../../features/feed/data/repositories/articale_feed_repo_impl.dart'
    as _i7;
import '../../features/feed/data/source/rss_feed_service.dart' as _i4;
import '../../features/feed/domain/repositories/article_feed_repo.dart' as _i6;
import '../../features/feed/presentation/model/ui_article_feed_mapper.dart'
    as _i5;
import '../graphql/graphql_service.dart' as _i3;

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
    gh.singleton<_i3.GraphQLService>(_i3.GraphQLService());
    gh.factory<_i4.RssFeedServices>(
        () => _i4.RssFeedServices(gh<_i3.GraphQLService>()));
    gh.factory<_i5.UiCharacterMapper>(() => _i5.UiCharacterMapper());
    gh.factory<_i6.ArticleFeedRepository>(() => _i7.ArticleFeedRepositoryImpl(
          gh<_i4.RssFeedServices>(),
          gh<_i8.ArticleMapper>(),
        ));
    return this;
  }
}
