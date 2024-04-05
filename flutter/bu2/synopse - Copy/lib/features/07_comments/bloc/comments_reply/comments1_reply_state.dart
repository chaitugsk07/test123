part of 'comments1_reply_bloc.dart';

class Comments1RState extends Equatable {
  final List<SynopseRealtimeVUserArticleComment>
      synopseRealtimeVUserArticleComment;
  final bool hasReachedMax;
  final Comments1RStatus status;

  const Comments1RState(
      {this.synopseRealtimeVUserArticleComment =
          const <SynopseRealtimeVUserArticleComment>[],
      this.hasReachedMax = false,
      this.status = Comments1RStatus.initial});

  Comments1RState copyWith({
    List<SynopseRealtimeVUserArticleComment>?
        synopseRealtimeVUserArticleComment,
    bool? hasReachedMax,
    Comments1RStatus? status,
  }) {
    return Comments1RState(
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
