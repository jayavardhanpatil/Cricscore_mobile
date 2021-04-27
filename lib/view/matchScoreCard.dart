
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/MatchSummary.dart';
import 'package:cricscore/model/matchScoreCard.dart';
import 'package:cricscore/model/player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class MatchScoreCardView extends StatefulWidget{

  MatchSummary summary;

  MatchScoreCardView({Key key, @required this.summary,}) : super (key : key);

  _MatchScoreCard createState() => _MatchScoreCard(this.summary);

}

class _MatchScoreCard extends State<MatchScoreCardView> {

  MatchSummary matchSummary;

  var _height;
  var _width;

  Map<String, dynamic> liveScore;

  _MatchScoreCard(this.matchSummary);

  String firstInningsScore = "0-0";
  String secondInningsScore = "0-0";

  @override
  void initState(){
  liveScore = SharedPrefUtil.getObject("LIVE-"+this.matchSummary.matchTitile);

  if(liveScore != null){
  liveScore.forEach((key, value) {
    if(key == "FIRST"){
      firstInningsScore = value;
    }else{
      secondInningsScore = value;
    }
  });
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _height = MediaQuery
        .of(context)
        .size
        .height;

    _width = MediaQuery
        .of(context)
        .size
        .width;



    //return (_isLoadComplete) ? Loading() : Scaffold(
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          matchSummary.matchTitile,
          maxLines: 1,
          style: TextStyle(
            fontFamily: "Lemonada",
          ),
        ),
      ),
      body: _matchScoreCardWidget(),
    );
  }

  Widget _matchScoreCardWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 0, bottom: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                              matchSummary.firstBattingTeamName,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)
                          ),
                          Text(
                              firstInningsScore,
                              // matchSummary.firstInningsScore.run.toString() + "-" +
                              //     matchSummary.firstInningsScore.wickets.toString() :
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Column(
                        children: [
                          Text(
                              matchSummary.secondInningsTeamName,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                          ),
                          Text(
                            secondInningsScore,
                            // (matchSummary.secondInningsScore == null) ? "0-0" :
                            //   matchSummary.secondInningsScore.run.toString() + "-" +
                            //       matchSummary.secondInningsScore.wickets.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                (matchSummary.result != null) ? Text("Result : "+matchSummary.result) : Container(),
                (matchSummary.target != null) ? Text("Target : "+matchSummary.target.toString()) : Container(),
              ],
            ),
          ),

          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          //SizedBox(height: 0.05 * _height,),

          Container(
            child: DefaultTabController(
                length: 2, // length of tabs
                initialIndex: 0,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Colors.black,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Constant.PRIMARY_COLOR),
                          tabs: [
                            Tab(text: 'First Innings'),
                            Tab(text: 'Second Innings'),
                          ],
                        ),
                      ),

                      Container(
                          height: 0.55 * _height, //height of TabBarView
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(
                                  color: Colors.grey, width: 0.5))
                          ),
                          child: TabBarView(children: <Widget>[
                            Container(
                              child : inningsScoreCard(context, "FIRST"),
                            ),
                            Container(
                                child : inningsScoreCard(context, "SECOND"),
                            ),
                          ])
                      ),
                    ])
            ),
          ),
        ],
      ),

    );
  }

  Widget inningsScoreCard(BuildContext context, String inningsType){

      return FutureBuilder(
        future: getMatches(inningsType),
        builder: (context, snapShot){
          if (snapShot.data == null ||
              snapShot.connectionState == ConnectionState.waiting ||
              snapShot.hasError) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }else{
            MatchScoreCard scoreCard = snapShot.data;
            List<Player> battingPlayers = scoreCard.battingplayerScoreCard.values.toList();
            List<Player> bowlingPlayers = scoreCard.bowlingPlayerScoreCard.values.toList();

            //return Text("Hello");
            //Display Header data
            return getPlayerScoreDetails(context, battingPlayers, bowlingPlayers);
          }
        }
    );
  }


  Widget getPlayerScoreDetails(BuildContext context, List<Player> battingPlayers, List<Player> bowlingPlayers){
    return Container(
      child: Column(
        children: [
          getBattingPlayerScoreHeader(),
          getBattingPlayerScoreRow(battingPlayers),
          SizedBox(height: 20,),
          getBowlingPlayerScoreHeader(),
          getBowlingPlayerScoreRow(bowlingPlayers),
        ],
      ),
    );
  }

  Future getMatches(String inningsType) async{
    if(inningsType == "FIRST"){
      return (await HttpUtil.getMatchScoreCard(matchSummary.matchId.toString(), matchSummary.firstBattingTeamId.toString()));
    }else{
      return (await HttpUtil.getMatchScoreCard(matchSummary.matchId.toString(), matchSummary.secondBattingTeamId.toString()));
    }
  }

  Widget getBattingPlayerScoreHeader() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all()
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: _width * 0.4,
            child: Text("BATTING", style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("R", style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                Text("B", style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                Text("4's", style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                Text("6's", style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                Text("SR", style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget getBowlingPlayerScoreHeader() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all()
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: _width * 0.4,
            child: Text("BOWLING", style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("O", style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  Text("R", style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  Text("W", style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  Text("EC", style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  Text("Extr", style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              )
          )
        ],
      ),
    );

  }

  Widget getBattingPlayerScoreRow(List<Player> battingPlayers) {
    return ListView.builder(
      itemCount: battingPlayers.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: _width * 0.4,
                child: Text(battingPlayers[index].name),
              ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(battingPlayers[index].run.toString()),
                      Text(battingPlayers[index].ballsFaced.toString()),
                      Text(battingPlayers[index].numberOfFours.toString()),
                      Text(battingPlayers[index].numberOfsixes.toString()),
                      Text((battingPlayers[index].ballsFaced == 0) ? 0.toString() : ((battingPlayers[index].run / battingPlayers[index].ballsFaced) * 100).toInt().toStringAsFixed(2)),
                    ],
                  )
              )
            ],
          ),
        );
      }
    );
  }

  Widget getBowlingPlayerScoreRow(List<Player> bowlingPlayers) {
    bowlingPlayers.removeWhere((element) => element.overs == null);
    return ListView.builder(
        itemCount: bowlingPlayers.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black26))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: _width * 0.4,
                  child: Text(bowlingPlayers[index].name),
                ),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(bowlingPlayers[index].overs.toStringAsFixed(2)),
                        Text(bowlingPlayers[index].runsGiven.toString()),
                        Text(bowlingPlayers[index].wicket.toString()),
                        Text(bowlingPlayers[index].extra.toString()),
                        Text((bowlingPlayers[index].runsGiven / bowlingPlayers[index].overs).toStringAsFixed(2)),
                      ],
                    )
                )
              ],
            ),
          );
        }
    );

  }

}
