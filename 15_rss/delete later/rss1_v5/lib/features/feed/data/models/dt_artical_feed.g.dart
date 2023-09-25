// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_artical_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTRss1Artical _$DTRss1ArticalFromJson(Map<String, dynamic> json) =>
    DTRss1Artical(
      postLink: json['post_link'] as String?,
      imageLink: json['image_link'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      author: json['author'] as String?,
      postPublished: json['post_published'] == null
          ? null
          : DateTime.parse(json['post_published'] as String),
      rss1LinkByRss1Link: json['rss1LinkByRss1Link'] == null
          ? null
          : Rss1LinkByRss1Link.fromJson(
              json['rss1LinkByRss1Link'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DTRss1ArticalToJson(DTRss1Artical instance) =>
    <String, dynamic>{
      'post_link': instance.postLink,
      'image_link': instance.imageLink,
      'title': instance.title,
      'summary': instance.summary,
      'author': instance.author,
      'post_published': instance.postPublished?.toIso8601String(),
      'rss1LinkByRss1Link': instance.rss1LinkByRss1Link,
    };

Rss1LinkByRss1Link _$Rss1LinkByRss1LinkFromJson(Map<String, dynamic> json) =>
    Rss1LinkByRss1Link(
      outlet: json['outlet'] as String?,
      rss1LinkName: json['rss1_link_name'] as String?,
    );

Map<String, dynamic> _$Rss1LinkByRss1LinkToJson(Rss1LinkByRss1Link instance) =>
    <String, dynamic>{
      'outlet': instance.outlet,
      'rss1_link_name': instance.rss1LinkName,
    };
