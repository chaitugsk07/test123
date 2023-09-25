import 'package:injectable/injectable.dart';
import 'package:rss1_v3/domain/entities/characters/dm_character.dart';
import 'package:rss1_v3/domain/mapper/ui_model_mapper.dart';
import 'package:rss1_v3/presentation/model/characters/ui_character.dart';

@injectable
class UiCharacterMapper extends UiModelMapper<CharacterList, UiCharacterList> {
  @override
  CharacterList mapToDomain(UiCharacterList modelItem) {
    return CharacterList(modelItem.characters
        .map((e) => Character(e.id, e.name, e.image, e.status, e.species))
        .toList());
  }

  @override
  UiCharacterList mapToPresentation(CharacterList model) {
    return UiCharacterList(model.characterList
        .map((e) => UiCharacter(e.id, e.name, e.image, e.status, e.species))
        .toList());
  }
}
