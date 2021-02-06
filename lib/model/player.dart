
import 'package:json_annotation/json_annotation.dart';

import 'City.dart';

part 'player.g.dart';


//https://flutter.dev/docs/development/data-and-backend/json

@JsonSerializable(explicitToJson: true)
class Player{
  String uuid;
  String first_name;
  City city;
  int phoneNumber;
  String dateOfBirth;
  String email;
  String photoUrl;

  Player();

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

}