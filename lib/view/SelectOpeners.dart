
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:cricscore/model/Innings.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';

import 'UpdateScore.dart';

class SelectOpeners extends StatefulWidget{

  MatchGame matchGame;
  Team batting;
  Team bowling;
  SelectOpeners({Key key,@required this.batting, @required this.bowling, @required this.matchGame}) : super (key : key);
  _SelectOpeners createState() => _SelectOpeners(this.batting, this.bowling, this.matchGame);
}

class _SelectOpeners extends State<SelectOpeners>{

  MatchGame match;

  final String _STRIKER_KEY = "striker";
  final String _NON_STRIKER_KEY = "non-striker";
  final String _BOWLER_KEY = "bolwer";

  var _width;
  var _hight;

  Team batting;
  Team bowling;

  _SelectOpeners(this.batting, this.bowling, this.match);

  List<Player> battingPlayers = [];
  List<Player> bowlingPlayers = [];
  Map<String, Player> playersRole = new Map();

  void initState() {
    battingPlayers = batting.playerList;
    bowlingPlayers = bowling.playerList;
    super.initState();
  }

  DirectSelectItem<Player> getDropDownMenuItem(Player value) {
    return DirectSelectItem<Player>(
        itemHeight: 40,
        value: value,
        itemBuilder: (context, value) {
          return Text(value.name);
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    _width = MediaQuery
        .of(context)
        .size
        .width;
    _hight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
        appBar: AppBar(
          title: Text(batting.teamName +" - select Openers"),
        ),

        body: bodyWidget(context)
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Center(
      child: Container(
        width: _width * 0.7,
        child: DirectSelectContainer(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: _hight * 0.04),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        child: Text("Select Opener, Striker!"),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Card(
                            elevation: 10,
                            child: showDropdownPlayers(_STRIKER_KEY, battingPlayers, 0)
                        ),
                      ),

                      SizedBox(height: _hight * 0.03,),

                      Container(
                        child: Text("Select non-Striker!"),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Card(
                          elevation: 10,
                          child: showDropdownPlayers(_NON_STRIKER_KEY, battingPlayers, 1),
                        ),
                      ),
                      SizedBox(height: _hight * 0.03,),

                      Container(
                        child: Text("Select Open, Bowler!"),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Card(
                          elevation: 10,
                          child: showDropdownPlayers(_BOWLER_KEY, bowlingPlayers, 0),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: _hight * 0.1,),

                RaisedButton(
                  color: Constant.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: AutoSizeText(
                      "Start Innings",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ),
                  onPressed: () {

                    CurrentPlaying currentPlayer = new CurrentPlaying();
                    currentPlayer.currentBattingteam = batting;
                    playersRole.forEach((key, value) {
                        if(key == _STRIKER_KEY){
                          value.playedPosition = 1;
                          value.onStrike = true;
                          intializePlayerScocre(value);
                          //currentPlayer.battingTeamPlayer.putIfAbsent(key, () => value);
                          currentPlayer.battingTeamPlayer.putIfAbsent(value.uuid, () => value);
                        }else if(key == _NON_STRIKER_KEY){
                          value.playedPosition = 2;
                          value.onStrike = false;
                          intializePlayerScocre(value);
                          currentPlayer.battingTeamPlayer.putIfAbsent(value.uuid, () => value);
                          //currentPlayer.battingTeamPlayer.putIfAbsent(key, () => value);
                        }else{
                          intializePlayerScocre(value);
                          currentPlayer.bowlingTeamPlayer.putIfAbsent(value.uuid, () => value);
                          //currentPlayer.bowlingTeamPlayer.putIfAbsent(key, () => value);
                        }
                      });

                    if(!this.match.firstInningsOver){
                      this.match.firstInning = initializeInning(batting, bowling);
                      this.match.secondInning = initializeInning(bowling, batting);
                    }else{
                      this.match.secondInning = initializeInning(batting, bowling);
                      //this.match.firstInning = initializeInning(bowling, batting);
                    }

                    this.match.currentPlayers = currentPlayer;
                    print(json.encode(this.match.currentPlayers));
                    HttpUtil.postCurrentPlayers(this.match.currentPlayers, this.match.matchId,
                        (this.match.firstInningsOver) ? Constant.INNINGS[1] : Constant.INNINGS[0]);

                    HttpUtil.postInnings((this.match.firstInningsOver) ? this.match.secondInning : this.match.firstInning,
                        this.match.matchId,
                        (this.match.firstInningsOver) ? Constant.INNINGS[1] : Constant.INNINGS[0]);

                    Navigator.pop(context);

                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    (UpdateScore(matchGame: match, batting: batting, bowling: bowling,))));
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // List<Player> getPlayersForNonStriker(List<Player> players){
  //   return players.skipWhile((value) =>
  //   value == playersRole.get);
  // }

  Widget showDropdownPlayers(String key, List<Player> players, index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            child: DirectSelectList<Player>(
                values: players,
                defaultItemIndex: index,
                itemBuilder: (Player value) => getDropDownMenuItem(value),
                focusedItemDecoration: _getDslDecoration(),
                onItemSelectedListener: (item, index, context) {
                  playersRole.update(key, (value) => item, ifAbsent: () => item);
                }),
              padding: EdgeInsets.only(left: 12))),
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.unfold_more,
            color: Constant.PRIMARY_COLOR,
          ),
        )
      ],
    );
  }

  intializePlayerScocre(Player player){
    player.overs = 0;
    player.extra = 0;
    player.ballsFaced = 0;
    player.run = 0;
    player.out = false;
    player.runsGiven = 0;
    player.wicket = 0;
  }

  Inning initializeInning(Team batting, Team bowling){
    Inning inning = Inning();
    inning.battingteam = batting;
    inning.run = 0;
    inning.extra = 0;
    inning.overs = 0;
    inning.wickets = 0;
    inning.bowlingteam = bowling;
    return inning;
  }
}

