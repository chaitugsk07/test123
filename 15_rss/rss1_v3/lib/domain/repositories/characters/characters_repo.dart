import 'dart:async';

import 'package:rss1_v3/domain/entities/api_response.dart';
import 'package:rss1_v3/domain/entities/characters/dm_character.dart';
import 'package:rss1_v3/domain/entities/characters/dm_character_info.dart';

abstract class CharactersRepository {
  Future<ApiResponse<CharacterList>> getRickAndMortyCharacters(
      int page, String nameFilter);

  Future<ApiResponse<CharacterInfo>> getCharacterInfo(int id);
}
