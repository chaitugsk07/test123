part of 'get_all_liked_bloc.dart';

@immutable
abstract class GetAllLikedEvent extends Equatable {
  const GetAllLikedEvent();
  @override
  List<Object?> get props => [];
}

class GetAllLikedFetch extends GetAllLikedEvent {
  final String account;

  const GetAllLikedFetch({required this.account});
}

class GetAllLikedRefresh extends GetAllLikedEvent {
  final String account;

  const GetAllLikedRefresh({required this.account});
}
