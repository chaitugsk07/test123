part of 'user_vector_bloc.dart';

class UserVectorState extends Equatable {
  final UserVectorStatus status;

  const UserVectorState({this.status = UserVectorStatus.initial});

  UserVectorState copyWith({
    bool? hasReachedMax,
    UserVectorStatus? status,
  }) {
    return UserVectorState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
