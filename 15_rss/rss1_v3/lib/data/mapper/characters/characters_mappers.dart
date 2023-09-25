import 'package:injectable/injectable.dart';
import 'package:rss1_v3/data/mapper/entity_mapper.dart';
import 'package:rss1_v3/data/models/characters/dt_character.dart';
import 'package:rss1_v3/data/models/characters/dt_character_list.dart';
import 'package:rss1_v3/domain/entities/characters/dm_character.dart';

@injectable
class CharacterListMapper
    extends EntityMapper<CharacterList, DTCharactersList> {
  CharacterListMapper(this.characterMapper);

  CharacterMapper characterMapper;

  @override
  DTCharactersList mapToData(CharacterList model) {
    return DTCharactersList(
      model.characterList.map((e) => characterMapper.mapToData(e)).toList(),
    );
  }

  @override
  CharacterList mapToDomain(DTCharactersList entity) {
    return CharacterList(entity.charactersList
        .map((e) => characterMapper.mapToDomain(e))
        .toList());
  }
}

@injectable
class CharacterMapper extends EntityMapper<Character, DTCharacter> {
  @override
  DTCharacter mapToData(Character model) {
    return DTCharacter(
      model.id,
      model.name,
      model.image,
      model.status,
      model.species,
    );
  }

  @override
  Character mapToDomain(DTCharacter entity) {
    return Character(
      entity.id,
      entity.name,
      entity.image,
      entity.status,
      entity.species,
    );
  }
}
