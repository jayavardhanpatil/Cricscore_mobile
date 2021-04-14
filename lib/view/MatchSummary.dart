
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/controller/database_service.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/CurrentPlayer.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/MatchSummary.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/view/Teams.dart';
import 'package:cricscore/widget/Loader.dart';
import 'package:cricscore/widget/RowBoxDecoration.dart';
import 'package:flutter/material.dart';

class MatchSummaryPage extends StatefulWidget{

  _MatchSummary createState() => _MatchSummary();

}

class _MatchSummary extends State<MatchSummaryPage>{


  String usercity;
  Future matches;
  MatchGame game;
  bool loading = true;
  List<MatchSummary> _matches = [];
  List<Player> batsmansplayers;
  List<Player> bowler;

  @override
  void initState() {
    Player player = Player.fromJson(SharedPrefUtil.getObject(Constant.PROFILE_KEY));
    usercity = player.city.cityName;

    matches = getMatches();
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
              RaisedButton(
                  color: Constant.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: AutoSizeText(
                        "Test",
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                  ),
                  onPressed: () {
                    //HttpUtil.getMatchSummary("44");
                  }),
             // matchListView(context),
            ],
          ),
        ),
      ),
    );
  }

  Future getMatches() {

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
              print("Match 1");
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
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        color : (_matches[index].live) ? null : Color.fromRGBO(255, 255, 255, 0.2),
        child: (_matches[index] != null ) ? updateGameData(_matches[index]) : Container(),
      ),
    );
  }

  Widget updateGameData(MatchSummary matchSummary){
    return StreamBuilder<MatchSummary>(
      //stream: ,
      builder: (context, snapshot){
        if(snapshot.hasData){
          matchSummary = snapshot.data;
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
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.all(5),
                    child : Text("Live", textAlign: TextAlign.center,style: TextStyle(fontSize: 10,
                    ),),
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
                                  : matchSummary.secondInningsScore.run.toString() + "/" + matchSummary.secondInningsScore.wickets.toString(),
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
                              matchSummary.secondInningsTramName,
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
                              (matchSummary.firstInningsOver && matchSummary.live) ? matchSummary.secondInningsScore.run.toString() + "/" + matchSummary.secondInningsScore.wickets.toString()
                                  : matchSummary.firstInningsScore.run.toString() + "/" + matchSummary.firstInningsScore.wickets.toString(),
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

  StreamController<String> streamController = StreamController();

  void newMessage(int number, String message) {
    final duration = Duration(seconds: number);
    Timer.periodic(duration, (Timer t) => streamController.add(message));
  }


  void dispose() {
    streamController.close();
    super.dispose();
  }
}