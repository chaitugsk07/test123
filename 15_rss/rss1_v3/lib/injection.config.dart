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

import 'data/mapper/characters/character_info_mapper.dart' as _i3;
import 'data/mapper/characters/characters_mappers.dart' as _i4;
import 'data/mapper/locations/locations_mappers.dart' as _i9;
import 'data/repositories/characters/characters_repo_impl.dart' as _i15;
import 'data/repositories/locations/locations_repo_impl.dart' as _i17;
import 'data/sources/network/graphql/graphql_service.dart' as _i8;
import 'data/sources/network/rickmorty/rick_morty_services.dart' as _i10;
import 'data/usecases/usecase_module.dart' as _i18;
import 'domain/repositories/characters/characters_repo.dart' as _i14;
import 'domain/repositories/locations/locations_repo.dart' as _i16;
import 'domain/use_cases/get_character_info_usecase.dart' as _i5;
import 'domain/use_cases/get_locations_usecase.dart' as _i6;
import 'domain/use_cases/get_rick_morty_characters_usecase.dart' as _i7;
import 'presentation/model/characters/ui_character_info_mapper.dart' as _i11;
import 'presentation/model/characters/ui_character_mapper.dart' as _i12;
import 'presentation/model/locations/ui_location_mapper.dart' as _i13;

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
    gh.factory<_i3.CharacterInfoMapper>(() => _i3.CharacterInfoMapper());
    gh.factory<_i4.CharacterMapper>(() => _i4.CharacterMapper());
    gh.factory<_i5.GetCharacterInfoUseCase>(
        () => useCaseModule.getCharacterInfoUseCase);
    gh.factory<_i6.GetLocationsUseCase>(
        () => useCaseModule.getLocationsUseCase);
    gh.factory<_i7.GetRickMortyCharactersUseCase>(
        () => useCaseModule.getRickMortyCharactersUseCase);
    gh.singleton<_i8.GraphQLService>(_i8.GraphQLService());
    gh.factory<_i9.LocationMapper>(() => _i9.LocationMapper());
    gh.factory<_i10.RickMortyServices>(
        () => _i10.RickMortyServices(gh<_i8.GraphQLService>()));
    gh.factory<_i11.UiCharacterInfoMapper>(() => _i11.UiCharacterInfoMapper());
    gh.factory<_i12.UiCharacterMapper>(() => _i12.UiCharacterMapper());
    gh.factory<_i13.UiLocationMapper>(() => _i13.UiLocationMapper());
    gh.factory<_i4.CharacterListMapper>(
        () => _i4.CharacterListMapper(gh<_i4.CharacterMapper>()));
    gh.factory<_i14.CharactersRepository>(() => _i15.CharactersRepositoryImpl(
          gh<_i10.RickMortyServices>(),
          gh<_i4.CharacterListMapper>(),
          gh<_i3.CharacterInfoMapper>(),
        ));
    gh.factory<_i9.LocationListMapper>(
        () => _i9.LocationListMapper(gh<_i9.LocationMapper>()));
    gh.factory<_i16.LocationsRepository>(() => _i17.LocationsRepositoryImpl(
          gh<_i10.RickMortyServices>(),
          gh<_i9.LocationListMapper>(),
        ));
    return this;
  }
}

class _$UseCaseModule extends _i18.UseCaseModule {}
