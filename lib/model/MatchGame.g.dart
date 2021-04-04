// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MatchGame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchGame _$MatchGameFromJson(Map<String, dynamic> json) {
  return MatchGame()
    ..matchId = json['matchId'] as int
    ..teamA = json['teamA'] == null
        ? null
        : Team.fromJson(json['teamA'] as Map<String, dynamic>)
    ..teamB = json['teamB'] == null
        ? null
        : Team.fromJson(json['teamB'] as Map<String, dynamic>)
    ..matchVenue = json['matchVenue'] == null
        ? null
        : City.fromJson(json['matchVenue'] as Map<String, dynamic>)
    ..totalOvers = json['totalOvers'] as int
    ..tossWonTeam = json['tossWonTeam'] == null
        ? null
        : Team.fromJson(json['tossWonTeam'] as Map<String, dynamic>)
    ..selectedInning = json['selectedInning'] as String
    ..firstInningsOver = json['firstInningsOver'] as bool
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
    ..live = json['live'] as bool
    ..result = json['result'] as String
    ..target = json['target'] as int
    ..winningTeam = json['winningTeam'] == null
        ? null
        : Team.fromJson(json['winningTeam'] as Map<String, dynamic>)
    ..secondInnignsStarted = json['secondInnignsStarted'] as bool;
}

Map<String, dynamic> _$MatchGameToJson(MatchGame instance) => <String, dynamic>{
      'matchId': instance.matchId,
      'teamA': instance.teamA,
      'teamB': instance.teamB,
      'matchVenue': instance.matchVenue,
      'totalOvers': instance.totalOvers,
      'tossWonTeam': instance.tossWonTeam,
      'selectedInning': instance.selectedInning,
      'firstInningsOver': instance.firstInningsOver,
      'totalScore': instance.totalScore,
      'firstInning': instance.firstInning,
      'secondInning': instance.secondInning,
      'currentPlayers': instance.currentPlayers,
      'live': instance.live,
      'result': instance.result,
      'target': instance.target,
      'winningTeam': instance.winningTeam,
      'secondInnignsStarted': instance.secondInnignsStarted,
    };
