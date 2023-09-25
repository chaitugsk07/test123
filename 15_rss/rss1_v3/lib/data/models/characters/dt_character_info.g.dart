// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_character_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTCharacterInfo _$DTCharacterInfoFromJson(Map<String, dynamic> json) =>
    DTCharacterInfo(
      json['id'] as String?,
      json['name'] as String?,
      json['image'] as String?,
      json['status'] as String?,
      json['species'] as String?,
      json['gender'] as String?,
      json['origin'] == null
          ? null
          : DTOrigin.fromJson(json['origin'] as Map<String, dynamic>),
      json['location'] == null
          ? null
          : DTLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DTCharacterInfoToJson(DTCharacterInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'status': instance.status,
      'species': instance.species,
      'gender': instance.gender,
      'origin': instance.origin,
      'location': instance.location,
    };

DTOrigin _$DTOriginFromJson(Map<String, dynamic> json) => DTOrigin(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$DTOriginToJson(DTOrigin instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

DTLocation _$DTLocationFromJson(Map<String, dynamic> json) => DTLocation(
      json['id'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$DTLocationToJson(DTLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
