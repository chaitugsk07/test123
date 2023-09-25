import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dt_artical_feed.g.dart';

@JsonSerializable()
class DTRss1Artical extends Equatable {
  DTRss1Artical(String postLink, {
    this.postLink,
    this.imageLink,
    this.title,
    this.summary,
    this.author,
    this.postPublished,
    this.rss1LinkByRss1Link,
  });

  @JsonKey(name: 'post_link')
  final String? postLink;
  static const String postLinkKey = "post_link";

  @JsonKey(name: 'image_link')
  final String? imageLink;
  static const String imageLinkKey = "image_link";

  final String? title;
  static const String titleKey = "title";

  final String? summary;
  static const String summaryKey = "summary";

  final String? author;
  static const String authorKey = "author";

  @JsonKey(name: 'post_published')
  final DateTime? postPublished;
  static const String postPublishedKey = "post_published";

  final Rss1LinkByRss1Link? rss1LinkByRss1Link;
  static const String rss1LinkByRss1LinkKey = "rss1LinkByRss1Link";

  DTRss1Artical copyWith({
    String? postLink,
    String? imageLink,
    String? title,
    String? summary,
    String? author,
    DateTime? postPublished,
    Rss1LinkByRss1Link? rss1LinkByRss1Link,
  }) {
    return DTRss1Artical(
      postLink: postLink ?? this.postLink,
      imageLink: imageLink ?? this.imageLink,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      author: author ?? this.author,
      postPublished: postPublished ?? this.postPublished,
      rss1LinkByRss1Link: rss1LinkByRss1Link ?? this.rss1LinkByRss1Link,
    );
  }

  factory DTRss1Artical.fromJson(Map<String, dynamic> json) =>
      _$DTRss1ArticalFromJson(json);

  Map<String, dynamic> toJson() => _$DTRss1ArticalToJson(this);

  @override
  String toString() {
    return "$postLink, $imageLink, $title, $summary, $author, $postPublished, $rss1LinkByRss1Link, ";
  }

  @override
  List<Object?> get props => [
        postLink,
        imageLink,
        title,
        summary,
        author,
        postPublished,
        rss1LinkByRss1Link,
      ];
}

@JsonSerializable()
class Rss1LinkByRss1Link extends Equatable {
  Rss1LinkByRss1Link({
    required this.outlet,
    required this.rss1LinkName,
  });

  final String? outlet;
  static const String outletKey = "outlet";

  @JsonKey(name: 'rss1_link_name')
  final String? rss1LinkName;
  static const String rss1LinkNameKey = "rss1_link_name";

  Rss1LinkByRss1Link copyWith({
    String? outlet,
    String? rss1LinkName,
  }) {
    return Rss1LinkByRss1Link(
      outlet: outlet ?? this.outlet,
      rss1LinkName: rss1LinkName ?? this.rss1LinkName,
    );
  }

  factory Rss1LinkByRss1Link.fromJson(Map<String, dynamic> json) =>
      _$Rss1LinkByRss1LinkFromJson(json);

  Map<String, dynamic> toJson() => _$Rss1LinkByRss1LinkToJson(this);

  @override
  String toString() {
    return "$outlet, $rss1LinkName, ";
  }

  @override
  List<Object?> get props => [
        outlet,
        rss1LinkName,
      ];
}
