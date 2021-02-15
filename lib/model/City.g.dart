// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'City.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) {
  return City()
    ..cityId = json['cityId'] as int
    ..cityName = json['cityName'] as String
    ..state = json['state'] as String;
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'state': instance.state,
    };
