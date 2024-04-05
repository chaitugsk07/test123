part of 'tag_all_bloc.dart';

@immutable
abstract class TagAllEvent extends Equatable {
  const TagAllEvent();
  @override
  List<Object?> get props => [];
}

class TagAllFetch extends TagAllEvent {
  final String tag;

  const TagAllFetch({required this.tag});
}

class TagAllRefresh extends TagAllEvent {
  final String tag;

  const TagAllRefresh({required this.tag});
}
