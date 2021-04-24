// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchScoreCard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchScoreCard _$MatchScoreCardFromJson(Map<String, dynamic> json) {
  return MatchScoreCard()
    ..battingplayerScoreCard =
        (json['battingplayerScoreCard'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Player.fromJson(e as Map<String, dynamic>)),
    )
    ..bowlingPlayerScoreCard =
        (json['bowlingPlayerScoreCard'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Player.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$MatchScoreCardToJson(MatchScoreCard instance) =>
    <String, dynamic>{
      'battingplayerScoreCard': instance.battingplayerScoreCard,
      'bowlingPlayerScoreCard': instance.bowlingPlayerScoreCard,
    };
