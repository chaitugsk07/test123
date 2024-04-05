part of 'check_user_bloc.dart';

@immutable
abstract class CheckUserEvent extends Equatable {
  const CheckUserEvent();
  @override
  List<Object?> get props => [];
}

class CheckUserExistsOrNot extends CheckUserEvent {
  final String type;
  final String email;
  final String id;

  const CheckUserExistsOrNot(
      {required this.type, required this.email, required this.id});

  @override
  List<Object> get props => [type, email, id];
}
