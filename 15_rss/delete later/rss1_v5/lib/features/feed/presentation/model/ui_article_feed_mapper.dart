import 'package:injectable/injectable.dart';

import '../../../../core/utils/ui_model_mapper.dart';
import '../../domain/entities/dm_article_feed.dart';
import 'ui_article_feed.dart';

@injectable
class UiCharacterMapper extends UiModelMapper<Article, UiArticleList> {
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
