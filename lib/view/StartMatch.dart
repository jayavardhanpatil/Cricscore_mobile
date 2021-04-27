
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/MatchGame.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/view/TossPage.dart';
import 'package:cricscore/widget/RowBoxDecoration.dart';
import 'package:cricscore/widget/TypeAheadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'Teams.dart';

class StartMatch extends StatefulWidget{
  MatchGame matchGame;
  StartMatch({Key key, @required this.matchGame}) : super (key : key);
  _StartMatch createState() => _StartMatch(this.matchGame);

}

class _StartMatch extends State<StartMatch>{

  Team _teamA;
  Team _teamB;

  MatchGame matchGame;

  _StartMatch(this.matchGame);

  var _width;
  var _height;
  City matchVenue;

  final TextEditingController typeAheadCityController = new TextEditingController();
  final TextEditingController _oversController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _teamA = Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_A));
    _teamB = Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_B));
    // typeAheadCityController = new TextEditingController();
    // _oversController = new TextEditingController();typeAheadCityController = new TextEditingController();
    // _oversController = new TextEditingController();

    matchGame.teamA = _teamA;
    matchGame.teamB = _teamB;

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
                    searchCityForVenue(typeAheadCityController, 0.9 * _width, "Select Match Venue")
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

              SizedBox(height: 20,),

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
                  this.matchGame.totalOvers = int.parse(_oversController.text);
                    //Sync with Server
                    //Add Match Details in the SharedPreff
                    //Add is Active Match to check if app is crashed retreive from where it was left
                  //return await showDialog(context: context);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) =>(TossPage())));
                   showDialog(context: context,
                     builder: (context) => TossPage(matchGame: this.matchGame));
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

  Widget searchCityForVenue(TextEditingController typeAheadCityController, double fieldwidth, String fieldPlaceHolder){
    return Row(
      children: [
        Container(
          width: fieldwidth,
          padding: EdgeInsets.only(left: 20, right: 10),
          child: TypeAheadFormField(
            hideOnError: true,
            // direction: AxisDirection.down,
            suggestionsBoxVerticalOffset: -10.0,
            autoFlipDirection: true,
            hideOnLoading: true,
            getImmediateSuggestions: false,
            textFieldConfiguration: TextFieldConfiguration(
              controller: typeAheadCityController,
              enabled: true,
              decoration: InputDecoration(
                labelText: fieldPlaceHolder,
                //prefixIcon: Icon(Icons.search)
              ),
              style: TextStyle(fontFamily: "Lemonada",),
            ),
            suggestionsCallback: (pattern) async {
              List<City> filteredCities = await searchCities(pattern);
              return filteredCities;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: Icon(Icons.location_city, color: Constant.PRIMARY_COLOR,),
                title: Text(suggestion.cityName +", "+ suggestion.state, style: TextStyle(fontFamily: "Lemonada",),),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              this.matchGame.matchVenue = suggestion;
              typeAheadCityController.text = suggestion.cityName + ", " + suggestion.state;
            },
          ),
        ),

      ],
    );
  }

}