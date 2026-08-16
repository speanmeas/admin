// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_ser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
  id: json['id'] as String?,
  name: json['name'] as String?,
  age: (json['age'] as num?)?.toInt(),
);

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
};
