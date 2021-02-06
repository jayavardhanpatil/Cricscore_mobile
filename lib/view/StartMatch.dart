import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/widget/RowBoxDecoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class _StartMatch extends State<StartMatch> {

  String previousvalueFirstTeam = "";
  String previousvalueSecondteam = "";

  String todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  TextEditingController _firstTteamName = TextEditingController();
  final _secondTteamName = TextEditingController();
  final _firstTeamCity = TextEditingController();
  final _secondTeamCity = TextEditingController();
  final __typefirstAheadController = TextEditingController();
  final __typesecondAheadController = TextEditingController();
  //final _venueCity = TextEditingController();
  final _venuetypeAheadController = TextEditingController();

  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
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
      body: Center(

       // padding: EdgeInsets.all(10),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: _height * 0.01),

            TextField(
              //validator: Validator.validate,
              controller: _firstTteamName,
              decoration: inputDecoration("Team A Name"),
              onTap: (){
                previousvalueFirstTeam = _firstTteamName.text;
              },
              style: TextStyle(fontFamily: "Lemonada",),
            ),

            SizedBox(height: _height * 0.01),

            Row(children: <Widget>[
              Container(
                //child: typeAhed(__typefirstAheadController, _firstTeamCity, _width * 0.5, "Team A City"),
              ),

              Container(
                child: addPlayersButton(_firstTteamName.text, previousvalueFirstTeam, _firstTeamCity.text),
              ),
            ]),

            //rowWithCityAndPlayer(__typefirstAheadController, _firstTeamCity, _width * 0.5, _firstTteamName, "Team A City"),


            SizedBox(height: _height * 0.05),

            rowWithText("VS"),

            SizedBox(height: _height * 0.04),

            TextFormField(
              controller: _secondTteamName,
              decoration: inputDecoration("Team B Name"),
              onTap: (){
                previousvalueSecondteam = _secondTteamName.text;
              },
              style: TextStyle(fontFamily: "Lemonada",),

            ),

            SizedBox(height: _height * 0.01),

            Row(children: <Widget>[
              Container(
                //child: typeAhed(__typesecondAheadController, _secondTeamCity, _width * 0.5, "Team B City"),
              ),

              Container(
                child: addPlayersButton(_secondTteamName.text, previousvalueSecondteam, _secondTeamCity.text),
              ),
            ]),

            SizedBox(height: _height * 0.07),

            //SilderButton("Slide to Start a match", _height * 0.09, _width * 0.8, context),


            RaisedButton(
              color: Constant.PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                print("after changin the value : "+ _firstTteamName.text);
                String matchBetween = "";

                Navigator.pop(context);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => StartMatch(match: match)));
              },
            ),
          ],
        ),
      ),

    );
  }

  inputDecoration(String lable){
    return new InputDecoration(
      labelText: lable,
      fillColor: Colors.white,
//      border: new OutlineInputBorder(
//        borderRadius: new BorderRadius.circular(5.0),
//      ),
    );
  }



  addPlayersButton(String currentTeamName,  String previousTeamName, String teamCity){

    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Column(
        children: <Widget>[

          RaisedButton.icon(
            color: Constant.PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),

            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            label: AutoSizeText(
              "Players",
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                fontFamily: "Lemonada",
              ),
            ),
            onPressed: () {
              print("current Team Name : " + currentTeamName);
              print("Previous Team name : " + previousTeamName);
            },
            icon: Icon(Icons.add, color: Colors.white,),
//              label: Text("Players", style: TextStyle(
//                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
//              ),
          ),

        ],
      ),
    );
  }

}

class StartMatch extends StatefulWidget{

  _StartMatch createState() => _StartMatch();

}
