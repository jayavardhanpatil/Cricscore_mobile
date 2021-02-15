
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/Team.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TeamSelect extends StatefulWidget{

  _teamSelect createState() => _teamSelect();
}

class _teamSelect extends State<TeamSelect>{
  bool _isNoItemFound = false;
  String _selectTeamAppBarTitle = "Select Team A";
  TextEditingController _typeAheadTeamController;
  TextEditingController _typeAheadCityController;
  Team _team;
  City _city;
  var _height;
  var _width;
  initState(){
    _isNoItemFound = false;
    super.initState();
    if(SharedPrefUtil.haveKey(Constant.TEAM_A)){
      _selectTeamAppBarTitle = "Select Team B";
    }
    _typeAheadTeamController = new TextEditingController();
    _typeAheadCityController = new TextEditingController();
    _team = Team();
    _city = City();
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


    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: AutoSizeText(
            _selectTeamAppBarTitle,
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 0.9 * _width,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TypeAheadFormField(
              hideOnEmpty: true,
              hideOnError: true,
              direction: AxisDirection.down,
              suggestionsBoxVerticalOffset: -10.0,
              autoFlipDirection: true,
              textFieldConfiguration: TextFieldConfiguration(
                controller: this._typeAheadTeamController,
                enabled: true,
                decoration: InputDecoration(
                    labelText: 'select team',
                    border: OutlineInputBorder()
                ),
                style: TextStyle(fontFamily: "Lemonada",),
              ),
              suggestionsCallback: (pattern) async {
                List filteredTeams = await getTeams(pattern);
                setState(() {
                  if(filteredTeams.isEmpty) _isNoItemFound = true;
                  else _isNoItemFound = false;
                });

                return filteredTeams;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.sports_cricket_sharp, color: Constant.PRIMARY_COLOR,),
                  title: Text(suggestion.teamName, style: TextStyle(fontFamily: "Lemonada",),),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                //this._city.text = suggestion;
                this._team = suggestion as Team;
                this._typeAheadTeamController.text = suggestion.teamName;
              },
            ),

          ),

          SizedBox(height: 1,),

          Row(
            children: [
              Container(
                width: 0.5 * _width,
                padding: EdgeInsets.only(left: 20, right: 10),
                child: TypeAheadFormField(
                  hideOnError: true,
                  direction: AxisDirection.down,
                  suggestionsBoxVerticalOffset: -10.0,
                  autoFlipDirection: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._typeAheadCityController,
                    enabled: true,
                    decoration: InputDecoration(
                      labelText: 'select City',
                    ),
                    style: TextStyle(fontFamily: "Lemonada",),
                  ),
                  suggestionsCallback: (pattern) async {
                    List filteredCities = [];
                    for(City city in await SharedPrefUtil.getCities()){
                      print(city.toJson());
                      if(city.cityName != null) {
                        if (city.cityName.toLowerCase().startsWith(
                            pattern.toLowerCase())) {
                          filteredCities.add(city);
                        }
                      }
                      if(filteredCities.length == 10) break;
                    }
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
                    //this._city.text = suggestion;
                    this._city = suggestion as City;
                    this._typeAheadCityController.text = suggestion.cityName + ", " + suggestion.state;
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 0.05 * _width),
                child: (_isNoItemFound) ? RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AutoSizeText(
                      "Add team",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontFamily: "Lemonada",
                      ),
                    ),
                  ),
                  color: Constant.PRIMARY_COLOR,

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    setState(() {
                      _isNoItemFound = false;
                    });

                    this._team.city = this._city;
                    HttpUtil.addteam(this._team);
                  },
                ) : null,
              )
            ],
          ),


          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          //SizedBox(height: 0.05 * _height,),

          Container(
            child: DefaultTabController(
                length: 3, // length of tabs
                initialIndex: 0,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[

                  Container(
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.black,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Constant.PRIMARY_COLOR),
                      tabs: [
                        Tab(text: 'Playing Squad'),
                        Tab(text: 'Team Squad'),
                        Tab(text: 'Add Player'),
                      ],
                    ),
                  ),

                  Container(
                      height: 400, //height of TabBarView
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                      ),
                      child: TabBarView(children: <Widget>[
                        Container(
                          child: GridView.count(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            crossAxisCount: 3,
                            // Generate 100 widgets that display their index in the List.
                            children: List.generate(5, (index) {
                              return Center(
                                child: Text(
                                  'Item $index',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              );
                            }),

                          ),
                        ),

                        // Container(
                        //   child: Center(
                        //     child: Text('No squad selected', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        //   ),
                        // ),
                        Container(
                          child: Center(
                            child: Text('Please select players from the grid', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text('Please search players from the grid', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ])
                  )
                ])
            ),
          ),
        ],
      ),

    );
  }

  Future<List<Team>> getTeams(String pattern) async{
    List<Team> filteredTeams = await HttpUtil.getTeams();
    for(Team team in filteredTeams){
      print(team.toJson());
      if(team.teamName != null) {
        if (team.teamName.toLowerCase().startsWith(
            pattern.toLowerCase())) {
          filteredTeams.add(team);
        }
      }
      if(filteredTeams.length == 10) break;
    }
    return filteredTeams;
  }
}