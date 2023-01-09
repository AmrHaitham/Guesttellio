import 'package:flutter/material.dart';

class Constants {
  static Color mainColor = const Color(0xff0e8a74);
  static Color titleTextColor =const Color(0xff000000);
  static Color screenTitleColor =const Color(0xffffffff);
  static Color textColor =const Color(0xff787878);
  // Form Error
  static final RegExp emailValidatorRegExp =
  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static  String kEmailNullError = "Please Enter Your Username";
  static  String kInvalidEmailError = "Please Enter Valid Email";
  static  String kPassNullError = "Please Enter Your Password";
  static  String kShortPassError ="Password Is Too Short";
  static  String kMatchPassError ="Passwords Don`t Match";

  //status codes:
//
// *1': Working Service
//
// *2: Scheduled Service
//
// *3: Pending Service
//
// *4: Escalated Service
//
// *5: Closed Service
//
// *6: Done Service
//
// priority code:
//
// *1: Request
//
// *2: Defect
//
// *3: Incident

static const List priority = ["Request","Defect","Incident"];
static const List status = ["Working Service","Scheduled Service","Pending Service","Escalated Service","Closed Service","Done Service"];
static const List statusColors = [
  Color(0xff0e8a74),
  Color(0xff6e6e6e),
  Color(0xffffa600),
  Color(0xfff72b50),
  Color(0xff000000),
  Color(0xff68cf29)];
}