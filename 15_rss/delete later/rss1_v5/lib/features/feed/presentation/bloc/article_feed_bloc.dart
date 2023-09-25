import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rss1_v5/core/utils/api_response.dart' as api_response;

import '../model/ui_article_feed.dart';

part 'article_feed_event.dart';
part 'article_feed_state.dart';

class ArticleFeedBloc extends Bloc<ArticleFeedEvent, ArticleFeedState> {
  ArticleFeedBloc() : super(ArticleFeedInitial()) {
    add(LoadArticles());
  }

  final _uiMapper = GetIt.I.get<UiCharacterMapper>();
  final _getRickMortyCharactersUseCase =
      GetIt.I.get<GetRickMortyCharactersUseCase>();
  final List<UiCharacter> _charactersToDisplayInUi = [];
  late bool _isFilterRequest = false;

  late String nameFilter = '';
  bool isPageLoadInProgress = false;
  int page = 1;

  @override
  Stream<CharactersState> mapEventToState(
    CharactersEvent event,
  ) async* {
    if (event is LoadCharacters) {
      yield CharactersLoading();
      _isFilterRequest = nameFilter.isNotEmpty;
      _getRickMortyCharactersUseCase.perform(
        handleResponse,
        error,
        complete,
        CharacterListReqParams(page: page, nameFilter: nameFilter),
      );
    } else if (event is FilterCharacters) {
      nameFilter = event.nameFilter;
      page = 1;
      add(LoadCharacters());
    }
  }

  /// Handle response data
  void handleResponse(CharacterListUseCaseResponse? response) {
    final responseData = response?.characterList;
    if (responseData == null) {
      add(CharactersFailure(
          exception: Exception("Couldn't fetch characters!")));
    } else {
      if (responseData is api_response.Failure) {
        add(CharactersFailure(
            exception: (responseData as api_response.Failure).error));
      } else if (responseData is api_response.Success) {
        final characters = responseData as api_response.Success;
        final uiCharacters =
            _uiMapper.mapToPresentation(characters.data as CharacterList);
        if (uiCharacters.characters.isNotEmpty) {
          if (_isFilterRequest) {
            _charactersToDisplayInUi.clear();
          }
          _charactersToDisplayInUi.addAll(uiCharacters.characters);
        }
        add(CharactersSuccess(data: _charactersToDisplayInUi));
      }
    }
    isPageLoadInProgress = false;
  }

  void complete() {
    log('Fetching characters list is complete.');
  }

  void error(Object e) {
    log('Error in fetching characters list');
    if (e is Exception) {
      log('Error in fetching characters list: $e');
      add(CharactersFailure(exception: e));
    }
  }

  @override
  Future<void> close() {
    _getRickMortyCharactersUseCase.dispose();
    return super.close();
  }
}
