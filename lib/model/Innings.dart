

import 'package:cricscore/model/player.dart';
import 'package:flutter/cupertino.dart';

import 'Team.dart';

import 'package:json_annotation/json_annotation.dart';

part 'Innings.g.dart';

@JsonSerializable()
class Inning{

  int run;
  int wickets;
  var overs;
  int extra;
  Team battingteam;
  Team bowlingteam;
  Map<String, Player> battingTeamPlayer;
  Map<String, Player> bowlingTeamPlayer;

  Inning({Team batting, Team bowling}){
    this.run = 0;
    this. wickets = 0;
    this.overs = 0;
    this.extra = 0;
    this.battingteam = batting;
    this.bowlingteam = bowling;
    this.battingTeamPlayer = Map();
    this.bowlingTeamPlayer = Map();
  }

  factory Inning.fromJson(Map<String, dynamic> json) => _$InningFromJson(json);

  Map<String, dynamic> toJson() => _$InningToJson(this);

}