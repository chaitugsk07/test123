// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTCharacter _$DTCharacterFromJson(Map<String, dynamic> json) => DTCharacter(
      json['id'] as String,
      json['name'] as String,
      json['image'] as String,
      json['status'] as String,
      json['species'] as String,
    );

Map<String, dynamic> _$DTCharacterToJson(DTCharacter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'status': instance.status,
      'species': instance.species,
    };
