import 'dart:async';
import 'dart:convert';

import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/MatchSummary.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class DatabaseService {

  final String uid;

  final StreamController<MatchSummary> matchStreamController = StreamController<MatchSummary>();

  DatabaseService({this.uid});


  static final DatabaseReference _fireBaseRTreference = FirebaseDatabase.instance
      .reference();

  static final String date = new DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future addMatchSummary(MatchGame game) async {
    MatchSummary match = new MatchSummary();

    Map<String, dynamic> updateInningsParameters = {};

    int cityId = game.matchVenue.cityId;
    CurrentPlaying currentPlaying = new CurrentPlaying();
    currentPlaying.battingTeamPlayer = game.currentPlayers.battingTeamPlayer;
    currentPlaying.bowlingTeamPlayer = game.currentPlayers.bowlingTeamPlayer;
    currentPlaying.run = game.currentPlayers.run;
    currentPlaying.extra = game.currentPlayers.extra;
    currentPlaying.wickets = game.currentPlayers.wickets;
    currentPlaying.overs = game.currentPlayers.overs;
    match.live = game.live;
    match.firstInningsOver = game.firstInningsOver;
    match.matchTitile = game.teamA.teamName+"-"+game.teamB.teamName+"-"+date;

    if(game.firstInningsOver && !game.secondInnignsStarted){
      updateInningsParameters = {
        "firstInningsOver" : game.firstInningsOver,
        "target" : game.target,
        "firstInningsScore" : jsonDecode(jsonEncode(currentPlaying))
      };
      updateInnings(updateInningsParameters, cityId, match.matchTitile);
    }
    if (game.secondInnignsStarted) {
        updateInningsParameters = {
          "secondInningsScore" : jsonDecode(jsonEncode(currentPlaying))
        };
        //updateCurrentPlayer(match.matchTitile, currentPlaying, game.matchVenue.cityId, false);
      } else {
        updateInningsParameters = {
          "firstInningsScore" : jsonDecode(jsonEncode(currentPlaying))
        };
        //updateCurrentPlayer(match.matchTitile, currentPlaying, game.matchVenue.cityId, true);
      }
      match.live = game.live;
      if(!match.live) {
        updateInningsParameters = {
          "live": game.live,
          "result": game.result,
          "secondInningsScore" : jsonDecode(jsonEncode(currentPlaying))
        };
      }

    updateInnings(updateInningsParameters, cityId, match.matchTitile);
  }

  static Future updateInnings(Map<String, dynamic> match, int cityId, String matchTitle) async {
    return await _fireBaseRTreference.child("matches")
        .child(cityId.toString()).child(matchTitle).update(match)
        .then((value) => print("Added match Detail"))
        .catchError((e){
      print("Error : in adding match details"+e.toString());
    });
  }

  // static Future updateCurrentPlayer(String matchTitle, CurrentPlaying currentPlaying, int cityId, bool isFirstInnings) async{
  //   String inningsType = (isFirstInnings) ? "firstInningsScore" : "secondInningsScore";
  //   return await _fireBaseRTreference.child("matches")
  //       .child(cityId.toString())
  //       .child(matchTitle+"-"+date)
  //       .child(inningsType)
  //       .set(currentPlaying.toJson()).then((value) =>
  //       print("Player Current Updated")).catchError((e){
  //     print("Error in updating user : "+e.toString());
  //   });
  // }

//  addMatchDetail(MatchGame match) async{
//    print(match.toJson());
//    return await _fireBaseRTreference.child("matches/"+match.getMatchVenue()+"/").child(match.getMatchTitle())
//        .set(match.toJson()).then((value) => print("Match details added")).catchError((e){
//      print("error : "+e.toString());
//    });
//  }


  static Stream<MatchSummary> gameStreamData(String matchVenue, String matchTitle) {
    return _fireBaseRTreference.child("matches")
        .child(matchVenue)
        .child(matchTitle)
        .onValue.map(_mapTOMatchGame);
  }

  static MatchSummary _mapTOMatchGame(dynamic gameData){
    MatchSummary game = MatchSummary.fromJson(json.decode(json.encode(gameData.snapshot.value)));
    return game;
  }

  Future<List<MatchSummary>> getListOfMatches(String city) async{
    List<MatchSummary> listOfMatches = [];
    return await _fireBaseRTreference.child("matches").child(city).once().then((value) {
      value.value.forEach((k, v) {
        Map<String, dynamic> map = json.decode(json.encode(v));
        MatchSummary matchGame = MatchSummary.fromJson(map);
        if(matchGame.firstInningsScore != null || matchGame.secondInningsScore != null) {
          //if (matchGame.live)
            listOfMatches.insert(0, matchGame);
        }
      });
      return listOfMatches;
    }).catchError((e){
      print("error in fetching match data " + e);
      return listOfMatches;
    });
  }
}