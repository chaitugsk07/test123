// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTLocation _$DTLocationFromJson(Map<String, dynamic> json) => DTLocation(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
      json['dimension'] as String,
      json['created'] as String,
    );

Map<String, dynamic> _$DTLocationToJson(DTLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'dimension': instance.dimension,
      'created': instance.created,
    };
