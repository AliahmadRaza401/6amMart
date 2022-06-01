import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_element

class SharedPref {
  static userLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userLoggedIn', value);
  }

  static getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool('userLoggedIn');
    return boolValue;
  }





  static saveUserId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', value);
  }

  static getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('userId');
    return value;
  }

  static saveUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', value);
  }

  static getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('userName');
    return value;
  }



 





}
