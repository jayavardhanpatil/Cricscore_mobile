// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MatchSummary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchSummary _$MatchSummaryFromJson(Map<String, dynamic> json) {
  return MatchSummary()
    ..secondInningsScore = json['secondInningsScore'] == null
        ? null
        : CurrentPlaying.fromJson(
            json['secondInningsScore'] as Map<String, dynamic>)
    ..firstInningsScore = json['firstInningsScore'] == null
        ? null
        : CurrentPlaying.fromJson(
            json['firstInningsScore'] as Map<String, dynamic>)
    ..matchTitile = json['matchTitile'] as String
    ..live = json['live'] as bool
    ..firstBattingTeamName = json['firstBattingTeamName'] as String
    ..secondInningsTeamName = json['secondInningsTeamName'] as String
    ..firstInningsOver = json['firstInningsOver'] as bool
    ..result = json['result'] as String
    ..target = json['target'] as int
    ..firstBattingTeamId = json['firstBattingTeamId'] as int
    ..secondBattingTeamId = json['secondBattingTeamId'] as int
    ..matchId = json['matchId'] as int;
}

Map<String, dynamic> _$MatchSummaryToJson(MatchSummary instance) =>
    <String, dynamic>{
      'secondInningsScore': instance.secondInningsScore,
      'firstInningsScore': instance.firstInningsScore,
      'matchTitile': instance.matchTitile,
      'live': instance.live,
      'firstBattingTeamName': instance.firstBattingTeamName,
      'secondInningsTeamName': instance.secondInningsTeamName,
      'firstInningsOver': instance.firstInningsOver,
      'result': instance.result,
      'target': instance.target,
      'firstBattingTeamId': instance.firstBattingTeamId,
      'secondBattingTeamId': instance.secondBattingTeamId,
      'matchId': instance.matchId,
    };
