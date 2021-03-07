// import 'package:flutter/material.dart';
//
// Widget CalendarField(){
//   DateTimeField(
//     enabled: enabled,
//     format: format,
//     decoration: InputDecoration(
//       labelText: 'Date of Birth',
//       icon: Icon(Icons.calendar_today, color: Constant.PRIMARY_COLOR,),
//     ),
//     style: TextStyle(fontFamily: "Lemonada",),
//     onShowPicker: (context, currentValue) {
//       return showDatePicker(
//           context: context,
//           firstDate: DateTime(1950),
//           initialDate: currentValue ?? DateTime.now(),
//           lastDate: DateTime.now());
//     },
//     controller: _dob,
//     onChanged: (value) {
//       setState(() {
//         this._dob.text = format.format(value);
//       });
//     },
//   ),
// }