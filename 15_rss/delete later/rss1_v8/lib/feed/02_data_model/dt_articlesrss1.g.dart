// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_articlesrss1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTRss1Article _$DTRss1ArticleFromJson(Map<String, dynamic> json) =>
    DTRss1Article(
      json['postLink'] as String?,
      json['imageLink'] as String?,
      json['title'] as String?,
      json['summary'] as String?,
      json['author'] as String?,
      json['postPublished'] as String?,
      json['rss1LinkByRss1Link'] == null
          ? null
          : DTRss1LinkByRss1Link.fromJson(
              json['rss1LinkByRss1Link'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DTRss1ArticleToJson(DTRss1Article instance) =>
    <String, dynamic>{
      'postLink': instance.postLink,
      'imageLink': instance.imageLink,
      'title': instance.title,
      'summary': instance.summary,
      'author': instance.author,
      'postPublished': instance.postPublished,
      'rss1LinkByRss1Link': instance.rss1LinkByRss1Link,
    };

DTRss1LinkByRss1Link _$DTRss1LinkByRss1LinkFromJson(
        Map<String, dynamic> json) =>
    DTRss1LinkByRss1Link(
      json['outlet'] as String?,
      json['rss1LinkName'] as String?,
    );

Map<String, dynamic> _$DTRss1LinkByRss1LinkToJson(
        DTRss1LinkByRss1Link instance) =>
    <String, dynamic>{
      'outlet': instance.outlet,
      'rss1LinkName': instance.rss1LinkName,
    };
