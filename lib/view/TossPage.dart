import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/Team.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'SelectOpeners.dart';

class TossPage extends StatefulWidget{

  MatchGame matchGame;
  TossPage({Key key, @required this.matchGame}) : super (key : key);
  _TossPage createState() => _TossPage(matchGame:this.matchGame);

}

class _TossPage extends State<TossPage> {

  MatchGame matchGame;

  var _width;
  var _height;

  List<Team> _listOfTeams = [];
  Team _tossWonteam;
  String selectedInning;
  Team battingTeam;
  Team bowlingTeam;

  _TossPage({MatchGame this.matchGame});

  static const double padding = 20.0;

  initState(){
    _listOfTeams = matchGame.teams.values.toList();
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


     return Dialog(
         elevation: 0,
         //backgroundColor: Colors.transparent,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(padding),
         ),
         child: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {

    return Container(
      height: _height * 0.45,
      width: _width * 0.7,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                "Who won the Toss?",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lemonada",
                ),
              ),

              SizedBox(height: _height * 0.01),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: CustomRadioButton(
                      height: _height * 0.06,
                      width: (_width * 0.6 / _listOfTeams.length),
                      enableShape: true,
                      elevation: 5,
                      customShape: (
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          )
                      ),
                      unSelectedColor: Theme.of(context).canvasColor,
                      buttonLables: _listOfTeams.map((e) => e.teamName).toList(),
                      buttonValues: _listOfTeams,
                      radioButtonValue: (value) {
                        setState(() {
                          _tossWonteam = value;
                        });

                      },
                      selectedColor: Constant.PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),

              SizedBox(height: _height * 0.03),

              AutoSizeText(
                "Select the Innings!",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lemonada",
                ),
              ),

              SizedBox(height: _height * 0.01),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: CustomRadioButton(
                      height: _height * 0.06,
                      width: (_width * 0.6 / _listOfTeams.length),
                      enableShape: true,
                      elevation: 5,
                      customShape: (
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          )
                      ),
                      unSelectedColor: Theme.of(context).canvasColor,
                      buttonLables: [Constant.BATTING, Constant.BOWLING],
                      buttonValues: [Constant.BATTING, Constant.BOWLING],
                      radioButtonValue: (value) {
                        setState(() {
                          print(value);
                          selectedInning = value;
                        });
                      },
                      selectedColor: Constant.PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),

              SizedBox(height: _height * 0.05),

              Container(
                width: _width * 0.5,
                child: RaisedButton(
                  color: Constant.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: AutoSizeText(
                      "Start Match",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {

                    Navigator.of(context).pop();
                   //Navigator.of(context).pop();

                    if(selectedInning == Constant.BATTING){
                      battingTeam = (_tossWonteam == _listOfTeams[0]) ? _listOfTeams[0] : _listOfTeams[1];
                      bowlingTeam = (_tossWonteam == _listOfTeams[0]) ? _listOfTeams[1] : _listOfTeams[0];
                    }else{
                      bowlingTeam = (_tossWonteam == _listOfTeams[0]) ? _listOfTeams[0] : _listOfTeams[1];
                      battingTeam = (_tossWonteam == _listOfTeams[0]) ? _listOfTeams[1] : _listOfTeams[0];
                    }

                    this.matchGame.tossWonTeam = _tossWonteam;
                    this.matchGame.selectedInning = selectedInning;

                    Navigator.push(context, MaterialPageRoute(builder: (context) =>(
                        SelectOpeners(batting: battingTeam, bowling: bowlingTeam, matchGame: this.matchGame,))));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}