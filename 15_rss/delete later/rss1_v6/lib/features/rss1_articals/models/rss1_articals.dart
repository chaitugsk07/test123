import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rss1_articals.g.dart';

@JsonSerializable()
class Rss1Articals extends Equatable {
  Rss1Articals({
    required this.data,
  });

  final Data? data;
  static const String dataKey = "data";

  Rss1Articals copyWith({
    Data? data,
  }) {
    return Rss1Articals(
      data: data ?? this.data,
    );
  }

  factory Rss1Articals.fromJson(Map<String, dynamic> json) =>
      _$Rss1ArticalsFromJson(json);

  Map<String, dynamic> toJson() => _$Rss1ArticalsToJson(this);

  @override
  String toString() {
    return "$data, ";
  }

  @override
  List<Object?> get props => [
        data,
      ];
}

@JsonSerializable()
class Data extends Equatable {
  Data({
    required this.rss1Articals,
  });

  @JsonKey(name: 'rss1_articals')
  final List<Rss1Artical>? rss1Articals;
  static const String rss1ArticalsKey = "rss1_articals";

  Data copyWith({
    List<Rss1Artical>? rss1Articals,
  }) {
    return Data(
      rss1Articals: rss1Articals ?? this.rss1Articals,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  @override
  String toString() {
    return "$rss1Articals, ";
  }

  @override
  List<Object?> get props => [
        rss1Articals,
      ];
}

@JsonSerializable()
class Rss1Artical extends Equatable {
  Rss1Artical({
    required this.postLink,
    required this.imageLink,
    required this.title,
    required this.summary,
    required this.author,
    required this.postPublished,
    required this.rss1LinkByRss1Link,
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

  Rss1Artical copyWith({
    String? postLink,
    String? imageLink,
    String? title,
    String? summary,
    String? author,
    DateTime? postPublished,
    Rss1LinkByRss1Link? rss1LinkByRss1Link,
  }) {
    return Rss1Artical(
      postLink: postLink ?? this.postLink,
      imageLink: imageLink ?? this.imageLink,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      author: author ?? this.author,
      postPublished: postPublished ?? this.postPublished,
      rss1LinkByRss1Link: rss1LinkByRss1Link ?? this.rss1LinkByRss1Link,
    );
  }

  factory Rss1Artical.fromJson(Map<String, dynamic> json) =>
      _$Rss1ArticalFromJson(json);

  Map<String, dynamic> toJson() => _$Rss1ArticalToJson(this);

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
