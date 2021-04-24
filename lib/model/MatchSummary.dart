
import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MatchSummary.g.dart';

@JsonSerializable()
class MatchSummary{

  CurrentPlaying secondInningsScore;
  CurrentPlaying firstInningsScore;
  String matchTitile;
  bool live;
  String firstBattingTeamName;
  String secondInningsTeamName;
  bool firstInningsOver;
  String result;
  int target;
  int firstBattingTeamId;
  int secondBattingTeamId;
  int matchId;

  MatchSummary(){}

  factory MatchSummary.fromJson(Map<String, dynamic> json) => _$MatchSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$MatchSummaryToJson(this);

}