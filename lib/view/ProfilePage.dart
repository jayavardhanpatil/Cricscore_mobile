
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/widget/Tost.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

enum ProfileBodyEnum { view, edit }

class EditProfile extends StatefulWidget {
  final ProfileBodyEnum profileBodyType;
  final bool showAppBar;

  EditProfile({Key key, @required this.profileBodyType, this.showAppBar}) : super(key: key);

  @override
  _EditProfile createState() =>
      _EditProfile(profileBodyType: this.profileBodyType, showAppBar: this.showAppBar);
}

class _EditProfile extends State<EditProfile> {
  ProfileBodyEnum profileBodyType;
  bool showAppBar;

  _EditProfile({this.profileBodyType, this.showAppBar});

  Player playerProfile;

  bool loading = false;
  TextEditingController _phoneNumber, _name, _city, _dob, _typeAheadController;
  final DateFormat format = DateFormat('yyyy-MM-dd');
  String appBarTitle = Constant.PROFILE_APP_BAR_TITLE;
  var _height;
  City _selectedCity;
  @override
  initState(){
    playerProfile = SharedPrefUtil.getPlayerObject(Constant.PROFILE_KEY);
    print("Profile : "+ playerProfile.toString());
    _phoneNumber = TextEditingController(text: (playerProfile.phoneNumber == null) ? '' : playerProfile.phoneNumber.toString());
    _name = TextEditingController(text: playerProfile.name);
    _city = TextEditingController(text: (playerProfile.city == null) ? null : playerProfile.city.cityName + ",  "+ playerProfile.city.state);
    _typeAheadController = TextEditingController(text: (playerProfile.city == null) ? null : playerProfile.city.cityName);
    _dob = TextEditingController(text: playerProfile.dateOfBirth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: showAppBar ? new AppBar(
        title: AutoSizeText(
          //Constant.EDIT_PROFILE_APP_BAR_TITLE,
          appBarTitle,
          maxLines: 1,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: "Lemonada"
          ),
        ),
      ):null,
      body: (profileBodyType == ProfileBodyEnum.edit) ? ProfileBody(context, true) : ProfileView(context, false),
    );
  }

  Widget ProfileBody(BuildContext context, bool editable) {
    return SingleChildScrollView(
        child: new Container(
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      (playerProfile.photoUrl == null) ?
                      "lib/assets/images/default_profile_avatar.png" : playerProfile.photoUrl),
                  backgroundColor: Colors.transparent,
                  minRadius: 30,
                  maxRadius: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    children: _buildInputs(context, editable),
                  ),
                ),
              ),


              SizedBox(height: _height * 0.05,),

              RaisedButton(
                color: Constant.PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: AutoSizeText(
                    "Save profile",
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
                  playerProfile.city = _selectedCity;
                  playerProfile.dateOfBirth = _dob.text;
                  playerProfile.phoneNumber = int.parse(_phoneNumber.text);

                  SharedPrefUtil.putObject(Constant.PROFILE_KEY, playerProfile);
                  setState(() {
                    profileBodyType = ProfileBodyEnum.view;
                    appBarTitle = Constant.PROFILE_APP_BAR_TITLE;
                    playerProfile = SharedPrefUtil.getPlayerObject(Constant.PROFILE_KEY);
                  });

                  print(playerProfile.toJson());

                  http.post(Constant.PROFILE_SERVICE_URL+"/players/add",
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(playerProfile.toJson()))
                      .then((value) => {
                      //print(value.body),
                      if(value.statusCode == 200)
                        showSuccessColoredToast("Profile added")
                      else
                        showFailedColoredToast("Failed to add Profile")
                    //_showSuccessColoredToast("Profile Added to server")
                    }
                  );
                },
              )

            ],

          ),
        )
    );
  }

  Widget ProfileView(BuildContext context, bool editable) {
    return SingleChildScrollView(
        child: new Container(
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      (playerProfile.photoUrl == null) ?
                      "lib/assets/images/default_profile_avatar.png" : playerProfile.photoUrl),
                  backgroundColor: Colors.transparent,
                  minRadius: 30,
                  maxRadius: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    children: _buildInputs(context, false),
                  ),
                ),
              ),

              SizedBox(height: _height * 0.04),


              RaisedButton(
                color: Constant.PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: AutoSizeText(
                    "Edit Profile",
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
                  setState(() {
                    profileBodyType = ProfileBodyEnum.edit;
                    appBarTitle = Constant.EDIT_PROFILE_APP_BAR_TITLE;
                  });
                },
              ),
            ],

          ),
        )
    );
  }

  List<Widget> _buildInputs(BuildContext context, bool enabled) {
    List<Widget> textFields = [];
    textFields.add(
      TextField(
        controller: _name,
        enabled: enabled,
        decoration: InputDecoration(
            labelText: 'Name',
            icon: Icon(Icons.person, color: Constant.PRIMARY_COLOR,)
        ),
        //style: TextStyle(fontSize: 15.0, fontFamily: "Lemonada",),
        //onChanged: (value) => _phoneNumber = value,
      ),
    );
    textFields.add(SizedBox(height: 10));

    textFields.add(
      TypeAheadFormField(
        direction: AxisDirection.up,
        suggestionsBoxVerticalOffset: 5.0,
        getImmediateSuggestions: false,
        //loadingBuilder: ,
        // suggestionsBoxDecoration: SuggestionsBoxDecoration(
        //   hasScrollbar: true,
        //
        // ),
        autoFlipDirection: true,
        hideOnError: true,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: 'city',
                icon: Icon(Icons.location_city, color: Constant.PRIMARY_COLOR,)
            ),
            style: TextStyle(fontFamily: "Lemonada",)
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
          _selectedCity = suggestion;
          playerProfile.city = suggestion as City;
          this._city.text = suggestion.cityName + ", " + suggestion.state;
          this._typeAheadController.text = suggestion.cityName + ", " + suggestion.state;
        },
      ),
    );
    textFields.add(SizedBox(height: 10));

    textFields.add(
      DateTimeField(
        enabled: enabled,
        format: format,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          icon: Icon(Icons.calendar_today, color: Constant.PRIMARY_COLOR,),
        ),
        style: TextStyle(fontFamily: "Lemonada",),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now());
        },
        controller: _dob,
        onChanged: (value) {
          setState(() {
            this._dob.text = format.format(value);
          });
        },
      ),
    );

    textFields.add(SizedBox(height: 10));

    textFields.add(
      TextField(
        controller: _phoneNumber,
        enabled: enabled,
        decoration: InputDecoration(
            labelText: 'Phone ',
          icon: Icon(Icons.phone, color: Constant.PRIMARY_COLOR,),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 15.0, fontFamily: "Lemonada",),
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        //onChanged: (value) => _phoneNumber,
      ),
    );
    textFields.add(SizedBox(height: 10));

    textFields.add(SizedBox(height: 10));
    return textFields;
  }

}

//List<String> cities = ["Mumbai", "Pune", "Bhoj", "Bangalore", "Delhi"];
//List<City> cities1 = [City(1, 'Mumbai', 'MH'), City(2, 'Bangalore', 'KA'), City(3, 'Bhoj', 'KA')];

