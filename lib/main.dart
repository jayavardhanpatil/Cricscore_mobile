import 'package:cricscore/view/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefUtil().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Welcome!, Sign In to create Plyer profile!';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.deepOrange),
    home: HomePage(),
  );
}
