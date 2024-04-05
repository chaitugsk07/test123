import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_tag_root.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'root_tags_event.dart';
part 'root_tags_state.dart';

class RootTagsBloc extends Bloc<RootTagsEvent, RootTagsState> {
  final RssFeedServicesFeed _rssFeedServices;

  RootTagsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const RootTagsState()) {
    // Initial Event
    on<RootTagsFetch>(
      _onRootTagsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onRootTagsFetch(
      RootTagsFetch event, Emitter<RootTagsState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getrootTags();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV4TagsHierarchyRootForYou:
              List.of(state.synopseArticlesTV4TagsHierarchyRootForYou)
                ..addAll(articles),
          hasReachedMax: false,
          status: RootTagsStatus.success,
        ),
      );
    }
  }
}

enum RootTagsStatus {
  initial,
  success,
  error,
}
