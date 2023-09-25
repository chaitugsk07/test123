import 'package:json_annotation/json_annotation.dart';

part 'dt_articlesrss1.g.dart';

@JsonSerializable()
class DTRss1Article {
  DTRss1Article(
    this.postLink,
    this.imageLink,
    this.title,
    this.summary,
    this.author,
    this.postPublished,
    this.rss1LinkByRss1Link,
  );

  factory DTRss1Article.fromJson(Map<String, dynamic> json) =>
      _$DTRss1ArticleFromJson(json);

  final String? postLink, imageLink, title, summary, author, postPublished;
  final DTRss1LinkByRss1Link? rss1LinkByRss1Link;

  Map<String, dynamic> toJson() => _$DTRss1ArticleToJson(this);
}

@JsonSerializable()
class DTRss1LinkByRss1Link {
  DTRss1LinkByRss1Link(this.outlet, this.rss1LinkName);

  factory DTRss1LinkByRss1Link.fromJson(Map<String, dynamic> json) =>
      _$DTRss1LinkByRss1LinkFromJson(json);

  final String? outlet, rss1LinkName;

  Map<String, dynamic> toJson() => _$DTRss1LinkByRss1LinkToJson(this);
}
