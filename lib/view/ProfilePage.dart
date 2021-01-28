
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/model/player.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

final primaryColor = const Color(0xFF75A2EA);
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
  var _height;

  @override
  initState(){
    playerProfile = SharedPrefUtil.getPlayerObject(Constant.PROFILE_KEY);
    print("Profile : "+ playerProfile.toString());
    _phoneNumber = TextEditingController(text: playerProfile.phoneNumber.toString());
    _name = TextEditingController(text: playerProfile.first_name);
    _city = TextEditingController(text: playerProfile.city);
    _typeAheadController = TextEditingController(text: playerProfile.city);
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
          Constant.EDIT_PROFILE_APP_BAR_TITLE,
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
                  backgroundImage: ExactAssetImage(
                      "lib/assets/images/default_profile_avatar.png"),
                  backgroundColor: Colors.transparent,
                  minRadius: 30,
                  maxRadius: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    children: buildInputs(context, editable),
                  ),
                ),
              ),


              SizedBox(height: _height * 0.05,),

              RaisedButton(
                color: primaryColor,
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
                  backgroundImage: ExactAssetImage(
                      "lib/assets/images/default_profile_avatar.png"),
                  backgroundColor: Colors.transparent,
                  minRadius: 30,
                  maxRadius: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    children: _EditProfile().buildInputs(context, false),
                  ),
                ),
              ),

              SizedBox(height: _height * 0.04),


              RaisedButton(
                color: primaryColor,
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
                  });
                },
              ),
            ],

          ),
        )
    );
  }

  List<Widget> buildInputs(BuildContext context, bool enabled) {
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
        suggestionsBoxVerticalOffset: -10.0,
        autoFlipDirection: true,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: 'city',
                icon: Icon(Icons.location_city, color: Constant.PRIMARY_COLOR,)
            ),
            style: TextStyle(fontFamily: "Lemonada",)
        ),
        suggestionsCallback: (pattern) {
          List filtteredCities = [];
          for(String city in cities){
            if(city.toLowerCase().startsWith(pattern.toLowerCase())){
              filtteredCities.add(city);
            }
            if(filtteredCities.length == 3) break;
          }
          return filtteredCities;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.location_city, color: Constant.PRIMARY_COLOR,),
            title: Text(suggestion, style: TextStyle(fontFamily: "Lemonada",),),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this._city.text = suggestion;
          this._typeAheadController.text = suggestion;
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


List<String> cities = ["Mumbai", "Pune", "Bhoj", "Bangalore", "Delhi"];

