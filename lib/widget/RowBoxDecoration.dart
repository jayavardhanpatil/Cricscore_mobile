
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:flutter/material.dart';

Row rowWithText(String text){
  return Row(children: <Widget>[
    Expanded(
      child: new Container(
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Divider(
            color: Colors.black,
            height: 36,
          )),
    ),
    Container(
      decoration: getButtonGradientColor(BoxShape.circle),
      child: AutoSizeText(
        text,
        maxLines: 4,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: "Lemonada",
          color: Colors.white,

        ),
      ),
      padding: EdgeInsets.all(20.0),

    ),
    Expanded(
      child: new Container(
          margin: const EdgeInsets.only(left: 20.0, right: 10.0),
          child: Divider(
            color: Colors.black,
            height: 36,
          )),
    ),
  ]);
}

getButtonGradientColor(BoxShape shape){
  return BoxDecoration(
    shape: shape,
    borderRadius: (shape != BoxShape.circle) ? BorderRadius.circular(50) : null,
    gradient: LinearGradient(
        colors: <Color>[
          Constant.PRIMARY_COLOR,
          Color(0xFF1976D2),
          Constant.PRIMARY_COLOR
//         Color(0xFF090979),
//         Color(0xFF42A5F5),
//         Color(0xFF090979),
        ],
        stops: <double>[
          0.0, 0.5, 1.0
        ]
    ),
  );
}
