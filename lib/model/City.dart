
import 'package:json_annotation/json_annotation.dart';

part 'City.g.dart';

@JsonSerializable()
class City{

  int cityId;
  String cityName;
  String state;


  City();


  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);


}