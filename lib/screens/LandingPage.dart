import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guesttellio/helper/actions.dart';
import 'package:guesttellio/networks/GetServices.dart';
import 'package:guesttellio/networks/UserProfile.dart';
import 'package:guesttellio/providers/UserData.dart';
import 'package:guesttellio/screens/LoginScreen.dart';
import 'package:guesttellio/screens/MainScreen.dart';
import 'package:guesttellio/widgets/Constants.dart';
import 'package:guesttellio/widgets/Loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/Dialogs.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool errorFlag = false;

  final UserProfile _userProfile = UserProfile();
  final GetServices _getServices = GetServices();
  Dialogs _dialog = Dialogs();
  saveUserInfo()async{
    try{
      var response =await _userProfile.getUserProfileData(context.read<UserData>().token);
      if(response!=null){
        print("saveUserInfo response:- ${response}");
        if(response["detail"]=="Invalid token."||response["detail"]=="Not found."){
          _dialog.warningDialog(context, "Pleace Login Again",(){
            AdminActions.logout(context);
          },
              "Logout"
          );
        }else{
          context.read<UserData>().setUserPhone(response['phone']);
          context.read<UserData>().setUserName(response['first_name']);
          context.read<UserData>().setUserLastName(response['last_name']);
          context.read<UserData>().setUserEmail(response['username']);
          context.read<UserData>().set_department(response['department']);
          context.read<UserData>().set_job(response['job']);
          print("name is :- ${context.read<UserData>().name}");
          print("phone is :- ${context.read<UserData>().phone}");
        }
      }else{
        // _dialog.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
      }
      errorFlag = false;
    }catch(error){
      print(error);
      errorFlag = true;
      print("network errorss");
    }
  }
   get_services_stats()async{
    try{
      var response =await _getServices.get_services_stats(context.read<UserData>().token);
      if(response != null){
        context.read<UserData>().set_assigned_services(response['assigned_services']);
        context.read<UserData>().set_old_services(response['old_services']);
      }else{
        print(response);
        errorFlag = true;
      }
    }catch(v){
      errorFlag = true;
      print(v);
    }
  }
  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('logedIn') ?? false;
    print("log in status is :- ${status}");
    print("user email is :- ${prefs.getString("email")}");
    print("user token is :- ${prefs.getString("token")}");
    if (status) {
      context.read<UserData>().setUserEmail(prefs.getString("email").toString());
      context.read<UserData>().setUserToken(prefs.getString("token").toString());
      try{
        await saveUserInfo();
        await get_services_stats();
        if(!errorFlag){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen())
          );
        }else{
          _dialog.errorReDialog(context, "Error Please Check Your Internet Connection",
                  (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LandingPage())
                );
                print("reboot");
              });
        }
      }catch(v){
        print("error network :- ${v}");
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignForm())
      );

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin:const EdgeInsets.only(top: 100),
                      width:200,
                      height:200,
                      child: Image.asset("assets/logo.png")
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: CustomLoading()
                ),
              ],
            )
        ),
      ),
    );
  }
}
