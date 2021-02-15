// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team()
    ..teamId = json['teamId'] as int
    ..teamName = json['teamName'] as String
    ..city = json['city'] == null
        ? null
        : City.fromJson(json['city'] as Map<String, dynamic>)
    ..players = (json['players'] as List)
        ?.map((e) =>
            e == null ? null : Player.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'city': instance.city,
      'players': instance.players,
    };
