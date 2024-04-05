part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchFetch extends SearchEvent {
  final String search;
  const SearchFetch({required this.search});

  @override
  List<Object?> get props => [search];
}
