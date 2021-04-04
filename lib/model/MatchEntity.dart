
import 'package:json_annotation/json_annotation.dart';

part 'MatchEntity.g.dart';

@JsonSerializable()
class MatchEntity {

  int matchVenuecityId;
  int totalOvers;
  int teamAId;
  int teamBId;
  int tossWonTeamId;
  String selectedInning;
  int totalScore;
  String result;
  int target;
  int winningTeam;
  DateTime matchDateTime;
  List<String> teamAplayers;
  List<String> teamBplayers;


  MatchEntity();

  factory MatchEntity.fromJson(Map<String, dynamic> json) => _$MatchEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MatchEntityToJson(this);
}