import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_ids.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'article_ids_event.dart';
part 'article_ids_state.dart';

class ArticleIdsBloc extends Bloc<ArticleIdsEvent, ArticleIdsState> {
  final RssFeedServicesFeed _rssFeedServices;

  ArticleIdsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ArticleIdsState()) {
    // Initial Event
    on<ArticleIdsFetch>(
      _articleIdsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _articleIdsFetch(
      ArticleIdsFetch event, Emitter<ArticleIdsState> emit) async {
    final articles = await _rssFeedServices.getArticleIds(event.articleIds);
    if (articles.isEmpty) {
      return emit(state.copyWith(status: ArticleIdsStatus.error));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV1Rss1Article:
              List.of(state.synopseArticlesTV1Rss1Article)..addAll(articles),
          status: ArticleIdsStatus.success,
        ),
      );
    }
  }
}

enum ArticleIdsStatus {
  initial,
  success,
  error,
}
