import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/LoginScreen.dart';

class AdminActions{

  static logout(context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignForm())
    );
  }

}