
import 'dart:async';
import 'dart:convert';

import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:cricscore/model/Innings.dart';
import 'package:cricscore/model/MatchEntity.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';

class HttpUtil {

  static String _url = "https://jsonplaceholder.typicode.com/users";

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

  static void postCurrentPlayers(CurrentPlaying currentPlaying, int matchId, String inningsType) async{

    Map<String, dynamic> body = {
      "currentBattingteamName" : currentPlaying.currentBattingteam.teamName,
      "wickets": currentPlaying.wickets,
      "bowlingTeamPlayer":currentPlaying.bowlingTeamPlayer,
      "battingTeamPlayer" : currentPlaying.battingTeamPlayer,
      "overs" : currentPlaying.overs,
      "extra" : currentPlaying.extra,
      "run" : currentPlaying.run,

    };


    http.Response response = await http.post(
      Constant.PROFILE_SERVICE_URL+"/match/"+matchId.toString()+"/innings/"+inningsType+"/current-players/add",
      headers: _header,
      body: body);

    if (response.statusCode == 200) {
      //print(response.body);
      //success message synced
    }
  }

  static void postPlayerScore(Player player, int matchId, String inningsType) async{

    Map<String, dynamic> body = {
      "run": player.run,
      "wicket":player.wicket,
      "extra" : player.extra,
      "overs" : player.overs,
      "ballsFaced" : player.ballsFaced,
      "runsGiven" : player.runsGiven,
      "numberOfFours" : player.numberOfFours,
      "numberOfsixes" : player.numberOfsixes,
      "playedPosition" : player.playedPosition,
      "out": player.out,
      "onStrike": player.onStrike
    };

    http.Response response = await http.post(
        Constant.PROFILE_SERVICE_URL+"/match/"+matchId.toString()+"/players/"+
        player.uuid+"/addplayer",
        headers: _header,
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  static void postInnings(Inning inning, int matchId, String inningsType) async{

    Map<String, dynamic> body = {
      "matchId":matchId,
      "inningtype":inningsType,
      "battingTeamId" : inning.battingteam.teamId,
      "bowlingTeamId" : inning.bowlingteam.teamId,
      "run" : inning.run,
      "wickets" : inning.wickets,
      "overs" : inning.overs,
      "extra" : inning.extra
    };

    http.Response response = await http.post(
        Constant.PROFILE_SERVICE_URL+"/match/"+matchId.toString()+"/innings/"+inningsType+"/add",
        headers: _header,
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  static void postMatchToServer(MatchGame matchGame) async{

    MatchEntity entity = createMatchEntityObject(matchGame);
    http.Response response = await http.post(
        Constant.PROFILE_SERVICE_URL+"/match/add",
    headers: _header,
    body: jsonEncode(entity.toJson()));
    if (response.statusCode == 200) {
      matchGame.matchId = MatchGame.fromJson(json.decode(response.body)).matchId;
    }
  }

  static MatchEntity createMatchEntityObject(MatchGame matchGame){
    MatchEntity entity = MatchEntity();
    entity.totalScore = matchGame.totalScore;
    entity.tossWonTeamId = matchGame.tossWonTeam.teamId;
    entity.winningTeam = (matchGame.winningTeam != null) ? matchGame.winningTeam.teamId : null;
    entity.totalOvers = matchGame.totalOvers;
    entity.selectedInning = matchGame.selectedInning;
    entity.matchDateTime = DateTime.now();
    entity.matchVenuecityId = matchGame.matchVenue.cityId;
    entity.target = matchGame.target;
    entity.teamAId = matchGame.teamA.teamId;
    entity.teamBId = matchGame.teamB.teamId;
    List<String> players = [];
    matchGame.teamA.playerList.forEach((element) {
      players.add(element.uuid);
    });
    entity.teamAplayers = players;
    players = [];
    matchGame.teamB.playerList.forEach((element) {
      players.add(element.uuid);
    });
    entity.teamBplayers = players;
    return entity;
  }
}