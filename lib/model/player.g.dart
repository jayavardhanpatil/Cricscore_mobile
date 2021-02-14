// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player()
    ..uuid = json['uuid'] as String
    ..name = json['name'] as String
    ..city = json['city'] == null
        ? null
        : City.fromJson(json['city'] as Map<String, dynamic>)
    ..phoneNumber = json['phoneNumber'] as int
    ..dateOfBirth = json['dateOfBirth'] as String
    ..email = json['email'] as String
    ..photoUrl = json['photoUrl'] as String;
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'city': instance.city?.toJson(),
      'phoneNumber': instance.phoneNumber,
      'dateOfBirth': instance.dateOfBirth,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
    };
