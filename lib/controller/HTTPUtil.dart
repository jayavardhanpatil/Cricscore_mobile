
import 'dart:convert';

import 'package:cricscore/model/City.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/widget/Tost.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';

class HttpUtil {

  Map<String, String> _header = {
    "Content-Type": 'application/json; charset=UTF-8',
  };

  addProfiletoServer(Player playerProfile) {
    // http.post(Constant.PROFILE_SERVICE_URL + "/players/add",
    //     headers: _header,
    //     body: jsonEncode(playerProfile.toJson()))
    //     .then((value) =>
    //   {
    //     print(value.body),
    //     if(value.statusCode == 200)
    //       showSuccessColoredToast("Profile added")
    //     else
    //       showFailedColoredToast("Failed to add Profile")
    //   }
    // );
  }

  List<City> getCities() {
    List<City> cities;
    print(Constant.MATCHE_SERVICE_URL+"/cities");
    http.get(Constant.MATCHE_SERVICE_URL+"/cities").then((value) => {
        print("Response Body : "+value.body),
        //cities.add(City(1, "Delhi", "DL"))
      }
    );
    return cities;
  }

  // Future getCitiesFromServer() async{
  //   return await
  // }

}