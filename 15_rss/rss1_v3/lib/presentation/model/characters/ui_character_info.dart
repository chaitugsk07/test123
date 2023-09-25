import 'package:rss1_v3/presentation/model/ui_model.dart';

class UiCharacterInfo extends UIModel {
  String? id, name, image, status, species, gender, origin, location;

  UiCharacterInfo(this.id, this.name, this.image, this.status, this.species,
      this.gender, this.origin, this.location);
}
