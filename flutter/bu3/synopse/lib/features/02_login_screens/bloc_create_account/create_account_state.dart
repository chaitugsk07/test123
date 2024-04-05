part of 'create_account_bloc.dart';

class CreateAccountState extends Equatable {
  final CreateAccountStatus status;

  const CreateAccountState({required this.status});

  CreateAccountState copyWith({CreateAccountStatus? status}) {
    return CreateAccountState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
