import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_details.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';

part 'article_details_no_event.dart';
part 'article_details_no_state.dart';

class ArticleDetailsNoBloc
    extends Bloc<ArticleDetailsNoEvent, ArticleDetailsNoState> {
  final RssFeedServicesFeed _rssFeedServices;

  ArticleDetailsNoBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ArticleDetailsNoState()) {
    // Initial Event
    on<ArticleDetailsNoFetch>(
      _articleDetailsNoFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _articleDetailsNoFetch(
      ArticleDetailsNoFetch event, Emitter<ArticleDetailsNoState> emit) async {
    final articles =
        await _rssFeedServices.getArticleDetailsNo(event.articleGrouppId);
    if (articles.isEmpty) {
      return emit(state.copyWith(status: ArticleDetailsNoStatus.error));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV3ArticleGroupsL2:
              List.of(state.synopseArticlesTV3ArticleGroupsL2)
                ..addAll(articles),
          status: ArticleDetailsNoStatus.success,
        ),
      );
    }
  }
}

enum ArticleDetailsNoStatus {
  initial,
  success,
  error,
}
