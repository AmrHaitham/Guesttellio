import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guesttellio/screens/AssignedServices.dart';
import 'package:guesttellio/screens/OldServices.dart';
import 'package:guesttellio/screens/Profile.dart';
import 'package:guesttellio/widgets/Constants.dart';
import 'package:provider/provider.dart';
import '../helper/Dialogs.dart';
class MainScreen extends StatefulWidget {
  final int selectedIndex ;

  const MainScreen({Key? key, this.selectedIndex =0,}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreenIndex  = 0;
  final List _screens = [
    AssignedServices(),
    OldServices(),
    Profile()
  ];
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedScreenIndex =widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: _screens[_selectedScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
            enableFeedback: true,
            showUnselectedLabels: false,
            currentIndex: _selectedScreenIndex,
            onTap: _selectScreen,
            selectedItemColor: Constants.mainColor,
            unselectedItemColor: Constants.textColor,
            items: [
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/services.png",color:(_selectedScreenIndex==0)?Constants.mainColor:Colors.black,)), label: "Services"),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/old_services.png",color:(_selectedScreenIndex==1)?Constants.mainColor:Colors.black,)), label: "Old Services"),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/profile.png",color:(_selectedScreenIndex==2)?Constants.mainColor:Colors.black,)), label: "Profile"),
            ]
        ),
      ),
    );
  }
}
