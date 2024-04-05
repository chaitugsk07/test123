part of 'get_all_bookmarked_bloc.dart';

@immutable
abstract class GetAllBookmarkedEvent extends Equatable {
  const GetAllBookmarkedEvent();
  @override
  List<Object?> get props => [];
}

class GetAllBookmarkedFetch extends GetAllBookmarkedEvent {}

class GetAllBookmarkedRefresh extends GetAllBookmarkedEvent {}
