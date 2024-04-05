part of 'search_last3_bloc.dart';

@immutable
abstract class SearchLast3Event extends Equatable {
  const SearchLast3Event();
  @override
  List<Object?> get props => [];
}

class SearchLast3Fetch extends SearchLast3Event {
  const SearchLast3Fetch();
}
