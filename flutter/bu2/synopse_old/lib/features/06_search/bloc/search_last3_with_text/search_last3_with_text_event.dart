part of 'search_last3_with_text_bloc.dart';

@immutable
abstract class SearchLast3WithTextEvent extends Equatable {
  const SearchLast3WithTextEvent();
  @override
  List<Object?> get props => [];
}

class SearchLast3WithTextFetch extends SearchLast3WithTextEvent {
  const SearchLast3WithTextFetch();
}
