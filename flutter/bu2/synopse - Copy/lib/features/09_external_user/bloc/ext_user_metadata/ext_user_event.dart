part of 'ext_user_bloc.dart';

@immutable
abstract class ExtUserEvent extends Equatable {
  const ExtUserEvent();
  @override
  List<Object?> get props => [];
}

class ExtUserFetch extends ExtUserEvent {
  final String account;

  const ExtUserFetch({required this.account});
}
