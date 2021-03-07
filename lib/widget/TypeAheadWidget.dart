import 'package:cricscore/model/City.dart';
import 'package:cricscore/view/Teams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../Constants.dart';

Widget searchCity(TextEditingController typeAheadCityController, double fieldwidth, String fieldPlaceHolder){
  return Row(
    children: [
      Container(
        width: fieldwidth,
        padding: EdgeInsets.only(left: 20, right: 10),
        child: TypeAheadFormField(
          hideOnError: true,
          // direction: AxisDirection.down,
          suggestionsBoxVerticalOffset: -10.0,
          autoFlipDirection: true,
          hideOnLoading: true,
          getImmediateSuggestions: false,
          textFieldConfiguration: TextFieldConfiguration(
            controller: typeAheadCityController,
            enabled: true,
            decoration: InputDecoration(
              labelText: fieldPlaceHolder,
              //prefixIcon: Icon(Icons.search)
            ),
            style: TextStyle(fontFamily: "Lemonada",),
          ),
          suggestionsCallback: (pattern) async {
            List<City> filteredCities = await searchCities(pattern);
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
            typeAheadCityController.text = suggestion.cityName + ", " + suggestion.state;
          },
        ),
      ),

    ],
  );
}