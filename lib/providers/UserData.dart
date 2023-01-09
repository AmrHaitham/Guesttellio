import 'package:flutter/material.dart';
class UserData with ChangeNotifier{
  String _token = "";

  String get token => _token;

  void setUserToken(String token){
    _token = token;
    notifyListeners();
  }

  String _email = "";

  String get email => _email;

  void setUserEmail(String email){
    _email = email;
    notifyListeners();
  }

  String _name = "";

  String get name => _name;

  void setUserName(String name){
    _name = name;
    notifyListeners();
  }

  String _lastname = "";

  String get lastname => _lastname;

  void setUserLastName(String lastname){
    _lastname = lastname;
    notifyListeners();
  }

  String _phone = "";

  String get phone => _phone;

  void setUserPhone(String phone){
    _phone = phone;
    notifyListeners();
  }

  String _department = "";

  String get department => _department;

  void set_department(String par){
    _department = par;
    notifyListeners();
  }

  String _job = "";

  String get Job => _job;

  void set_job(String par){
    _job = par;
    notifyListeners();
  }

  int _assigned_services = 0;

  int get Assigned_services => _assigned_services;

  void set_assigned_services(int par){
    _assigned_services = par;
    notifyListeners();
  }

  int _old_services = 0;

  int get Old_services => _old_services;

  void set_old_services(int par){
    _old_services = par;
    notifyListeners();
  }

}