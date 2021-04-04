// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player()
    ..uuid = json['uuid'] as String
    ..name = json['name'] as String
    ..city = json['city'] == null
        ? null
        : City.fromJson(json['city'] as Map<String, dynamic>)
    ..phoneNumber = json['phoneNumber'] as int
    ..dateOfBirth = json['dateOfBirth'] as String
    ..email = json['email'] as String
    ..photoUrl = json['photoUrl'] as String
    ..onStrike = json['onStrike'] as bool
    ..run = json['run'] as int
    ..wicket = json['wicket'] as int
    ..extra = json['extra'] as int
    ..overs = (json['overs'] as num)?.toDouble()
    ..ballsFaced = json['ballsFaced'] as int
    ..runsGiven = json['runsGiven'] as int
    ..numberOfFours = json['numberOfFours'] as int
    ..numberOfsixes = json['numberOfsixes'] as int
    ..centuries = json['centuries'] as int
    ..fifties = json['fifties'] as int
    ..playedPosition = json['playedPosition'] as int
    ..out = json['out'] as bool;
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'city': instance.city?.toJson(),
      'phoneNumber': instance.phoneNumber,
      'dateOfBirth': instance.dateOfBirth,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'onStrike': instance.onStrike,
      'run': instance.run,
      'wicket': instance.wicket,
      'extra': instance.extra,
      'overs': instance.overs,
      'ballsFaced': instance.ballsFaced,
      'runsGiven': instance.runsGiven,
      'numberOfFours': instance.numberOfFours,
      'numberOfsixes': instance.numberOfsixes,
      'centuries': instance.centuries,
      'fifties': instance.fifties,
      'playedPosition': instance.playedPosition,
      'out': instance.out,
    };
