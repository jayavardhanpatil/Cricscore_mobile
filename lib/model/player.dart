
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';


//https://flutter.dev/docs/development/data-and-backend/json

@JsonSerializable()
class Player{
  String uuid;
  String first_name;
  String city;
  int phoneNumber;
  String dateOfBirth;
  String email;
  String photoUrl;

  Player();

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  @override
  String toString() {
    return 'Player{uuid: $uuid, first_name: $first_name, city: $city, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, email: $email, photoUrl: $photoUrl}';
  }
}