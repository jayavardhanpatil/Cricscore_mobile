
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/view/TossPage.dart';
import 'package:cricscore/widget/RowBoxDecoration.dart';
import 'package:cricscore/widget/TypeAheadWidget.dart';
import 'package:flutter/material.dart';

class StartMatch extends StatefulWidget{

  _StartMatch createState() => _StartMatch();

}

class _StartMatch extends State<StartMatch>{

  Team _teamA;
  Team _teamB;

  var _width;
  var _height;

  TextEditingController typeAheadCityController;
  TextEditingController _oversController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _teamA = Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_A));
    _teamB = Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_B));
    typeAheadCityController = new TextEditingController();
    _oversController = new TextEditingController();

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
        title: Text("Start match"),
        ),

    body: Center(
        child: bodyView(),
      )
    );
  }


  Widget bodyView(){
    return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [

                        teamNameWidget(_teamA.teamName),

                        SizedBox(height: _height * 0.03),

                        viewSquadButtonWidget(_teamA),

                      ],
                    ),
                  ),

                  Container(
                    decoration: getButtonGradientColor(BoxShape.circle),
                    child: AutoSizeText(
                      "VS",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Lemonada",
                        color: Colors.white,

                      ),
                    ),
                    padding: EdgeInsets.all(10.0),
                  ),

                  Expanded(
                    child: Column(
                      children: [

                        teamNameWidget(_teamB.teamName),

                        SizedBox(height: _height * 0.03),

                        viewSquadButtonWidget(_teamB),
                      ],
                    ),
                  ),
                ]),

              SizedBox(height: _height * 0.03),

              Padding(
                padding: EdgeInsets.symmetric(horizontal:10.0),
                child: Container(
                    height:1.0,
                    width: _width * 0.8,
                    color:Colors.black
                ),
              ),

              SizedBox(height: _height * 0.04),

              Container(
                width: _width * 0.9,
                child: Column(
                  children: [
                    searchCity(typeAheadCityController, 0.9 * _width, "Select Match Venue")
                  ],
                ),
              ),

              SizedBox(height: _height * 0.01),

              Container(
                width: 0.3 * _width,
                padding: EdgeInsets.only(left: 20, right: 10),
                child: TextField(
                  //validator: Validator.validate,
                  controller: _oversController,
                  decoration: InputDecoration(
                    labelText: "Total Overs",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              RaisedButton(
                color: Constant.PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: AutoSizeText(
                    "Toss Coin",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      fontFamily: "Lemonada",
                    ),
                  ),
                ),
                onPressed: () async {
                    //Sync with Server
                    //Add Match Details in the SharedPreff
                    //Add is Active Match to check if app is crashed retreive from where it was left
                  //return await showDialog(context: context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>(TossPage())));
                  // showDialog(context: context,
                  //   builder: (context) => TossPage());
                },
              ),

            ],
          ),
      )
    );
  }

  Widget teamNameWidget(String teamName){
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      margin: const EdgeInsets.only(left: 10, right: 20),

      child: AutoSizeText(
        teamName,
        maxLines: 1,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget viewSquadButtonWidget(Team team){
    return RaisedButton(
      color: Constant.PRIMARY_COLOR,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: AutoSizeText(
          "Team Squad",
          maxLines: 1,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            fontFamily: "Lemonada",
          ),
        ),
      ),
      onPressed: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSquad(team: team1)));
      },
    );
  }

}