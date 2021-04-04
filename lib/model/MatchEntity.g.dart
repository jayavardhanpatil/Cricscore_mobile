// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MatchEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchEntity _$MatchEntityFromJson(Map<String, dynamic> json) {
  return MatchEntity()
    ..matchVenuecityId = json['matchVenuecityId'] as int
    ..totalOvers = json['totalOvers'] as int
    ..teamAId = json['teamAId'] as int
    ..teamBId = json['teamBId'] as int
    ..tossWonTeamId = json['tossWonTeamId'] as int
    ..selectedInning = json['selectedInning'] as String
    ..totalScore = json['totalScore'] as int
    ..result = json['result'] as String
    ..target = json['target'] as int
    ..winningTeam = json['winningTeam'] as int
    ..matchDateTime = json['matchDateTime'] == null
        ? null
        : DateTime.parse(json['matchDateTime'] as String)
    ..teamAplayers =
        (json['teamAplayers'] as List)?.map((e) => e as String)?.toList()
    ..teamBplayers =
        (json['teamBplayers'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$MatchEntityToJson(MatchEntity instance) =>
    <String, dynamic>{
      'matchVenuecityId': instance.matchVenuecityId,
      'totalOvers': instance.totalOvers,
      'teamAId': instance.teamAId,
      'teamBId': instance.teamBId,
      'tossWonTeamId': instance.tossWonTeamId,
      'selectedInning': instance.selectedInning,
      'totalScore': instance.totalScore,
      'result': instance.result,
      'target': instance.target,
      'winningTeam': instance.winningTeam,
      'matchDateTime': instance.matchDateTime?.toIso8601String(),
      'teamAplayers': instance.teamAplayers,
      'teamBplayers': instance.teamBplayers,
    };
