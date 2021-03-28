// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MatchGame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchGame _$MatchGameFromJson(Map<String, dynamic> json) {
  return MatchGame()
    ..matchId = json['matchId'] as int
    ..teams = (json['teams'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Team.fromJson(e as Map<String, dynamic>)),
    )
    ..matchVenue = json['matchVenue'] as City
    ..totalOvers = json['totalOvers'] as int
    ..tossWonTeam = json['tossWonTeam'] as Team
    ..selectedInning = json['selectedInning'] as String
    ..isFirstInningsOver = json['isFirstInningsOver'] as bool
    ..totalScore = json['totalScore'] as int
    ..firstInning = json['firstInning'] == null
        ? null
        : Inning.fromJson(json['firstInning'] as Map<String, dynamic>)
    ..secondInning = json['secondInning'] == null
        ? null
        : Inning.fromJson(json['secondInning'] as Map<String, dynamic>)
    ..currentPlayers = json['currentPlayers'] == null
        ? null
        : CurrentPlaying.fromJson(
            json['currentPlayers'] as Map<String, dynamic>)
    ..isLive = json['isLive'] as bool
    ..result = json['result'] as String
    ..target = json['target'] as int
    ..winningTeam = json['winningTeam'] as Team
    ..isSecondInnignsStarted = json['isSecondInnignsStarted'] as bool;
}

Map<String, dynamic> _$MatchGameToJson(MatchGame instance) => <String, dynamic>{
      'matchId': instance.matchId,
      'teams': instance.teams,
      'matchVenue': instance.matchVenue,
      'totalOvers': instance.totalOvers,
      'tossWonTeam': instance.tossWonTeam,
      'selectedInning': instance.selectedInning,
      'isFirstInningsOver': instance.isFirstInningsOver,
      'totalScore': instance.totalScore,
      'firstInning': instance.firstInning,
      'secondInning': instance.secondInning,
      'currentPlayers': instance.currentPlayers,
      'isLive': instance.isLive,
      'result': instance.result,
      'target': instance.target,
      'winningTeam': instance.winningTeam,
      'isSecondInnignsStarted': instance.isSecondInnignsStarted,
    };
