import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/widget/RowBoxDecoration.dart';
import 'package:cricscore/widget/TypeAheadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'StartMatch.dart';
import 'TeamPlayers.dart';



class _SelectTeams extends State<SelectTeam> {

  String todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _typeFirstAheadTeamController = TextEditingController();
  final _typeFirstAheadCityController = TextEditingController();
  final _typeSecondAheadTeamController = TextEditingController();
  final _typeSecondAheadCityController = TextEditingController();

  Team teamA;
  Team teamB;

  MatchGame matchgame;
  
  var _width;
  var _height;
  initState(){
    super.initState();
    matchgame = MatchGame();
    teamA = Team();
    teamB = Team();
  }

  @override
  Widget build(BuildContext context) {

     _width = MediaQuery
        .of(context)
        .size
        .width;
     _height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          "Select teams",
          maxLines: 1,
          style: TextStyle(
            fontFamily: "Lemonada",
          ),
        ),
      ),
      body: _selectTeamDisplay(),
    );
  }


  Widget _selectTeamDisplay(){
    return Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                searchTeamTextField(this._typeFirstAheadTeamController, true, this._typeFirstAheadCityController),
                SizedBox(height: 0.1,),

                Row(children: <Widget>[
                    Container(
                      child: searchCity(this._typeFirstAheadCityController, 0.5 * _width, "Select City"),
                    ),
                    Container(
                      child: addPlayersButton(teamA, true),
                    )
                  ],
                ),

                SizedBox(height: _height * 0.05,),

                rowWithText('vs'),

                SizedBox(height: _height * 0.05,),

                searchTeamTextField(this._typeSecondAheadTeamController, false, this._typeSecondAheadCityController),
                SizedBox(height: 0.1,),

                Row(children: <Widget>[
                  Container(
                    child: searchCity(this._typeSecondAheadCityController, 0.5 * _width, "Select City"),
                  ),
                  Container(
                    child: addPlayersButton(teamB, false),
                  )
                ],
                ),

                SizedBox(height: _height * 0.1,),
                RaisedButton(
                  color : Constant.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: AutoSizeText(
                      "Start Match",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontFamily: "Lemonada",
                      ),
                    ),
                  ),
                  onPressed: () {

                    //Create Match Id and store the details in Backend System
                    //
                    matchgame.teams.putIfAbsent(teamA.teamName, () => teamA);
                    matchgame.teams.putIfAbsent(teamB.teamName, () => teamB);
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>(StartMatch(matchGame: this.matchgame))));

                    // print(this._typeFirstAheadTeamController.text);
                    // print(this._typeFirstAheadCityController.text);
                    // print(this._typeSecondAheadTeamController.text);
                    // print(this._typeSecondAheadCityController.text);
                    //
                    // print(teamA.toJson());
                    // print(teamB.toJson());

                  },
                ),

              ],
            ),
          ],
        ),
    );
  }

  Widget searchTeamTextField(TextEditingController typeAheadTeamController, bool isFirstTeam, TextEditingController typeAheadCity){
    return Container(
      width: 0.9 * _width,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TypeAheadFormField(
        hideOnEmpty: true,
        hideOnError: true,
        //direction: AxisDirection.down,
        suggestionsBoxVerticalOffset: -10.0,
        autoFlipDirection: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: typeAheadTeamController,
          enabled: true,
          decoration: InputDecoration(
              labelText: 'select team',
              //suffixIcon: (_isTeamFound) ? null : Icon(Icons.add_circle_outline),
          ),
          style: TextStyle(fontFamily: "Lemonada",),
        ),
        suggestionsCallback: (pattern) async {
          List<Team> filteredTeams = await searchTeams(pattern);
          //List filteredTeams = await getTeams(pattern);
          // setState(() {
          //   if(filteredTeams.isEmpty){
          //     _isTeamFound = false;
          //   }else{
          //     _isTeamFound = true;
          //   }
          // });
          return filteredTeams;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.sports_cricket_sharp, color: Constant.PRIMARY_COLOR,),
            title: Text(suggestion.teamName + " ( " + suggestion.teamCity.cityName +" )", style: TextStyle(fontFamily: "Lemonada",),),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          typeAheadTeamController.text = suggestion.teamName;
          setState(() {
            if(isFirstTeam)
              teamA = suggestion;
            else
              teamB = suggestion;
          });
          typeAheadCity.text = suggestion.teamCity.cityName;
        },
      ),
    );
  }

  addPlayersButton(Team team, bool isteamA){

    if(isteamA){
      SharedPrefUtil.putObject(Constant.TEAM_A, team);
    }else{
      SharedPrefUtil.putObject(Constant.TEAM_B, team);
    }

    return Container(
      //width: 0.4 * _width,
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: <Widget>[
          RaisedButton.icon(
            color: Constant.PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),

            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            label: AutoSizeText(
              "Select Squad",
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                fontFamily: "Lemonada",
              ),
            ),
            onPressed: () {
              print("current Team Name : " + team.teamName);
              //Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTeamPlayers(team: team,)));
            },
            icon: Icon(Icons.add_circle, color: Colors.white,),
//              label: Text("Players", style: TextStyle(
//                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
//              )
          ),

        ],
      ),
    );
  }
}

Future<List<Team>> searchTeams(String pattern) async{
  List<Team> filteredTeams = [];
  if(pattern.isNotEmpty) {
    filteredTeams = await HttpUtil.searchTeams(pattern);
  }
  return filteredTeams;
}

Future<List<City>> searchCities(String pattern) async{
  List<City> filteredTeams = [];
  if(pattern.isNotEmpty) {
    filteredTeams = await HttpUtil.searchCity(pattern);
  }
  return filteredTeams;
}

class SelectTeam extends StatefulWidget{

  _SelectTeams createState() => _SelectTeams();

}
