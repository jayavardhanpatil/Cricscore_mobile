// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Innings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inning _$InningFromJson(Map<String, dynamic> json) {
  return Inning()
    ..run = json['run'] as int
    ..wickets = json['wickets'] as int
    ..overs = json['overs']
    ..extra = json['extra'] as int
    ..battingteam = json['battingteam'] == null
        ? null
        : Team.fromJson(json['battingteam'] as Map<String, dynamic>)
    ..bowlingteam = json['bowlingteam'] == null
        ? null
        : Team.fromJson(json['bowlingteam'] as Map<String, dynamic>)
    ..battingTeamPlayer =
        (json['battingTeamPlayer'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Player.fromJson(e as Map<String, dynamic>)),
    )
    ..bowlingTeamPlayer =
        (json['bowlingTeamPlayer'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Player.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$InningToJson(Inning instance) => <String, dynamic>{
      'run': instance.run,
      'wickets': instance.wickets,
      'overs': instance.overs,
      'extra': instance.extra,
      'battingteam': instance.battingteam,
      'bowlingteam': instance.bowlingteam,
      'battingTeamPlayer': instance.battingTeamPlayer,
      'bowlingTeamPlayer': instance.bowlingTeamPlayer,
    };
