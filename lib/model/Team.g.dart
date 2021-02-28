// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team()
    ..teamId = json['teamId'] as int
    ..teamName = json['teamName'] as String
    ..teamCity = json['teamCity'] == null
        ? null
        : City.fromJson(json['teamCity'] as Map<String, dynamic>)
    ..playerList = (json['playerList'] as List)
        ?.map((e) =>
            e == null ? null : Player.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'teamCity': instance.teamCity,
      'playerList': instance.playerList,
    };
