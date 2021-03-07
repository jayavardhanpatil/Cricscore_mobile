
import 'package:cricscore/view/TossPage.dart';
import 'package:flutter/material.dart';

class DialogHelper{

  static exit(context) => showDialog(context: context, builder: (context) =>
    TossPage());

}