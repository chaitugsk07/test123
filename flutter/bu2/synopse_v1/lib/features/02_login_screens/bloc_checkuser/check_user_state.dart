part of 'check_user_bloc.dart';

class CheckUserState extends Equatable {
  final CheckUserStatus status;
  const CheckUserState({required this.status});

  CheckUserState copyWith({CheckUserStatus? status}) {
    return CheckUserState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
