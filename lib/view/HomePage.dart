import 'package:cricscore/controller/GoogleSignIn.dart';
import 'package:cricscore/view/HomeView.dart';
import 'package:cricscore/view/ProfilePage.dart';
import 'package:cricscore/widget/BackGroundPaintWidget.dart';
import 'package:cricscore/widget/Loader.dart';
import 'package:cricscore/widget/LoggedInWidget.dart';
import 'package:cricscore/widget/SignUpWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);
          if (provider.isSigningIn) {
            return Loading();
          } else if (snapshot.hasData) {
            return HomeView();
            //return EditProfile(profileBodyType: ProfileBodyEnum.view, showAppBar: true,);
            //return LoggedInWidget();
          } else {
            return SignUpWidget();
          }
        },
      ),
    ),
  );
}

