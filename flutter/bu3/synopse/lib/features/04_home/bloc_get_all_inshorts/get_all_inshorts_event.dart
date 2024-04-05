part of 'get_all_inshorts_bloc.dart';

@immutable
abstract class GetAllInShortsEvent extends Equatable {
  const GetAllInShortsEvent();
  @override
  List<Object?> get props => [];
}

class GetAllInShortsFetch extends GetAllInShortsEvent {
  final List<String> tags;
  final bool noTags;

  const GetAllInShortsFetch({required this.tags, required this.noTags});
}

class GetAllInShortsRefresh extends GetAllInShortsEvent {
  final List<String> tags;
  final bool noTags;

  const GetAllInShortsRefresh({required this.tags, required this.noTags});
}
