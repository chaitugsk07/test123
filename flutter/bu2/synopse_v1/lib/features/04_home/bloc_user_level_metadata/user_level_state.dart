part of 'user_level_bloc.dart';

class UserLevelState extends Equatable {
  final List<SynopseRealtimeVUserLevel> synopseRealtimeVUserLevel;
  final bool hasReachedMax;
  final UserLevelStatus status;

  const UserLevelState(
      {this.synopseRealtimeVUserLevel = const <SynopseRealtimeVUserLevel>[],
      this.hasReachedMax = false,
      this.status = UserLevelStatus.initial});

  UserLevelState copyWith({
    List<SynopseRealtimeVUserLevel>? synopseRealtimeVUserLevel,
    bool? hasReachedMax,
    UserLevelStatus? status,
  }) {
    return UserLevelState(
      synopseRealtimeVUserLevel:
          synopseRealtimeVUserLevel ?? this.synopseRealtimeVUserLevel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseRealtimeVUserLevel, hasReachedMax, status];
}
