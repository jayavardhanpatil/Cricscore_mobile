import 'dart:async';
import 'dart:convert';

import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/MatchSummary.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {

  final String uid;

  final StreamController<MatchSummary> matchStreamController = StreamController<MatchSummary>();

  DatabaseService({this.uid});


  static final DatabaseReference _fireBaseRTreference = FirebaseDatabase.instance
      .reference();


  static Future addMatchSummary(MatchGame game) async{
    MatchSummary match = new MatchSummary();
    int  cityId = game.matchVenue.cityId;
    CurrentPlaying currentPlaying = new CurrentPlaying();
    currentPlaying.battingTeamPlayer = game.currentPlayers.battingTeamPlayer;
    currentPlaying.bowlingTeamPlayer = game.currentPlayers.bowlingTeamPlayer;
    currentPlaying.run = game.currentPlayers.run;
    currentPlaying.extra = game.currentPlayers.extra;
    currentPlaying.wickets = game.currentPlayers.wickets;
    currentPlaying.overs = game.currentPlayers.overs;

    if(game.live && game.firstInningsOver)
      match.secondInningsScore = currentPlaying;
    else{
      match.firstInningsScore = currentPlaying;
    }
    match.live = game.live;
    match.firstInningsOver = game.firstInningsOver;
    match.matchTitile  = game.teamA.teamName + "-" + game.teamB.teamName;
    match.firstBattingTeamName = game.firstInning.battingteam.teamName;
    match.result = game.result;
    match.target = game.target;

    print("Match Title : "+match.matchTitile);
    print(jsonEncode(match.toJson()));
    return await _fireBaseRTreference.child("matches")
        .child(cityId.toString()).child(match.matchTitile).set(jsonDecode(jsonEncode(match.toJson())))
        .then((value) => print("Added match Detail"))
        .catchError((e){
      print("Error : in adding match details"+e.toString());
    });
  }

  Future updateCurrentPlayer(MatchSummary matchSummary, int cityId) async{
    return await _fireBaseRTreference.child("matches")
        .child(cityId.toString())
        .child(matchSummary.matchTitile)
        .child("currentPlayers")
        .set(matchSummary.toJson()).then((value) =>
        print("Player Current Updated")).catchError((e){
      print("Error in updating user : "+e.toString());
    });
  }



//  addMatchDetail(MatchGame match) async{
//    print(match.toJson());
//    return await _fireBaseRTreference.child("matches/"+match.getMatchVenue()+"/").child(match.getMatchTitle())
//        .set(match.toJson()).then((value) => print("Match details added")).catchError((e){
//      print("error : "+e.toString());
//    });
//  }


  Stream<MatchSummary> gameStreamData(String matchVenue, String matchTitle) {
    return _fireBaseRTreference.child("matches")
        .child(matchVenue)
        .child(matchTitle)
        .onValue.map(_mapTOMatchGame);
  }

  MatchSummary _mapTOMatchGame(dynamic gameData){
    MatchSummary game = MatchSummary.fromJson(gameData.snapshot.value);
    return game;
  }
}