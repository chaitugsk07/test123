import 'dart:async';

import 'package:rss1_v3/core/clean_architecture/usecase.dart';
import 'package:rss1_v3/domain/entities/api_response.dart';
import 'package:rss1_v3/domain/entities/characters/dm_character_info.dart';
import 'package:rss1_v3/domain/repositories/characters/characters_repo.dart';

import '../validations.dart';

class GetCharacterInfoUseCase
    extends UseCase<GetCharacterInfoUseCaseResponse, int> {
  final CharactersRepository repo;

  GetCharacterInfoUseCase(this.repo);

  @override
  Future<Stream<GetCharacterInfoUseCaseResponse>> buildUseCaseStream(
      int? page) async {
    final controller = StreamController<GetCharacterInfoUseCaseResponse>();
    try {
      if (page != null) {
        // Fetch from repository
        final characterInfo = await repo.getCharacterInfo(page);
        // Adding it triggers the .onNext() in the `Observer`
        controller.add(GetCharacterInfoUseCaseResponse(characterInfo));
        logger.finest('GetCharacterInfoUseCase successful.');
        controller.close();
      } else {
        logger.severe('page is null.');
        controller.addError(InvalidRequestException());
      }
    } catch (e) {
      logger.severe('GetCharacterInfoUseCase failure: $e');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetCharacterInfoUseCaseResponse {
  final ApiResponse<CharacterInfo> characterInfo;

  GetCharacterInfoUseCaseResponse(this.characterInfo);
}
