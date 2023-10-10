import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/05_article_detail/01_model_repo/mod_article_rss_links.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/source_articlerss1_api.dart';

part 'articles_original_event.dart';
part 'articles_original_state.dart';

class ArticlesOriginalBloc
    extends Bloc<ArticlesOriginalEvent, ArticlesOriginalState> {
  final RssFeedServicesFeedDetails _rssFeedServicesFeedDetails;

  ArticlesOriginalBloc(
      {required RssFeedServicesFeedDetails rssFeedServicesFeedDetails})
      : _rssFeedServicesFeedDetails = rssFeedServicesFeedDetails,
        super(const ArticlesOriginalState()) {
    // Initial Event
    on<ArticlesOriginalFetch>(
      _onArticlesRss1Fetch,
      transformer: droppable(),
    );
  }
  FutureOr<void> _onArticlesRss1Fetch(
      ArticlesOriginalFetch event, Emitter<ArticlesOriginalState> emit) async {
    final articles = await _rssFeedServicesFeedDetails
        .getOriginalArticleRssFeed(event.articleIds);
    return emit(
      state.copyWith(
        articlesTV1Rss1Artical: articles,
        hasReachedMax: false,
        status: ArticlesOriginalStatus.success,
      ),
    );
  }
}

enum ArticlesOriginalStatus {
  initial,
  success,
  error,
}
