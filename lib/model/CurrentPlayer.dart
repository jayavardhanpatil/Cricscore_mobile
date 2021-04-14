import 'package:cricscore/model/player.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Team.dart';

part 'CurrentPlayer.g.dart';

@JsonSerializable()
class CurrentPlaying{

  int run = 0;
  int wickets = 0;
  var overs = 0.0;
  int extra = 0;
  Team currentBattingteam;
  Map<String, Player> battingTeamPlayer = Map();
  Map<String, Player> bowlingTeamPlayer = Map();

  factory CurrentPlaying.fromJson(Map<String, dynamic> json) => _$CurrentPlayingFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentPlayingToJson(this);

  CurrentPlaying(){}
}