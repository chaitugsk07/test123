part of 'get_all_nologin_bloc.dart';

@immutable
abstract class GetAllNoLoginEvent extends Equatable {
  const GetAllNoLoginEvent();
  @override
  List<Object?> get props => [];
}

class GetAllNoLoginFetch extends GetAllNoLoginEvent {}

class GetAllNoLoginRefresh extends GetAllNoLoginEvent {}
