import 'dart:convert';

import 'package:cricscore/model/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil{
  static final SharedPrefUtil _instance = SharedPrefUtil._();
  static SharedPreferences _preferences;

  factory SharedPrefUtil(){
    return _instance;
  }

  SharedPrefUtil._();

  init() async {
    _preferences = await SharedPreferences.getInstance();
    print("Into Shared Pref Initialization : ");
  }

  //Add Object
  static Future<bool> putObject(String key, Object value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value == null ? "" : json.encode(value));
  }

  // get obj
  static T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  // get object
  static Map getObject(String key) {
    if (_preferences == null) return null;
    String _data = _preferences.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  // get object
  static Player getPlayerObject(String key) {
    if (_preferences == null) return null;
    return Player.fromJson(getObject(key));
  }

  // put object list
  static Future<bool> putObjectList(String key, List<Object> list) {
    if (_preferences == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _preferences.setStringList(key, _dataList);
  }
  // get obj list
  static List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }
  // get object list
  static List<Map> getObjectList(String key) {
    if (_preferences == null) return null;
    List<String> dataLis = _preferences.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }
  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }
  // put string
  static Future<bool> putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }
  // get bool
  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences.getBool(key) ?? defValue;
  }
  // put bool
  static Future<bool> putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences.setBool(key, value);
  }
  // get int
  static int getInt(String key, {int defValue = 0}) {
    if (_preferences == null) return defValue;
    return _preferences.getInt(key) ?? defValue;
  }
  // put int.
  static Future<bool> putInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences.setInt(key, value);
  }
  // get double
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_preferences == null) return defValue;
    return _preferences.getDouble(key) ?? defValue;
  }
  // put double
  static Future<bool> putDouble(String key, double value) {
    if (_preferences == null) return null;
    return _preferences.setDouble(key, value);
  }
  // get string list
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_preferences == null) return defValue;
    return _preferences.getStringList(key) ?? defValue;
  }
  // put string list
  static Future<bool> putStringList(String key, List<String> value) {
    if (_preferences == null) return null;
    return _preferences.setStringList(key, value);
  }
  // get dynamic
  static dynamic getDynamic(String key, {Object defValue}) {
    if (_preferences == null) return defValue;
    return _preferences.get(key) ?? defValue;
  }
  // have key
  static bool haveKey(String key) {
    if (_preferences == null) return null;
    return _preferences.getKeys().contains(key);
  }
  // get keys
  static Set<String> getKeys() {
    if (_preferences == null) return null;
    return _preferences.getKeys();
  }
  // remove
  static Future<bool> remove(String key) {
    if (_preferences == null) return null;
    return _preferences.remove(key);
  }
  // clear
  static Future<bool> clear() {
    if (_preferences == null) return null;
    return _preferences.clear();
  }
  //Sp is initialized
  static bool isInitialized() {
    return _preferences != null;
  }
}
