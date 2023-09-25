import 'package:json_annotation/json_annotation.dart';

part 'dt_artical_feed.g.dart';

@JsonSerializable()
class DTRss1Artical {
  @JsonKey(name: "post_link")
  final String postLink;
  @JsonKey(name: "image_link")
  final String imageLink;
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "summary")
  final String summary;
  @JsonKey(name: "author")
  final String author;
  @JsonKey(name: "post_published")
  final String postPublished;
  @JsonKey(name: "is_default_image")
  final int isDefaultImage;
  @JsonKey(name: "rss1LinkByRss1Link")
  final DTRss1LinkByRss1Link rss1LinkByRss1Link;

  DTRss1Artical(
    this.postLink,
    this.imageLink,
    this.title,
    this.summary,
    this.author,
    this.postPublished,
    this.isDefaultImage,
    this.rss1LinkByRss1Link,
  );

  factory DTRss1Artical.fromJson(Map<String, dynamic> json) =>
      _$DTRss1ArticalFromJson(json);

  Map<String, dynamic> toJson() => _$DTRss1ArticalToJson(this);
}

@JsonSerializable()
class DTRss1LinkByRss1Link {
  @JsonKey(name: "outlet")
  final String outlet;
  @JsonKey(name: "rss1_link_name")
  final String rss1LinkName;
  @JsonKey(name: "rss1_outlet")
  final DTRss1Outlet rss1Outlet;

  DTRss1LinkByRss1Link(
    this.outlet,
    this.rss1LinkName,
    this.rss1Outlet,
  );

  factory DTRss1LinkByRss1Link.fromJson(Map<String, dynamic> json) =>
      _$DTRss1LinkByRss1LinkFromJson(json);

  Map<String, dynamic> toJson() => _$DTRss1LinkByRss1LinkToJson(this);
}

@JsonSerializable()
class DTRss1Outlet {
  @JsonKey(name: "logo_url")
  final String logoUrl;
  @JsonKey(name: "outlet_display")
  final String outletDisplay;

  DTRss1Outlet(
    this.logoUrl,
    this.outletDisplay,
  );

  factory DTRss1Outlet.fromJson(Map<String, dynamic> json) =>
      _$DTRss1OutletFromJson(json);

  Map<String, dynamic> toJson() => _$DTRss1OutletToJson(this);
}
