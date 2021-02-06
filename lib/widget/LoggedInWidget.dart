import 'dart:convert';

import 'package:cricscore/controller/GoogleSignIn.dart';
import 'package:cricscore/view/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';

class LoggedInWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Player player = new Player()
       ..first_name = user.displayName
       ..uuid = user.uid
       ..email = user.email
       ..photoUrl = user.photoURL;

    SharedPrefUtil.putObject(Constant.PROFILE_KEY, player);

    print(SharedPrefUtil.getObject(Constant.PROFILE_KEY));

    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logged In',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          CircleAvatar(
            maxRadius: 25,
            backgroundImage: NetworkImage(user.photoURL),
          ),
          SizedBox(height: 8),
          Text(
            'Name: ' + user.displayName,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Email: ' + user.email,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            child: Text('Logout'),
          )
        ],
      ),
    );
  }
}