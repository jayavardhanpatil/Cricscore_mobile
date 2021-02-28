
import 'dart:convert';

import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/widget/Tost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';

class HttpUtil {

  static Map<String, String> _header = {
    "Content-Type": 'application/json; charset=UTF-8',
  };

  addProfiletoServer(Player playerProfile) {
    // http.post(Constant.PROFILE_SERVICE_URL + "/players/add",
    //     headers: _header,
    //     body: jsonEncode(playerProfile.toJson()))
    //     .then((value) =>
    //   {
    //     print(value.body),
    //     if(value.statusCode == 200)
    //       showSuccessColoredToast("Profile added")
    //     else
    //       showFailedColoredToast("Failed to add Profile")
    //   }
    // );
  }

  static Future<List<City>> getCities() async{
    List<City> city = [];
    final response = await http.get(
        Constant.PROFILE_SERVICE_URL + "/cities", headers: _header,
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      city = List<City>.from(l.map((model) => City.fromJson(model)));
    }
    return city;
  }

  static Future<List<Team>> getTeams() async{
    List<Team> teams = [];
    print("into getteams");
    final response = await http.get(
      Constant.PROFILE_SERVICE_URL + "/teams/all", headers: _header,
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      teams = List<Team>.from(l.map((model) => Team.fromJson(model)));
    }
    return teams;
  }

  static Future<List<Team>> searchTeams(String pattern) async{
    List<Team> teams = [];
    print("getting Teams");
    final response = await http.get(
        Constant.PROFILE_SERVICE_URL + "/teams/find?teamName="+pattern,
        headers: _header
    );
    print("response");
    print(response);

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      teams = List<Team>.from(l.map((model) => Team.fromJson(model)));
    }
    return teams;
  }

  static Future<List<City>> searchCity(String pattern) async{
    List<City> cities = [];
    print("getting Teams");
    final response = await http.get(
        Constant.PROFILE_SERVICE_URL + "/cities/find?cityName="+pattern,
        headers: _header
    );
    print("response");
    print(response);

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      cities = List<City>.from(l.map((model) => City.fromJson(model)));
    }
    return cities;
  }

  static Future<Team> getTeamDetails(int teamId) async{
    Team team = Team();
    final response = await http.get(
      Constant.PROFILE_SERVICE_URL + "/teams/"+teamId.toString(), headers: _header,
    );

    if (response.statusCode == 200) {
      print(response.body);
      team = Team.fromJson(json.decode(response.body));
    }
    return team;
  }

  static Future<List<Player>> getPlayersByCity(int cityId) async {
    List<Player> players = [];
    print("into getting Players");

    final response = await http.get(
      Constant.PROFILE_SERVICE_URL + "/players/city/"+cityId.toString(),
      headers: _header
    );

    print("response");
    print(response);

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      players = List<Player>.from(l.map((model) => Player.fromJson(model)));
    }
    return players;
  }

  static Future<List<Player>> searchPayer(String pattern) async {
    List<Player> players = [];

    var header = _header;
    header.putIfAbsent("name", () => pattern);

    final response = await http.get(
        Constant.PROFILE_SERVICE_URL + "players/find",
        headers: header
    );

    print("response");
    print(response);

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      players = List<Player>.from(l.map((model) => Player.fromJson(model)));
    }
    return players;
  }

  static Future<List<Team>> addteam(Team team) async{
    List<Team> teams = [];
    final response = await http.post(
      Constant.PROFILE_SERVICE_URL + "/teams/add", headers: _header,
      body: jsonEncode(team.toJson()));

    if (response.statusCode == 200) {
      print(response.body);
      Iterable l = json.decode(response.body);
      teams = List<Team>.from(l.map((model) => Team.fromJson(model)));
    }
    return teams;
  }

  // Future getCitiesFromServer() async{
  //   return await
  // }

}