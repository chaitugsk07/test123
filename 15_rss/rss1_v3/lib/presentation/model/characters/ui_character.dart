import 'package:rss1_v3/presentation/model/ui_model.dart';

class UiCharacter extends UIModel {
  String id, name, image, status, species;

  UiCharacter(this.id, this.name, this.image, this.status, this.species);
}

class UiCharacterList extends UIModel {
  List<UiCharacter> characters;

  UiCharacterList(this.characters);
}
