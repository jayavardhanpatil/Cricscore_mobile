// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player()
    ..uuid = json['uuid'] as String
    ..first_name = json['first_name'] as String
    ..city = json['city'] as String
    ..phoneNumber = json['phoneNumber'] as int
    ..dateOfBirth = json['dateOfBirth'] as String
    ..email = json['email'] as String
    ..photoUrl = json['photoUrl'] as String;
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'first_name': instance.first_name,
      'city': instance.city,
      'phoneNumber': instance.phoneNumber,
      'dateOfBirth': instance.dateOfBirth,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
    };
