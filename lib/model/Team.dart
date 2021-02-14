
import 'package:cricscore/model/player.dart';
import 'package:json_annotation/json_annotation.dart';

import 'City.dart';

part 'Team.g.dart';

@JsonSerializable()
class Team{

  int teamId;
  String teamName;
  City city;
  List<Player> players;

  Team(this.teamId, this.teamName, this.city, this.players);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}