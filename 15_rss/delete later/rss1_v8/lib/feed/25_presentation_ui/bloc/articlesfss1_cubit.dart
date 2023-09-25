import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rss1_v8/core/utils/ui_state.dart';
import 'package:rss1_v8/core/utils/api_response.dart' as api_response;
import 'package:rss1_v8/feed/04_domain_entities/dm_articlerss1.dart';
import 'package:rss1_v8/feed/15_domain_usecase/get_articlesrss1_usecase.dart';
import 'package:rss1_v8/feed/20_presentation_mapping/ui_articlesrss1.dart';
import 'package:rss1_v8/feed/20_presentation_mapping/ui_articlesrss1_mapping.dart';

class ArticlesRss1Cubit extends Cubit<UiState<List<UiArticleRss1>>> {
  ArticlesRss1Cubit() : super(Initial()) {
    loadArticlesRss1();
  }

  final _uiMapper = GetIt.I.get<UiArticlesRss1Mapper>();
  final _getArticlesRss1ListUseCase = GetIt.I.get<GetArticleRss1ListUseCase>();
  final List<UiArticleRss1> _articlesRss1ToDisplayInUi = [];

  bool isPageLoadInProgress = false;
  int limit = 2;
  int offset = 0;

  /// Load Rick & Morty characters
  void loadArticlesRss1() {
    emit(Loading());

    _getArticlesRss1ListUseCase.perform(
      handleResponse,
      error,
      complete,
      ArticleRss1ListReqParams(limit: limit, offset: offset),
    );
  }

  /// Handle response data
  void handleResponse(ArticleRss1ListUseCaseResponse? response) {
    final responseData = response?.rss1ArticleList;
    if (responseData == null) {
      emit(Failure(exception: Exception("Couldn't fetch data!")));
    } else {
      if (responseData is api_response.Failure) {
        emit(Failure(exception: (responseData as api_response.Failure).error));
      } else if (responseData is api_response.Success) {
        final articlesRss1 = responseData as api_response.Success;
        final uiArticlesRss1 =
            _uiMapper.mapToPresentation(articlesRss1.data as Rss1ArticleList);
        if (uiArticlesRss1.uiArticleRss1.isNotEmpty) {
          if (_isFilterRequest) {
            _articlesRss1ToDisplayInUi.clear();
          }
          _articlesRss1ToDisplayInUi.addAll(uiArticlesRss1.uiArticleRss1);
        }
        emit(Success(data: _articlesRss1ToDisplayInUi));
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
      emit(Failure(exception: e));
    }
  }

  @override
  Future<void> close() {
    _getArticlesRss1ListUseCase.dispose();
    return super.close();
  }
}
