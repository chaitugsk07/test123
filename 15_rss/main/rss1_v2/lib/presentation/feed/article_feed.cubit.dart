import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rss1_v2/domain/02_entities/feed/artical_feed.dart';
import 'package:rss1_v2/domain/07_usecases/get_article_feed_usecase.dart';
import 'package:rss1_v2/presentation/feed/models/ui_article_feed.dart';
import 'package:rss1_v2/core/utils/api_response.dart' as api_response;
import 'package:rss1_v2/core/utils/ui_state.dart';
import 'package:rss1_v2/presentation/feed/models/ui_article_feed_mapper.dart';

class ArticleFeedCubit extends Cubit<UiState<List<UiRss1Artical>>> {
  ArticleFeedCubit() : super(Initial()) {
    loadCharacters();
  }

  final _uiMapper = GetIt.I.get<UiAticleFeedListMapper>();
  final _getArticleRss1ListUseCase = GetIt.I.get<GetArticleRss1ListUseCase>();
  final List<UiRss1Artical> _articlesToDisplayInUi = [];
  late bool _isFilterRequest = false;
  late String nameFilter = '';
  bool isPageLoadInProgress = false;
  int page = 0;

  /// Load Articles Feed characters
  void loadCharacters() {
    if (page == 0) {
      emit(Loading());
    }
    _isFilterRequest = nameFilter.isNotEmpty;
    _getArticleRss1ListUseCase.perform(
      handleResponse,
      error,
      complete,
      ArticleRss1ListReqParams(
          limit: page == 0 ? 20 : 10,
          offset: page == 0 ? page * 10 : 10 + page * 10),
    );
  }

  void handleResponse(ArticleRss1ListUseCaseResponse? response) {
    final responseData = response?.rss1ArticleList;
    if (responseData == null) {
      emit(Failure(exception: Exception("Couldn't fetch characters!")));
    } else {
      if (responseData is api_response.Failure) {
        emit(Failure(exception: (responseData as api_response.Failure).error));
      } else if (responseData is api_response.Success) {
        final articles = responseData as api_response.Success;
        final uiArticles =
            _uiMapper.mapToPresentation(articles.data as Rss1ArticalList);
        if (uiArticles.rss1ArticalList.isNotEmpty) {
          if (_isFilterRequest) {
            _articlesToDisplayInUi.clear();
          }
          _articlesToDisplayInUi.addAll(uiArticles.rss1ArticalList);
        }
        emit(Success(data: _articlesToDisplayInUi));
      }
    }
    isPageLoadInProgress = false;
  }

  void complete() {
    log('Fetching articles list is complete.');
  }

  void error(Object e) {
    log('Error in fetching articles list');
    if (e is Exception) {
      log('Error in fetching articles list: $e');
      emit(Failure(exception: e));
    }
  }

  @override
  Future<void> close() {
    _getArticleRss1ListUseCase.dispose();
    return super.close();
  }
}
