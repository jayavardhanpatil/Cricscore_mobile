import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/view/HomeView.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:flutter/material.dart';

class TossPage extends StatefulWidget{

  _TossPage createState() => _TossPage();

}

class _TossPage extends State<TossPage> {

  var _width;
  var _height;
  var _dialogWidth;

  List<String> _listOfTeams = [];
  Team _tossWonteam;
  int _currentSelectedIndex = -1;
  String _currentSelectedLabel = "";
  static const double padding = 20.0;

  initState(){
    _listOfTeams.add(Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_A)).teamName);
    _listOfTeams.add(Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_B)).teamName);
  }

  @override
  Widget build(BuildContext context) {
     return Dialog(
         elevation: 0,
         backgroundColor: Colors.transparent,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(padding),
         ),
         child: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {

    return Container(
      height: 350,
      child: Stack(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: CustomRadioButton(
                  height: _height * 0.06,
                  width: (_width * 0.5 / _listOfTeams.length),
                  enableShape: true,
                  elevation: 5,
                  customShape: (
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      )
                  ),
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: _listOfTeams,
                  buttonValues: _listOfTeams,
                  radioButtonValue: (value) {
                    print(value);
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
                  //width: (_width * 0.9 / _listOfTeams.length),
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
                    print(value);
                  },
                  selectedColor: Constant.PRIMARY_COLOR,
                ),
              ),
            ],
          ),

          SizedBox(height: _height * 0.05),

          Container(
            width: _width * 0.7,
            child: RaisedButton(
              color: Constant.PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: AutoSizeText(
                  "Toss Coin",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                //Sync with Server
                //Add Match Details in the SharedPreff
                //Add is Active Match to check if app is crashed retreive from where it was left
                Navigator.push(context, MaterialPageRoute(builder: (context) =>(TossPage())));
              },
            ),
          ),
        ],
      ),
    );
  }
}