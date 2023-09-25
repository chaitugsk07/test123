// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_artical_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTRss1Artical _$DTRss1ArticalFromJson(Map<String, dynamic> json) =>
    DTRss1Artical(
      json['post_link'] as String,
      json['image_link'] as String,
      json['title'] as String,
      json['summary'] as String,
      json['author'] as String,
      DateTime.parse(json['post_published'] as String),
      json['is_default_image'] as int,
      DTRss1LinkByRss1Link.fromJson(
          json['rss1LinkByRss1Link'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DTRss1ArticalToJson(DTRss1Artical instance) =>
    <String, dynamic>{
      'post_link': instance.postLink,
      'image_link': instance.imageLink,
      'title': instance.title,
      'summary': instance.summary,
      'author': instance.author,
      'post_published': instance.postPublished.toIso8601String(),
      'is_default_image': instance.isDefaultImage,
      'rss1LinkByRss1Link': instance.rss1LinkByRss1Link,
    };

DTRss1LinkByRss1Link _$DTRss1LinkByRss1LinkFromJson(
        Map<String, dynamic> json) =>
    DTRss1LinkByRss1Link(
      json['outlet'] as String,
      json['rss1_link_name'] as String,
      DTRss1Outlet.fromJson(json['rss1_outlet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DTRss1LinkByRss1LinkToJson(
        DTRss1LinkByRss1Link instance) =>
    <String, dynamic>{
      'outlet': instance.outlet,
      'rss1_link_name': instance.rss1LinkName,
      'rss1_outlet': instance.rss1Outlet,
    };

DTRss1Outlet _$DTRss1OutletFromJson(Map<String, dynamic> json) => DTRss1Outlet(
      json['logo_url'] as String,
      json['outlet_display'] as String,
    );

Map<String, dynamic> _$DTRss1OutletToJson(DTRss1Outlet instance) =>
    <String, dynamic>{
      'logo_url': instance.logoUrl,
      'outlet_display': instance.outletDisplay,
    };
