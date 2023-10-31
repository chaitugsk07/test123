import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/05_article_detail/01_model_repo/mod_article_detail.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/source_articlerss1_api.dart';

part 'articles_detail_rss1_event.dart';
part 'articles_detail_rss1_state.dart';

class ArticlesDetailBloc extends Bloc<ArticleDetailEvent, ArticleDetailState> {
  final RssFeedServicesFeedDetails _rssFeedServicesFeedDetails;

  ArticlesDetailBloc(
      {required RssFeedServicesFeedDetails rssFeedServicesFeedDetails})
      : _rssFeedServicesFeedDetails = rssFeedServicesFeedDetails,
        super(const ArticleDetailState()) {
    // Initial Event
    on<ArticlesDetailFetch>(
      _onArticlesRss1Fetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesRss1Fetch(
      ArticlesDetailFetch event, Emitter<ArticleDetailState> emit) async {
    final articles = await _rssFeedServicesFeedDetails
        .getArticleRssFeed(event.articleGroupId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          articlesTV1ArticalsGroupsL1DetailSummary:
              List.of(state.articlesTV1ArticalsGroupsL1DetailSummary)
                ..addAll(articles),
          hasReachedMax: false,
          status: ArticlesRss1StatusDetail.success,
        ),
      );
    }
  }
}

enum ArticlesRss1StatusDetail {
  initial,
  success,
  error,
}
