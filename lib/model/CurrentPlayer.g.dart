// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CurrentPlayer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentPlaying _$CurrentPlayingFromJson(Map<String, dynamic> json) {
  return CurrentPlaying()
    ..run = json['run'] as int
    ..wickets = json['wickets'] as int
    ..overs = (json['overs'] as num)?.toDouble()
    ..extra = json['extra'] as int
    ..currentBattingteam = json['currentBattingteam'] == null
        ? null
        : Team.fromJson(json['currentBattingteam'] as Map<String, dynamic>)
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

Map<String, dynamic> _$CurrentPlayingToJson(CurrentPlaying instance) =>
    <String, dynamic>{
      'run': instance.run,
      'wickets': instance.wickets,
      'overs': instance.overs,
      'extra': instance.extra,
      'currentBattingteam': instance.currentBattingteam,
      'battingTeamPlayer': instance.battingTeamPlayer,
      'bowlingTeamPlayer': instance.bowlingTeamPlayer,
    };
