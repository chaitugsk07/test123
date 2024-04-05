part of 'tag_all_bloc.dart';

@immutable
abstract class TagAllEvent extends Equatable {
  const TagAllEvent();
  @override
  List<Object?> get props => [];
}

class TagAllFetch extends TagAllEvent {
  final String tag;
  final bool isImageAvilable;

  const TagAllFetch({required this.tag, required this.isImageAvilable});
}

class TagAllRefresh extends TagAllEvent {
  final String tag;

  final bool isImageAvilable;

  const TagAllRefresh({required this.tag, required this.isImageAvilable});
}
