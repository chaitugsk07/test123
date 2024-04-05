part of 'comments1_r_bloc.dart';

class Comments1R1State extends Equatable {
  final List<SynopseRealtimeVUserArticleComment>
      synopseRealtimeVUserArticleComment;
  final bool hasReachedMax;
  final Comments1R1Status status;

  const Comments1R1State(
      {this.synopseRealtimeVUserArticleComment =
          const <SynopseRealtimeVUserArticleComment>[],
      this.hasReachedMax = false,
      this.status = Comments1R1Status.initial});

  Comments1R1State copyWith({
    List<SynopseRealtimeVUserArticleComment>?
        synopseRealtimeVUserArticleComment,
    bool? hasReachedMax,
    Comments1R1Status? status,
  }) {
    return Comments1R1State(
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
