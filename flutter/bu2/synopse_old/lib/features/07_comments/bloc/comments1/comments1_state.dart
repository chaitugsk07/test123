part of 'comments1_bloc.dart';

class Comments1State extends Equatable {
  final List<SynopseRealtimeVUserArticleComment>
      synopseRealtimeVUserArticleComment;
  final bool hasReachedMax;
  final Comments1Status status;

  const Comments1State(
      {this.synopseRealtimeVUserArticleComment =
          const <SynopseRealtimeVUserArticleComment>[],
      this.hasReachedMax = false,
      this.status = Comments1Status.initial});

  Comments1State copyWith({
    List<SynopseRealtimeVUserArticleComment>?
        synopseRealtimeVUserArticleComment,
    bool? hasReachedMax,
    Comments1Status? status,
  }) {
    return Comments1State(
      synopseRealtimeVUserArticleComment: synopseRealtimeVUserArticleComment ??
          this.synopseRealtimeVUserArticleComment,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeVUserArticleComment, hasReachedMax, status];
}
