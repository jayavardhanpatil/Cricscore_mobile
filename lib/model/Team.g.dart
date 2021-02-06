// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team(
    json['teamId'] as int,
    json['teamName'] as String,
    json['city'] as String,
    json['players'] as List,
  );
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'city': instance.city,
      'players': instance.players,
    };
