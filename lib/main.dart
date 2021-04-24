import 'package:cricscore/Constants.dart';
import 'package:cricscore/view/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';

import 'model/player.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefUtil().init();
  Player profile = SharedPrefUtil.getPlayerObject(Constant.PROFILE_KEY);
  SharedPrefUtil.clear();
  SharedPrefUtil.putObject(Constant.PROFILE_KEY, profile);
  await SharedPrefUtil.fetchCities();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Welcome!, Sign In to create Player profile!';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(
      primaryColor: Color(Constant.PRIMARY_THEME_COLOR),
    ),
    home: HomeController(),
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => HomeController(),
    },
  );
}
