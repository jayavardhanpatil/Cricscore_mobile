
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
  String secondInningsTramName;
  bool firstInningsOver;
  String result;
  int target;

  MatchSummary(){}

  factory MatchSummary.fromJson(Map<String, dynamic> json) => _$MatchSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$MatchSummaryToJson(this);

}