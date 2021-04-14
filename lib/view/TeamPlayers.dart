import 'dart:core';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/HTTPUtil.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/Team.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/widget/Loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SelectTeamPlayers extends StatefulWidget{

  Team team;

  SelectTeamPlayers({Key key, @required this.team,}) : super (key : key);

  _selectTeamPlayers createState() => _selectTeamPlayers(team: team);
}

class _selectTeamPlayers extends State<SelectTeamPlayers> {

  Team team;

  _selectTeamPlayers({this.team});

  var _height;
  var _width;

  bool _isLoadComplete = false;

  Map<String, Player> _selectedPlayers = new Map();

  Map<String, Player> _otherTeamselectedPlayers = new Map();

  initState() {
    initialSetUp();
    super.initState();
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
          team.teamName,
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
            margin: EdgeInsets.only(left: 20, top: 20, right: 0, bottom: 20),
            child: Row(
              children: [
                Container(
                  //alignment: Alignment.topLeft,
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
                          team.teamName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 5,),
                      Text(
                          team.teamCity.cityName,
                          style: TextStyle(fontSize: 12)
                      ),
                    ],
                  ),
                ),
                //addPlayersButton(team),
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
                          height: 0.55 * _height, //height of TabBarView
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(
                                  color: Colors.grey, width: 0.5))
                          ),
                          child: TabBarView(children: <Widget>[
                            Container(
                              child: selectedPlayers(context),
                            ),
                            Container(
                              child: Center(
                                child: teamPlayers(context, team.teamId),
                              ),
                            ),
                            Container(
                              child: playersForaGivenCity(context, team.teamCity
                                  .cityId),
                              //child: Text('Please search players from the grid', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
                            ),
                          ])
                      ),

                      addPlayersButton(team),

                    ])
            ),
          ),
        ],
      ),

    );
  }

  addPlayersButton(Team team) {
    return Container(
      //alignment: Alignment.bottomLeft,
      width: 0.9 * _width,
      child: Column(
        children: <Widget>[
          RaisedButton.icon(
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),

            padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
            label: AutoSizeText(
              "Done",
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              SharedPrefUtil.putObject(
                  team.teamName + "_" + Constant.SELECTED_PLAYERS,
                  _selectedPlayers);
              updateTeamPlayer(_selectedPlayers.values.toList());
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.done, color: Colors.white,),
//              label: Text("Players", style: TextStyle(
//                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
//              ),
          ),

        ],
      ),
    );
  }

  updateTeamPlayer(List<Player> _selectedPlayers) async {
    this.team.playerList = _selectedPlayers;
    //print(team.playerList.length);
    print("Team players added : for : "+team.teamName);
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

  Widget selectedPlayers(BuildContext context) {
    return FutureBuilder(
        future: loadSelectedPlayer(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            print("Snap shot is null");
            return Text("No data found");
          } else if (snapshot.hasData) {
            var players = snapshot.data.values.toList();
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: players.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 20),
                    leading: CircleAvatar(
                      backgroundImage: ExactAssetImage(
                          "lib/assets/images/default_profile_avatar.png"),
                      backgroundColor: Color(0xFF75A2EA),
                    ),
                    title: Text(
                      players[index].name,
                      style: TextStyle(fontFamily: "Lemonada",),
                    ),
                    subtitle: Text(
                        players[index].phoneNumber.toString()),
                  ),
                );
              },
            );
          } else {
            return Text("No players selected yet");
          }
        }
    );
  }

  Widget playersForaGivenCity(BuildContext context, int cityId) {
    return FutureBuilder(
        future: filterPlayers(cityId),
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
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.only(top: 10),
                      color: this._selectedPlayers.containsKey(
                          players[index].uuid) ? Color(0xFF6190E8) : null,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/default_profile_avatar.png"),
                          backgroundColor: Colors.black,
                        ),
                        title: Text(
                          players[index].name,
                          style: this._selectedPlayers.containsKey(
                              players[index].uuid) ? TextStyle(
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
                          style: this._selectedPlayers.containsKey(
                              players[index].uuid) ?
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lemonada",
                          ) : TextStyle(fontFamily: "Lemonada",),
                        ),
                        onTap: () {
                          setState(() {
                            if (!this._selectedPlayers.containsKey(
                                players[index].uuid)) {
                              _selectedPlayers.update(players[index].uuid,
                                      (value) => players[index],
                                  ifAbsent: () => players[index]);
                              //_selectedPlayers.add(players[index]);
                            } else {
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
              return Text(
                  "No players in your City \nYou may want to search by Player Name");
            }
          } else {
            return Text(
                "No players in your City \nYou may want to search by Player Name");
          }
        });
  }

  Widget teamPlayers(BuildContext context, int teamId) {
    return FutureBuilder(
        future: filterTeamPlayers(teamId),
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
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.only(top: 10),
                      //margin: const EdgeInsets.symmetric(vertical: 1),
                      color: this._selectedPlayers.containsKey(
                          players[index].uuid) ? Color(0xFF6190E8) : null,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                              "lib/assets/images/default_profile_avatar.png"),
                          backgroundColor: Colors.black,
                        ),
                        title: Text(
                          players[index].name,
                          style: this._selectedPlayers.containsKey(
                              players[index].uuid) ? TextStyle(
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
                          style: this._selectedPlayers.containsKey(
                              players[index].uuid) ?
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lemonada",
                          ) : TextStyle(fontFamily: "Lemonada",),
                        ),
                        onTap: () {
                          setState(() {
                            if (!this._selectedPlayers.containsKey(
                                players[index].uuid)) {
                              _selectedPlayers.update(players[index].uuid,
                                      (value) => players[index],
                                  ifAbsent: () => players[index]);
                              //_selectedPlayers.add(players[index]);
                            } else {
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
              return Text(
                  "No players in your City \nYou may want to search by Player Name");
            }
          } else {
            return Text(
                "No players in your City \nYou may want to search by Player Name");
          }
        });
  }

  Widget searchPlayerTextField(TextEditingController typeAheadTeamController,
      Team team) {
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
            leading: Icon(
              Icons.sports_cricket_sharp, color: Constant.PRIMARY_COLOR,),
            title: Text(
              suggestion.currentBattingteam, style: TextStyle(fontFamily: "Lemonada",),),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          typeAheadTeamController.text = suggestion.currentBattingteam;
          team.teamName = typeAheadTeamController.text;
        },
      ),
    );
  }

  Future<Map<String, Player>> loadSelectedPlayer() async {
    if (_selectedPlayers.isEmpty) {
      var players = await SharedPrefUtil.getObject(
          team.teamName + "_" + Constant.SELECTED_PLAYERS);

      if (players == null) {
        _selectedPlayers = new Map();
      }
      else {
        players.forEach((key, value) {
          _selectedPlayers.putIfAbsent(key, () => Player.fromJson(value));
        });
      }
    }
    return _selectedPlayers;
  }

  Future initialSetUp() async {
    await loadSelectedPlayer();

    var otherTeamName;

    if (team.teamName != Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_A)).teamName) {
      otherTeamName = Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_A)).teamName;
    } else {
      otherTeamName = Team.fromJson(SharedPrefUtil.getObject(Constant.TEAM_B)).teamName;
    }
    if(otherTeamName != null) {
      var players = await SharedPrefUtil.getObject(
          otherTeamName + "_" + Constant.SELECTED_PLAYERS);
      if (players == null) {
        _otherTeamselectedPlayers = new Map();
      } else {
        players.forEach((key, value) {
          _otherTeamselectedPlayers.putIfAbsent(
              key, () => Player.fromJson(value));
        });
      }
    }
    setState(() {
      _isLoadComplete = true;
    });
  }

  Future filterPlayers(int cityId) async {
    List<Player> playersList = await SharedPrefUtil.getPlayersFromtheCity(
        cityId);
    playersList = filter(playersList);
    return playersList;
  }

  Future filterTeamPlayers(int teamId) async {
    List<Player> playersList = await SharedPrefUtil.getTeamPlayers(teamId);
    return filter(playersList);
  }

  List<Player> filter(List<Player> playersList){
    List<Player> playingForOtherteam = [];
    if (_otherTeamselectedPlayers.isNotEmpty) {
      for (int i = 0; i < playersList.length; i++) {
        if (_otherTeamselectedPlayers.containsKey(playersList[i].uuid)) {
          playingForOtherteam.add(playersList[i]);
        }
      }
    }

    playingForOtherteam.forEach((element) {
      playersList.remove(element);
    });

    return playersList;
  }

}





