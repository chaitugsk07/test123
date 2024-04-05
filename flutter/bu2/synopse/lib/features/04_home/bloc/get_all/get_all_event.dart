part of 'get_all_bloc.dart';

@immutable
abstract class GetAllEvent extends Equatable {
  const GetAllEvent();
  @override
  List<Object?> get props => [];
}

class GetAllFetch extends GetAllEvent {}

class GetAllRefresh extends GetAllEvent {}
