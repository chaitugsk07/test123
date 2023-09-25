import 'package:injectable/injectable.dart';
import 'package:rss1_v3/domain/entities/characters/dm_character_info.dart';
import 'package:rss1_v3/domain/mapper/ui_model_mapper.dart';
import 'package:rss1_v3/presentation/model/characters/ui_character_info.dart';

@injectable
class UiCharacterInfoMapper
    extends UiModelMapper<CharacterInfo, UiCharacterInfo> {
  @override
  CharacterInfo mapToDomain(UiCharacterInfo modelItem) {
    return CharacterInfo(
        modelItem.id,
        modelItem.name,
        modelItem.image,
        modelItem.status,
        modelItem.species,
        modelItem.gender,
        Origin("", modelItem.origin),
        Location("", modelItem.location));
  }

  @override
  UiCharacterInfo mapToPresentation(CharacterInfo model) {
    return UiCharacterInfo(model.id, model.name, model.image, model.status,
        model.species, model.gender, model.origin?.name, model.location?.name);
  }
}
