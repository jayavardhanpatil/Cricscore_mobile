// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'City.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
    json['cityId'] as int,
    json['cityName'] as String,
    json['state'] as String,
  );
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'state': instance.state,
    };
