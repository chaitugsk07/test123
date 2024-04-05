part of 'user_levels_bloc.dart';

class UserLevelsState extends Equatable {
  final List<SynopseRealtimeTUserLevel> synopseRealtimeTUserLevel;
  final bool hasReachedMax;
  final UserLevelsStatus status;

  const UserLevelsState(
      {this.synopseRealtimeTUserLevel = const <SynopseRealtimeTUserLevel>[],
      this.hasReachedMax = false,
      this.status = UserLevelsStatus.initial});

  UserLevelsState copyWith({
    List<SynopseRealtimeTUserLevel>? synopseRealtimeTUserLevel,
    bool? hasReachedMax,
    UserLevelsStatus? status,
  }) {
    return UserLevelsState(
      synopseRealtimeTUserLevel:
          synopseRealtimeTUserLevel ?? this.synopseRealtimeTUserLevel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseRealtimeTUserLevel, hasReachedMax, status];
}
