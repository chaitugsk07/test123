part of 'article_followup_bloc.dart';

class ArticleFollowupState extends Equatable {
  final List<SynopseRealtimeVV10UsersFollowUp> synopseRealtimeVV10UsersFollowUp;
  final ArticleFollowupStatus status;

  const ArticleFollowupState(
      {this.synopseRealtimeVV10UsersFollowUp =
          const <SynopseRealtimeVV10UsersFollowUp>[],
      this.status = ArticleFollowupStatus.initial});

  ArticleFollowupState copyWith({
    List<SynopseRealtimeVV10UsersFollowUp>? synopseRealtimeVV10UsersFollowUp,
    ArticleFollowupStatus? status,
  }) {
    return ArticleFollowupState(
      synopseRealtimeVV10UsersFollowUp: synopseRealtimeVV10UsersFollowUp ??
          this.synopseRealtimeVV10UsersFollowUp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseRealtimeVV10UsersFollowUp, status];
}
