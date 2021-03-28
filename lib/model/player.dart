
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'City.dart';

part 'player.g.dart';


//https://flutter.dev/docs/development/data-and-backend/json

@JsonSerializable(explicitToJson: true)
class Player{
  String uuid;
  String name;
  City city;
  int phoneNumber;
  String dateOfBirth;
  String email;
  String photoUrl;

  bool isOnStrike = false;
  int run = 0;
  int wicket = 0;
  int extra = 0;
  double overs = 0.0;
  int ballsFaced = 0;
  int runsGiven = 0;
  int numberOfFours = 0;
  int numberOfsixes = 0;
  int centuries = 0;
  int fifties = 0;
  int playedPosition = 0;
  bool isOut = false;

  Player(){
    this.isOut = false;
    this.isOnStrike = false;
  }

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

}