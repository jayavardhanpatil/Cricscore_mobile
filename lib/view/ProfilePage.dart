
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/model/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
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
  bool showAppBar = true;

  _EditProfile({this.profileBodyType, this.showAppBar});

  Player playerProfile;

  bool loading = false;
  TextEditingController _phoneNumber, _name, _city, _dateTime, _typeAheadController;
  final DateFormat format = DateFormat('yyyy-MM-dd');

  var _height;

  @override
  initState(){
    playerProfile = SharedPrefUtil.getPlayerObject(Constant.PROFILE_KEY);
    print("Profile : "+ playerProfile.toString());
    _phoneNumber = TextEditingController(text: playerProfile.phoneNumber.toString());
    _name = TextEditingController(text: playerProfile.first_name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: new AppBar(
        title: AutoSizeText(
          Constant.EDIT_PROFILE_APP_BAR_TITLE,
          maxLines: 1,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: "Lemonada"
          ),
        ),
      ),
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
                  print(_phoneNumber.text.toString());
                  print(_name.text.toString());
                  print(_city.text.toString());
                  print(_dateTime.text.toString());
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

  // void showSuccessColoredToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     backgroundColor: Color.fromRGBO(44, 213, 83, 0.4),
  //     textColor: Colors.black87,
  //     gravity: ToastGravity.CENTER,
  //   );
  // }
  //
  // void showFailedColoredToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     backgroundColor: Color.fromRGBO(252, 26, 10, 0.4),
  //     textColor: Colors.black87,
  //     gravity: ToastGravity.CENTER,
  //   );
  // }

  List<Widget> buildInputs(BuildContext context, bool enabled) {
    List<Widget> textFields = [];
    textFields.add(
      TextField(
        controller: _name,
        enabled: enabled,
        decoration: InputDecoration(
            labelText: 'Name'

        ),

        style: TextStyle(fontSize: 15.0, fontFamily: "Lemonada",),
        //onChanged: (value) => _phoneNumber = value,
      ),
    );
    textFields.add(SizedBox(height: 10));


    textFields.add(SizedBox(height: 10));

    textFields.add(
      TextField(
        controller: _phoneNumber,
        enabled: enabled,
        decoration: InputDecoration(
            labelText: 'Phone '
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


