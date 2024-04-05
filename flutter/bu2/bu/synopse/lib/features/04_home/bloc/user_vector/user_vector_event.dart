part of 'user_vector_bloc.dart';

@immutable
abstract class UserVectorEvent extends Equatable {
  const UserVectorEvent();
  @override
  List<Object?> get props => [];
}

class UserVectorFetch extends UserVectorEvent {}
