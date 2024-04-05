import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'comments1_article_event.dart';
part 'comments1_article_state.dart';

class Comments1ArticleBloc
    extends Bloc<Comments1ArticleEvent, Comments1ArticleState> {
  final RssFeedServicesFeed _rssFeedServices;

  Comments1ArticleBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const Comments1ArticleState()) {
    // Initial Event
    on<Comments1ArticleFetch>(
      _onComments1ArticleFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onComments1ArticleFetch(
      Comments1ArticleFetch event, Emitter<Comments1ArticleState> emit) async {
    if (state.hasReachedMax) return;
    final articles =
        await _rssFeedServices.getArticleForComment(event.articleGroupId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail:
              List.of(state.synopseArticlesTV4ArticleGroupsL2Detail)
                ..addAll(articles),
          hasReachedMax: false,
          status: Comments1ArticleStatus.success,
        ),
      );
    }
  }
}

enum Comments1ArticleStatus {
  initial,
  success,
  error,
}
