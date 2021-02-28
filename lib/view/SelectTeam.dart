
import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/widget/Loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'StartMatch.dart';

class TeamSelect extends StatefulWidget{

  _teamSelect createState() => _teamSelect();
}

class _teamSelect extends State<TeamSelect> {
  bool _isNoItemFound = false;
  String _selectTeamAppBarTitle = "Select Team A";
  TextEditingController _typeAheadPlayerController;
  Team _team;
  City _city;
  var _height;
  var _width;
  Map<String, Player> _listofUsers = new Map();
  Map<String, Player> _selectedPlayers = new Map();

  initState(){
    _isNoItemFound = false;
    super.initState();
    if (SharedPrefUtil.haveKey(Constant.TEAM_A)) {
      _selectTeamAppBarTitle = "Select Team B";
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


  Widget _selectTeamDisplay() {
    return SingleChildScrollView(
      child: Column(
        children: [

          Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),

            child: Row(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: new ExactAssetImage(
                              'lib/assets/images/default_profile_avatar.png'),
                          fit: BoxFit.fill
                      ),
                      color: Constant.PRIMARY_COLOR
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Text(
                          'Team A',
                          style: TextStyle(fontSize: 18)
                      ),
                      SizedBox(height: 5,),
                      Text(
                          'Bangalore',
                          style: TextStyle(fontSize: 12)
                      ),
                    ],
                  ),
                )
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
                length: 3, // length of tabs
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
                            Tab(text: 'Playing Squad'),
                            Tab(text: 'Team Squad'),
                            Tab(text: 'Add Player'),
                          ],
                        ),
                      ),

                      Container(
                          height: 400, //height of TabBarView
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(
                                  color: Colors.grey, width: 0.5))
                          ),
                          child: TabBarView(children: <Widget>[
                            Container(
                                child : selectedPlayers(context),
                            ),
                            Container(
                              child: Center(
                                child: teamPlayers(context, 30),
                              ),
                            ),
                            Container(
                              child: playersForaGivenCity(context, 12),
                                      //child: Text('Please search players from the grid', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
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

  Future<List<Team>> getTeams(String pattern) async {
    List<Team> filteredTeams = await HttpUtil.getTeams();
    for (Team team in filteredTeams) {
      print(team.toJson());
      if (team.teamName != null) {
        if (team.teamName.toLowerCase().startsWith(
            pattern.toLowerCase())) {
          filteredTeams.add(team);
        }
      }
      if (filteredTeams.length == 10) break;
    }
    return filteredTeams;
  }

  Widget selectedPlayers(BuildContext context){
    List<Player> selectedPlayers = _selectedPlayers.values.toList();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: selectedPlayers.length,
      itemBuilder: (context, index){
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 20),
            leading: CircleAvatar(
              backgroundImage: ExactAssetImage(
                  "lib/assets/images/default_profile_avatar.png"),
              backgroundColor: Color(0xFF75A2EA),
            ),
            title: Text(
              selectedPlayers[index].name,
              style: TextStyle(fontFamily: "Lemonada",),
            ),
                subtitle: Text(
                  selectedPlayers[index].phoneNumber.toString()),
          ),
        );
      },
    );
  }

  Widget playersForaGivenCity(BuildContext context, int cityId) {
    return FutureBuilder(
        future: SharedPrefUtil.getPlayersFromtheCity(cityId),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            print("Snap shot is null");
            return Loading();
          } else if (snapshot.hasData) {
            List<Player> players = snapshot.data;
            if (players.length > 0) {

                 return ListView.builder(
                  itemCount: players.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      color: this._selectedPlayers.containsKey(players[index].uuid) ? Color(0xFF6190E8) : null,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/default_profile_avatar.png"),
                          backgroundColor: Colors.black,
                        ),
                        title: Text(
                          players[index].name,
                          style: this._selectedPlayers.containsKey(players[index].uuid) ? TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lemonada",
                          ) : TextStyle(fontFamily: "Lemonada",),
                        ),
                        subtitle: Text(
                          players[index].phoneNumber.toString().substring(
                              0, 3) + "****" +
                              players[index].phoneNumber.toString().substring(
                                  players[index].phoneNumber
                                      .toString()
                                      .length - 3),
                          style: this._selectedPlayers.containsKey(players[index].uuid) ?
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lemonada",
                          ) : TextStyle(fontFamily: "Lemonada",),
                        ),
                        onTap: () {
                          setState(() {
                            if(!this._selectedPlayers.containsKey(players[index].uuid)){
                              _selectedPlayers.update(players[index].uuid,
                                      (value) => players[index],ifAbsent: () => players[index]);
                              //_selectedPlayers.add(players[index]);
                            }else{
                              _selectedPlayers.remove(players[index].uuid);
                            }
                            //_selectedPlayers[index] = !_selected[index];
                            print(_selectedPlayers.toString());
                          });
                        },
                      ),
                    );
                  }
              );
            }
            else {
              return Text("No players in your City \nYou may want to search by Player Name");
            }
          } else {
            return Text("No players in your City \nYou may want to search by Player Name");
          }
        });
  }

  Widget teamPlayers(BuildContext context, int teamId) {
    return FutureBuilder(
        future: SharedPrefUtil.getTeamPlayers(teamId),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            print("Snap shot is null");
            return Loading();
          } else if (snapshot.hasData) {
            List<Player> players = snapshot.data;
            if (players.length > 0) {
              return ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      color: this._selectedPlayers.containsKey(players[index].uuid) ? Color(0xFF6190E8) : null,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/default_profile_avatar.png"),
                          backgroundColor: Colors.black,
                        ),
                        title: Text(
                          players[index].name,
                          style: this._selectedPlayers.containsKey(players[index].uuid) ? TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lemonada",
                          ) : TextStyle(fontFamily: "Lemonada",),
                        ),
                        subtitle: Text(
                          players[index].phoneNumber.toString().substring(
                              0, 3) + "****" +
                              players[index].phoneNumber.toString().substring(
                                  players[index].phoneNumber
                                      .toString()
                                      .length - 3),
                          style: this._selectedPlayers.containsKey(players[index].uuid) ?
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lemonada",
                          ) : TextStyle(fontFamily: "Lemonada",),
                        ),
                        onTap: () {
                          setState(() {
                            if(!this._selectedPlayers.containsKey(players[index].uuid)){
                              _selectedPlayers.update(players[index].uuid,
                                      (value) => players[index],ifAbsent: () => players[index]);
                              //_selectedPlayers.add(players[index]);
                            }else{
                              _selectedPlayers.remove(players[index].uuid);
                            }
                            //_selectedPlayers[index] = !_selected[index];
                            print(_selectedPlayers.toString());
                          });
                        },
                      ),
                    );
                  }
              );
            }
            else {
              return Text("No players in your City \nYou may want to search by Player Name");
            }
          } else {
            return Text("No players in your City \nYou may want to search by Player Name");
          }
        });
  }

  Widget searchPlayerTextField(TextEditingController typeAheadTeamController, Team team){
    return Container(
      width: 0.9 * _width,
      //margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
            labelText: 'search Player',
            //border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          style: TextStyle(fontFamily: "Lemonada",),
        ),
        suggestionsCallback: (pattern) async {
          List filteredTeams = await SharedPrefUtil.searchPlayer(pattern);
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
          typeAheadTeamController.text = suggestion.teamName;
          team.teamName = typeAheadTeamController.text;
        },
      ),
    );
  }

}

