

import 'package:cricscore/model/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matchScoreCard.g.dart';

@JsonSerializable()

class MatchScoreCard{

  Map<String, Player> battingplayerScoreCard;

  Map<String, Player> bowlingPlayerScoreCard;

  MatchScoreCard();

  factory MatchScoreCard.fromJson(Map<String, dynamic> json) => _$MatchScoreCardFromJson(json);

  Map<String, dynamic> toJson() => _$MatchScoreCardToJson(this);
}