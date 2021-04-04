
import 'City.dart';
import 'CurrentPlayer.dart';
import 'Innings.dart';
import 'Team.dart';


import 'package:json_annotation/json_annotation.dart';

part 'MatchGame.g.dart';

@JsonSerializable()
class MatchGame {

  int matchId;
  //Map<dynamic, Team> teams = new Map();
  Team teamA;
  Team teamB;
  City matchVenue;
  int totalOvers = 0;
  Team tossWonTeam;
  String selectedInning;
  bool firstInningsOver = false;
  int totalScore = 0;
  Inning firstInning;
  Inning secondInning;
  CurrentPlaying currentPlayers;
  bool live = true;
  String result;
  int target = 0;
  Team winningTeam;
  bool secondInnignsStarted = false;

  MatchGame();

  factory MatchGame.fromJson(Map<String, dynamic> json) => _$MatchGameFromJson(json);

  Map<String, dynamic> toJson() => _$MatchGameToJson(this);

}