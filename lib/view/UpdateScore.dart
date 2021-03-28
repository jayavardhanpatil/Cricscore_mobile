import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/controller/CustomDialog.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/widget/Tost.dart';
import 'package:flutter/material.dart';

import 'SelectPlayerDialog.dart';

class UpdateScore extends StatefulWidget {
  MatchGame matchGame;
  Team batting;
  Team bowling;
  UpdateScore(
      {Key key,
      @required this.matchGame,
      @required this.batting,
      @required this.bowling})
      : super(key: key);
  _UpdateScore createState() =>
      _UpdateScore(this.matchGame, this.batting, this.bowling);
}

class _UpdateScore extends State<UpdateScore> {
  MatchGame matchGame;
  Team batting;
  Team bowling;
  bool isInningsOver;
  int ballCouts;

  List<Player> currentBattingPlayer;
  List<Player> currentBowlingPlayer;
  List<Widget> balls = [];

  var _width;
  var _hight;

  _UpdateScore(this.matchGame, this.batting, this.bowling);

  void initState() {
    isInningsOver = false;
    ballCouts = 0;
    currentBattingPlayer =
        this.matchGame.currentPlayers.battingTeamPlayer.values.toList();
    currentBowlingPlayer =
        this.matchGame.currentPlayers.bowlingTeamPlayer.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    _hight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(matchGame.currentPlayers.currentBattingteam.teamName +
            " - Batting"),
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          scoreWindow(context),
          battingPlayerWindow(),
          bowlerBox(currentBowlingPlayer[0]),
          scoreButtons(),
        ],
      ),
    );
  }

  Widget scoreWindow(BuildContext context) {
    return Container(
      height: _hight * 0.30,
      width: _width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black),
          left: BorderSide(width: 1.0, color: Colors.black),
          right: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.matchGame.currentPlayers.run.toString() +
                "/" +
                this.matchGame.currentPlayers.wickets.toString(),
            style: TextStyle(
              fontSize: 70,
              fontFamily: "Oswaldd",
            ),
          ),
          Text(
            "overs : " + this.matchGame.currentPlayers.overs.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Oswaldd",
            ),
          ),
          SizedBox(
            height: _hight * 0.02,
          ),
          AutoSizeText(
            this.matchGame.tossWonTeam.teamName +
                " won the toss and elected to " +
                this.matchGame.selectedInning.toLowerCase() +
                " first",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16.0,
                fontFamily: "Lemonada"),
          ),
        ],
      ),
    );
  }

  Widget battingPlayerWindow() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(width: 1.0, color: Colors.black),
        right: BorderSide(width: 1.0, color: Colors.black),
      )),
      height: _hight * 0.12,
      child: Row(
        children: [
          Expanded(
            child: PlayerScoreBox(currentBattingPlayer[0]),
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          Expanded(
            child: PlayerScoreBox(currentBattingPlayer[1]),
          ),
        ],
      ),
    );
  }

  Widget PlayerScoreBox(Player player) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: CircleAvatar(
              backgroundImage: ExactAssetImage("lib/assets/images/batting.png"),
              backgroundColor: (player.isOnStrike)
                  ? Colors.orangeAccent
                  : Colors.transparent,
              minRadius: 10,
              maxRadius: 10,
            ),
            margin: EdgeInsets.all(5),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: AutoSizeText(
              player.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Lemonada",
                fontWeight: (player.isOnStrike) ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
      Container(
        child: AutoSizeText(
          player.run.toString() + " (" + player.ballsFaced.toString() + ")",
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: "Oswaldd",
            fontWeight: (player.isOnStrike) ? FontWeight.bold : null,
          ),
        ),
      ),
    ]);
  }

  Widget bowlerBox(Player player) {
    return Container(
      height: _hight * 0.15,
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 1.0, color: Colors.black),
        left: BorderSide(width: 1.0, color: Colors.black),
        right: BorderSide(width: 1.0, color: Colors.black),
      )),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundImage:
                      ExactAssetImage("lib/assets/images/cricket_ball.png"),
                  backgroundColor: Colors.orangeAccent,
                  minRadius: 10,
                  maxRadius: 10,
                ),
                margin: EdgeInsets.all(10),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: AutoSizeText(
                  player.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Lemonada",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: _width * 0.6,
                alignment: Alignment.topRight,
                child: AutoSizeText(
                  player.overs.toStringAsFixed(1) +
                      " - " +
                      player.wicket.toString() +
                      " - " +
                      player.runsGiven.toString() +
                      " - " +
                      player.extra.toString(),
                  maxLines: 4,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: "Oswaldd",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: _hight * 0.008,
          ),
          Row(
            children: balls,
          )
        ],
      ),
    );
  }

  Widget scoreButtons() {
    return Container(
      width: _width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          flatButtonRow("0", "1", "2"),
          flatButtonRow("3", "4", "6"),
          flatButtonRow("OUT", "WD", "NB"),
        ],
      ),
    );
  }

  Widget flatButtonRow(String btn1, String btn2, String btn3, {bool color}) {
    return Container(
      height: _hight * 0.1,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 1.0, color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          flatButtonFromScoring(context, btn1),
          VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          flatButtonFromScoring(context, btn2),
          VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          flatButtonFromScoring(context, btn3),
        ],
      ),
    );
  }

  Widget flatButtonFromScoring(BuildContext context, String value) {
    return Expanded(
      child: FlatButton(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              )),
        ),
        color: Colors.transparent,
        onPressed: () {
          setState(() {
            //ballCouts++;
            balls = buildBall(context, value, currentBowlingPlayer[0]);
          });

          if (matchGame.isLive) {
            if (isInnignsOver()) {
              setState(() {
                isInningsOver = true;
              });
              syncCurrentScoreWithInnings();

              if (!matchGame.isFirstInningsOver) {
                matchGame.isFirstInningsOver = true;
                //Update the score of first Innings
                startNewInnings(context);
                //SyncCurrentPlayersWithInnings("firstInnings");
              } else {
                if (isMatchOver()) {
                  matchSummaryData(context);
                  //SyncCurrentPlayersWithInnings("secondInnings");
                }
              }
              matchGame.currentPlayers.run = 0;
              matchGame.currentPlayers.wickets = 0;
              matchGame.currentPlayers.overs = 0;
              matchGame.currentPlayers.extra = 0;
            } else {
              if (isMatchOver()) {
                //syncCurrentScoreWithInnings();
                matchSummaryData(context);
                //SyncCurrentPlayersWithInnings("secondInnings");
              }
            }
            isMatchOver();
            updateCurrentScore().then((value) => showSuccessColoredToast("Data Synced with server"));
          } else {
            matchSummaryData(context);
          }
        },
      ),
    );
  }

  List<Widget> buildBall(
      BuildContext context, String value, Player bowlingPlayer) {
    if (!isInningsOver) {
      if (balls.length > 6) {
        setState(() {
          balls.removeAt(0);
        });
      }

      Color color;
      switch (value.toUpperCase()) {
        case "0":
          {
            color = Colors.transparent;
            setState(() {
              ballCouts++;
              matchGame.currentPlayers.overs += 0.1;
              bowlingPlayer.overs += 0.1;
              updateScoreForStriker(0);
            });
          }
          break;
        case "1":
          {
            color = Colors.black12;
            setState(() {
              ballCouts++;
              matchGame.currentPlayers.overs += 0.1;
              bowlingPlayer.overs += 0.1;
              matchGame.currentPlayers.run += 1;
              updateScoreForStriker(1);
              swapStrikers();
              bowlingPlayer.runsGiven += 1;
            });
          }
          break;
        case "2":
          {
            color = Colors.grey;
            ballCouts++;
            setState(() {
              matchGame.currentPlayers.run += 2;
              matchGame.currentPlayers.overs += 0.1;
              bowlingPlayer.overs += 0.1;
              updateScoreForStriker(2);
              bowlingPlayer.runsGiven += 2;
            });
          }
          break;
        case "3":
          {
            color = Colors.blueGrey;
            setState(() {
              ballCouts++;
              matchGame.currentPlayers.overs += 0.1;
              matchGame.currentPlayers.run += 3;
              bowlingPlayer.overs += 0.1;
              updateScoreForStriker(3);
              swapStrikers();
              bowlingPlayer.runsGiven += 3;
            });
          }
          break;
        case "4":
          {
            color = Colors.orangeAccent;
            setState(() {
              ballCouts++;
              updateScoreForStriker(4);
              matchGame.currentPlayers.overs += 0.1;
              bowlingPlayer.overs += 0.1;
              matchGame.currentPlayers.run += 4;
              bowlingPlayer.runsGiven += 4;
            });
          }
          break;
        case "6":
          {
            color = Colors.lightGreen;
            setState(() {
              ballCouts++;
              updateScoreForStriker(6);
              matchGame.currentPlayers.overs += 0.1;
              bowlingPlayer.overs += 0.1;
              matchGame.currentPlayers.run += 6;
              bowlingPlayer.runsGiven += 6;
            });
          }
          break;
        case "OUT":
          {
            color = Colors.red;
            setState(() {
              bowlingPlayer.wicket++;
              matchGame.currentPlayers.overs += 0.1;
              bowlingPlayer.overs += 0.1;
              //_currentBatttingPlayer.add(new Player(playerName: "fwsfwe", run: 0, ballsFaced:  0));
              ballCouts++;
              matchGame.currentPlayers.wickets++;
              if (matchGame.currentPlayers.wickets < ((matchGame.isFirstInningsOver) ? matchGame.secondInning.battingteam.playerList.length - 1 : matchGame.firstInning.battingteam.playerList.length -
                              1) &&
                  !isMatchOver() &&
                  !isInningsOver)
                Future.delayed(const Duration(milliseconds: 100), () {
                  nextBatsman(context);
                });
            });
          }
          break;
        case "NB":
          {
            color = Colors.grey;
            bowlingPlayer.runsGiven++;
            matchGame.currentPlayers.extra++;
            bowlingPlayer.extra++;
          }
          break;
        case "WD":
          {
            color = Colors.grey;
            bowlingPlayer.runsGiven++;
            matchGame.currentPlayers.extra++;
            bowlingPlayer.extra++;
          }
          break;
        default:
          {
            color = Colors.transparent;
          }
          break;
      }

      balls.add(
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.0, color: Colors.black),
            color: color,
          ),
          margin: EdgeInsets.only(left: 10),
          child: Text(value.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
//                  fontStyle: FontStyle.italic,
                  fontFamily: "Oswaldd",
                  fontSize: 12)),
          padding: EdgeInsets.all(10.0),
        ),
      );

      if (ballCouts >= 6) {
        setState(() {
          balls.clear();
          ballCouts = 0;
          matchGame.currentPlayers.overs += 0.4;
          swapStrikers();
          bowlingPlayer.overs += 0.4;

           if (matchGame.isFirstInningsOver) {
             matchGame.secondInning.bowlingTeamPlayer
                 .update(bowlingPlayer.uuid, (value) => bowlingPlayer);
           } else {
             matchGame.firstInning.bowlingTeamPlayer
                 .update(bowlingPlayer.uuid, (value) => bowlingPlayer);
           }

          if (matchGame.currentPlayers.overs < matchGame.totalOvers &&
              !isMatchOver()) {
            Future.delayed(const Duration(milliseconds: 100), () {
              nextBowler(context);
            });
          }
        });
      }
    } else {
      if(matchGame.result.isNotEmpty || !matchGame.isLive) {
        matchSummaryData(context).then((value) => (){
          print("Match is finished");
        });
      }else{
        startNewInnings(context);
      }
    }
    return balls;
  }

  void swapStrikers() {
    if (currentBattingPlayer[0].isOnStrike) {
      currentBattingPlayer[0].isOnStrike = false;
      currentBattingPlayer[1].isOnStrike = true;
    } else {
      currentBattingPlayer[1].isOnStrike = false;
      currentBattingPlayer[0].isOnStrike = true;
    }
  }

  nextBatsman(BuildContext context) {
    if (matchGame.currentPlayers.overs < matchGame.totalOvers) {
      //pop up to select next bowler
      List<Player> batsmans = [];
      if (matchGame.isFirstInningsOver) {
        matchGame.secondInning.battingteam.playerList.forEach((element) {
          if (!element.isOut) {
            batsmans.add(element);
          }
        });
      } else {
        matchGame.firstInning.battingteam.playerList.forEach((element) {
          if (!element.isOut) {
            batsmans.add(element);
          }
        });
      }

      batsmans.remove(currentBattingPlayer[0]);
      batsmans.remove(currentBattingPlayer[1]);

      getSelectedPlayer(context, batsmans, "batsman").then((value) => {
            if (value != null)
              {
                replaceStrikerWithNewBatsma(value),
              }
          });
    }
  }

  Future<Player> getSelectedPlayer(
      BuildContext context, List<Player> plyersList, String playerType) async {
    if (plyersList.length > 0) {
      Player selectedPlayer = await showDialog(
          context: context,
          builder: (context) => selectPlayerDialog(
              playerList: plyersList, playerType: playerType));
      return selectedPlayer;
    }
  }

  void replaceStrikerWithNewBatsma(Player newBatsman) {
    int onStrikeIndex = (currentBattingPlayer[0].isOnStrike) ? 0 : 1;

    currentBattingPlayer[onStrikeIndex].isOut = true;

    if (matchGame.isFirstInningsOver) {
      //   DatabaseService().updatePlayer(
      //       match, _currentBatttingPlayer[onStrikeIndex], "batting_team",
      //       "secondInnings");
      // }else{
      //   DatabaseService().updatePlayer(
      //       match, _currentBatttingPlayer[onStrikeIndex], "batting_team",
      //       "firstInnings");
      // }
    }
    //Now replace the batsman
    setState(() {
      matchGame.currentPlayers.battingTeamPlayer
          .remove(currentBattingPlayer[onStrikeIndex].uuid);
      newBatsman.isOnStrike = true;
      currentBattingPlayer[onStrikeIndex] = newBatsman;
      matchGame.currentPlayers.battingTeamPlayer.putIfAbsent(
          newBatsman.uuid, () => currentBattingPlayer[onStrikeIndex]);
    });
    updateCurrentScore()
        .then((value) => showSuccessColoredToast("Data Synced with server"));
  }

  Future updateCurrentScore() async {
    return Future;
  }

  void updateScoreForStriker(int run) {
    if (currentBattingPlayer[0].isOnStrike) {
      currentBattingPlayer[0].run += run;
      currentBattingPlayer[0].ballsFaced++;
    } else {
      currentBattingPlayer[1].run += run;
      currentBattingPlayer[1].ballsFaced++;
    }
  }

  void nextBowler(BuildContext context) async {
    if (matchGame.currentPlayers.overs < matchGame.totalOvers) {
      List<Player> bowlers = [];
      if (matchGame.isFirstInningsOver) {
        bowlers.addAll(matchGame.secondInning.bowlingteam.playerList);
      } else {
        bowlers.addAll(matchGame.firstInning.bowlingteam.playerList);
      }

      bowlers.remove(currentBowlingPlayer[0]);
      getSelectedPlayer(context, bowlers, "bowler")
          .then((value) => {if (value != null) replaceBowler(value)});
    }
  }

  Future replaceBowler(Player player) {
    if (matchGame.isFirstInningsOver) {
      //   DatabaseService().updatePlayer(
      //       match, _currentBowlingPlayer[0], "bowling_team",
      //       "secondInnings");
      // }else{
      //   DatabaseService().updatePlayer(
      //       match, _currentBowlingPlayer[0], "bowling_team",
      //       "firstInnings");
    }
    setState(() {
      balls.clear();
      matchGame.currentPlayers.bowlingTeamPlayer
          .remove(currentBowlingPlayer[0].uuid);
      currentBowlingPlayer[0] = player;
      matchGame.currentPlayers.bowlingTeamPlayer
          .putIfAbsent(player.uuid, () => currentBowlingPlayer[0]);
    });

    updateCurrentScore()
        .then((value) => showSuccessColoredToast("Data Synced with server"));
  }

  startNewInnings(BuildContext context) {
    //Future.delayed(const Duration(seconds: 1), () {
    showDialog(context: context,
        builder: (context) =>
            CustomDialog(matchGame: matchGame,
              title: "Start Second Innings",
              description1: "target : " + matchGame.target.toString(),
              description2: matchGame.secondInning.battingteam.teamName +
                  " :  Need " + matchGame.target.toString() +
                  " runs to win from " + matchGame.totalOvers.toString() +
                  " overs.",
              buttonText: "Start Second Innings",));
    //});
  }

  Future matchSummaryData(BuildContext context) async{
    return await showDialog(context: context,
        builder: (context) =>
            CustomDialog(matchGame: matchGame, title: "Congratulations "+
                matchGame.winningTeam.teamName, description1: "",
              description2: matchGame.result,
              buttonText: "Finish Game",));

  }

  isInnignsOver() {
    bool result = false;
    if (matchGame.isFirstInningsOver) {
      if (matchGame.currentPlayers.overs.floor() >= matchGame.totalOvers ||
          matchGame.currentPlayers.wickets ==
              matchGame.secondInning.battingteam.playerList.length - 1) {
        print("Innings over");
        result = true;
      }
    } else {
      if (matchGame.currentPlayers.overs.floor() >= matchGame.totalOvers ||
          matchGame.currentPlayers.wickets ==
              matchGame.firstInning.battingteam.playerList.length - 1) {
        print("Innings over");
        result = true;
      }
    }
    return result;
  }

  void syncCurrentScoreWithInnings() {
      if(matchGame.isLive && !matchGame.isFirstInningsOver) {
        matchGame.firstInning.run = matchGame.currentPlayers.run;
        matchGame.firstInning.overs = matchGame.currentPlayers.overs;
        matchGame.firstInning.wickets = matchGame.currentPlayers.wickets;
        matchGame.firstInning.extra = matchGame.currentPlayers.extra;
        matchGame.target = matchGame.currentPlayers.run + 1;

      }else {
        matchGame.secondInning.run = matchGame.currentPlayers.run;
        matchGame.secondInning.overs = matchGame.currentPlayers.overs;
        matchGame.secondInning.wickets = matchGame.currentPlayers.wickets;
        matchGame.secondInning.extra = matchGame.currentPlayers.extra;
      }
  }

  bool isMatchOver() {
    if(matchGame.isFirstInningsOver){

      if(matchGame.currentPlayers.overs >= matchGame.totalOvers){
        if(matchGame.currentPlayers.run < matchGame.firstInning.run){
          matchGame.winningTeam = matchGame.firstInning.battingteam;
          print(matchGame.winningTeam.teamName + " won by "+(matchGame.firstInning.run - matchGame.currentPlayers.run).toString() + " runs");
          matchGame.result = matchGame.winningTeam.teamName + " won by "+(matchGame.firstInning.run - matchGame.currentPlayers.run).toString() + " runs";
          matchGame.isLive = false;
          return true;
        }
      }
      else if(matchGame.currentPlayers.run > matchGame.firstInning.run){
        matchGame.winningTeam = matchGame.secondInning.battingteam;
        print(matchGame.winningTeam.teamName + " won by "+(matchGame.secondInning.battingteam.playerList.length - matchGame.currentPlayers.wickets).toString() + " wickets");
        matchGame.result = matchGame.winningTeam.teamName + " won by "+(matchGame.secondInning.battingteam.playerList.length - matchGame.currentPlayers.wickets).toString() + " wickets";
        matchGame.isLive = false;
        return true;
      }else if( matchGame.currentPlayers.wickets == matchGame.secondInning.battingteam.playerList.length-1){
        matchGame.winningTeam = matchGame.firstInning.battingteam;
        print(matchGame.winningTeam.teamName + " team won by "+(matchGame.firstInning.run - matchGame.currentPlayers.run).toString() + " runs");
        matchGame.result = matchGame.winningTeam.teamName + " team won by "+(matchGame.firstInning.run - matchGame.currentPlayers.run).toString() + " runs";
        matchGame.isLive = false;
        return true;
      }
    }
    return false;
  }
}
