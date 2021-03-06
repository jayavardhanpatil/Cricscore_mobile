
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/controller/database_service.dart';
import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/MatchSummary.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/view/Teams.dart';
import 'package:cricscore/view/matchScoreCard.dart';
import 'package:cricscore/widget/Loader.dart';
import 'package:cricscore/widget/RowBoxDecoration.dart';
import 'package:flutter/material.dart';

class MatchSummaryPage extends StatefulWidget{

  _MatchSummary createState() => _MatchSummary();

}

class _MatchSummary extends State<MatchSummaryPage>{


  static int firstInningsScore;
  static int firstInningsWickets;
  static int secondInningsScore;
  static int secondInningsWickets;

  String usercityId;
  Future matches;
  MatchGame game;
  bool loading = true;

  static Map<String, Map<String, String>> match_Innings_Score = new Map();
  List<MatchSummary> _matches = [];
  List<Player> batsmansplayers;
  List<Player> bowler;

  @override
  void initState() {
    Player player = Player.fromJson(SharedPrefUtil.getObject(Constant.PROFILE_KEY));
    usercityId = player.city.cityId.toString();
    matches = getMatches();
    firstInningsScore = 0;
    firstInningsWickets = 0;
    secondInningsScore = 0;
    secondInningsWickets = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Matches in your City"),
      // ),
      body: SingleChildScrollView(
        child : Container(
          child: Column(
            children: <Widget>[
              matchListView(context),
            ],
          ),
        ),
      ),
    );
  }

  Future getMatches() async{
    return await DatabaseService().getListOfMatches(usercityId);
  }

  Widget matchListView(BuildContext context) {
    return FutureBuilder(
        future: matches,
        builder: (context, snapshot){
          if(snapshot.data == null) {
            return Loading();
          }else if(snapshot.hasData){
            _matches = snapshot.data;
            _matches.forEach((element) {
              match_Innings_Score.putIfAbsent(element.matchTitile, () => null);
            });
            if(_matches.length > 0) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _matches.length,
                  itemBuilder: (context, index) {
                    return getCardList(context, index);
                  }
              );
            }else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                      color: const Color(0xFF75A2EA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: AutoSizeText(
                          "Start New Match",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SelectTeam()));
                      }
                  ),
                ],
              ),
            );
          }
          }else{
            return Text("No data");
          }
        },
    );
  }

  Widget getCardList(BuildContext context, index){
    return Container(
      height: 250,
      child: GestureDetector(
        onTap: () => {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => MatchScoreCardView(summary: _matches[index])))
        },
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          color : (_matches[index].live) ? null : Color.fromRGBO(255, 255, 255, 0.2),
          child: (_matches[index] != null ) ? updateGameData(_matches[index]) : Container(),
        )
      )
    );
  }

  Widget updateGameData(MatchSummary matchSummary){
    return StreamBuilder<MatchSummary>(
      stream: DatabaseService.gameStreamData(usercityId, matchSummary.matchTitile),
      builder: (context, snapshot){
        if(snapshot.hasData){
          matchSummary = snapshot.data;
          // setState(() {
          //   if(matchSummary.firstInningsOver){
          //     secondInningsScore = matchSummary.secondInningsScore.run;
          //     secondInningsWickets = matchSummary.secondInningsScore.wickets;
          //   }else{
          //     firstInningsScore = matchSummary.firstInningsScore.run;
          //     firstInningsWickets = matchSummary.firstInningsScore.wickets;
          //   }
          // });

          Map<String, String> liveScore = new Map();
          if(matchSummary.secondInningsScore == null){
            liveScore.putIfAbsent("SECOND", () => "0-0");
            matchSummary.secondInningsScore = new CurrentPlaying();
            (matchSummary.secondInningsScore.overs == null) ? matchSummary.secondInningsScore.overs : 0.0;
            (matchSummary.secondInningsScore.run == null) ? matchSummary.secondInningsScore.run : 0;
            (matchSummary.secondInningsScore.wickets == null) ? matchSummary.secondInningsScore.wickets : 0;
            (matchSummary.secondInningsScore.extra == null )?matchSummary.secondInningsScore.extra : 0;
          }else{
            liveScore.putIfAbsent("SECOND", () => matchSummary.secondInningsScore.run.toString() +"-"+
                matchSummary.secondInningsScore.wickets.toString());
          }
          liveScore.putIfAbsent("FIRST", () => matchSummary.firstInningsScore.run.toString() +"-"+
          matchSummary.firstInningsScore.wickets.toString());
          SharedPrefUtil.putObject("LIVE-"+matchSummary.matchTitile, liveScore);
          CurrentPlaying currentScore = (matchSummary.firstInningsOver) ? matchSummary.secondInningsScore : matchSummary.firstInningsScore;
          batsmansplayers = currentScore.battingTeamPlayer.values.toList();
          bowler = currentScore.bowlingTeamPlayer.values.toList();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),

                    child: AutoSizeText(
                      matchSummary.matchTitile,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Literata',
                        //color: Color(0xFF75A2EA),
                      ),
                    ),
                  ),

                  if (matchSummary.live) Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.all(5),
                    child : Text("Live", textAlign: TextAlign.center,style: TextStyle(fontSize: 10,
                    ),),
                  // ignore: sdk_version_ui_as_code
                  ) else Container(),
                ],
              ),

              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: AutoSizeText(
                              matchSummary.firstBattingTeamName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style : TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Literata',
                              ),
                            ),

                            margin: EdgeInsets.all(5),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5),

                            child: AutoSizeText(
                              (matchSummary.firstInningsOver) ? matchSummary.firstInningsScore.run.toString() + "/" + matchSummary.firstInningsScore.wickets.toString()
                                  : currentScore.run.toString() + "/" + currentScore.wickets.toString(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Oswaldd',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: (matchSummary.live) ? getButtonGradientColor(BoxShape.circle) :
                      BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(255, 255, 255, 0.0),
                          border: Border.all(width: 1.0, color: Colors.black)
                      ),
                      margin: EdgeInsets.all(5),
                      child: Text("VS",style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300,),
                      ),
                      padding: EdgeInsets.all(5.0),

                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(

                            padding: EdgeInsets.only(left: 5),

                            child: AutoSizeText(
                              matchSummary.secondInningsTeamName,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style : TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Literata',
                              ),
                            ),

//                            child: Text(matchGame.secondInning.battingteam.getTeamName(), textAlign: TextAlign.center,style : TextStyle(
//                              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'ERGaramond italic', fontStyle: FontStyle.italic,
//                            ),),
                            margin: EdgeInsets.all(5),
                          ),
                          Container(

                            child: AutoSizeText(
                              (matchSummary.firstInningsOver && matchSummary.live) ? currentScore.run.toString() + "/" + currentScore.wickets.toString()
                                  : matchSummary.secondInningsScore.run.toString() + "/" + matchSummary.secondInningsScore.wickets.toString(),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Oswaldd',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),

              (batsmansplayers.length == 0) ? new Container() :

              Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      AutoSizeText(
                        "Batsman : ",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Lemonada',
                        ),
                      ),

                      SizedBox(width: 10,),

                      Container(
                        child: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/batting.png"),
                          backgroundColor: (batsmansplayers[0].onStrike) ? Colors.orangeAccent : Colors.transparent,
                          minRadius: 8,
                          maxRadius: 8,
                        ),
                        margin: EdgeInsets.all(5),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),

                        child : AutoSizeText(
                          batsmansplayers[0].name + " :-   "+batsmansplayers[0].run.toString() + "(" + batsmansplayers[0].ballsFaced.toString() + ")",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: (batsmansplayers[0].onStrike) ? FontWeight.bold : null , fontSize: 13,
                              fontFamily: 'Literata'),),),


                      SizedBox(width: 15,),

                      Container(
                        child: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/batting.png"),
                          backgroundColor: (batsmansplayers[1].onStrike) ? Colors.orangeAccent : Colors.transparent,
                          minRadius: 8,
                          maxRadius: 8,
                        ),
                        margin: EdgeInsets.all(5),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child : AutoSizeText(
                          batsmansplayers[1].name + " :-   "+batsmansplayers[1].run.toString() + "(" + batsmansplayers[1].ballsFaced.toString() + ")",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: (batsmansplayers[1].onStrike) ? FontWeight.bold : null , fontSize: 13,
                              fontFamily: 'Literata'),),),
                    ],
                  )
              ),

              (bowler.length == 0) ? new Container() :

              Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      AutoSizeText(
                        "Bowler : ",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Lemonada',
                        ),
                      ),

                      SizedBox(width: 10,),

                      Container(
                        child: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/cricket_ball.png"),
                          backgroundColor: Colors.orangeAccent,
                          minRadius: 8,
                          maxRadius: 8,
                        ),
                        margin: EdgeInsets.all(5),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child : AutoSizeText(
                          bowler[0].name + " :     "+bowler[0].overs.toStringAsFixed(1) + " - " + bowler[0].wicket.toString() + " - " + bowler[0].runsGiven.toString() + " - " + bowler[0].extra.toString(),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold , fontSize: 13,
                              fontFamily: 'Literata'),),),
                    ],
                  )
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 30),
                child:  AutoSizeText(
                  (!matchSummary.live) ? "Result :     " + matchSummary.result :
                  (matchSummary.firstInningsOver) ? "Target :     "+matchSummary.target.toString() : "",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Lemonada',
                  ),
                ),
              ),
            ],
          );
        }else if(snapshot.data == null){
          return Loading();
        }else{
          return Text("No Data");
        }
      },
    );
  }

  String getMatchBetween(List<Team> teams){
    return teams.first.teamName + " - " + teams.last.teamName;
  }

}