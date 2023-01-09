import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guesttellio/helper/Dialogs.dart';
import 'package:guesttellio/helper/keyboard.dart';
import 'package:guesttellio/networks/UserAuth.dart';
import 'package:guesttellio/providers/UserData.dart';
import 'package:guesttellio/screens/LandingPage.dart';
import 'package:guesttellio/widgets/Constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/DefaultButton.dart';
import '../widgets/FormError.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  Auth _auth = Auth();
  Dialogs _dialogs = Dialogs();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  final List<String?> errors = [];
  bool _isLoading = false;
  double height = 0;
  bool _showForm = false;
  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void startTimer() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
         height = 300;
      });
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showForm = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
            duration:const Duration(seconds: 3),
            curve: Curves.fastLinearToSlowEaseIn,
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              color: Constants.mainColor
            ),
          child: Center(
            child: Container(
                // margin:const EdgeInsets.only(top: 100),
                width:330,
                height:68,
                child: Image.asset("assets/logo.png")
            ),
          ),
        ),
        SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding:  EdgeInsets.only(left: 25.0,right: 25.0,bottom: MediaQuery.of(context).viewPadding.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          buildEmailFormField(),
                          const SizedBox(height: 20),
                          buildPasswordFormField(),
                          const SizedBox(height: 10),
                          FormError(errors: errors),
                          const SizedBox(height: 40),
                          DefaultButton(
                            text: "Login",
                            loading: _isLoading,
                            press: () async{
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print("traying to login");
                                KeyboardUtil.hideKeyboard(context);
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var response = await _auth.login(email, password);
                                  String data= await response.body;
                                  print(data);
                                  if (response.statusCode == 200 ) {
                                    await prefs.setBool('logedIn', true);
                                    await prefs.setString('email', email!);
                                    await prefs.setString('token', jsonDecode(data)['token']);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    context.read<UserData>().setUserEmail(email!);
                                    context.read<UserData>().setUserToken(jsonDecode(data)['token']);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => LandingPage())
                                    );
                                  }else {
                                    print(jsonDecode(data)['error']);
                                    if(jsonDecode(data)['error']=="701"){
                                      _dialogs.errorDialog(context, "Wrong email or password");
                                    }else if(response.statusCode >= 500 && response.statusCode <600){
                                      _dialogs.errorDialog(context, "We are in maintenance now please try again later");

                                    }else{
                                      _dialogs.errorDialog(context, "Error while sign up");
                                    }
                                  }
                                  setState(() {
                                    _isLoading = false;
                                    errors.clear();
                                  });
                                } catch (v) {
                                  setState(() {
                                    _isLoading = false;
                                    errors.clear();
                                  });
                                  _dialogs.errorDialog(context, "Error while sign up");
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        Expanded(child: Container()),
        Visibility(
          visible: _showForm,
          child: Text(
              "Copyright © Designed & Developed by GUESTTELLIO 2022",
              style: TextStyle(
                color: Constants.mainColor,
                fontSize: 12
              ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: Constants.kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: Constants.kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: Constants.kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Container(
            padding: const EdgeInsets.all(8),
            width: 30,
            height: 30,
            child: Image.asset('assets/password.png')
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: "Password",
        // hintText: "Enter your password",
        labelStyle: TextStyle(
          color: Constants.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: Constants.kEmailNullError);
        } else if (Constants.emailValidatorRegExp.hasMatch(value)) {
          removeError(error: Constants.kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kEmailNullError);
          return "";
        } else if (!Constants.emailValidatorRegExp.hasMatch(value)) {
          addError(error: Constants.kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Container(
            padding: const EdgeInsets.all(8),
            width: 30,
            height: 30,
            child: Image.asset('assets/email.png')
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: "User Name",
        // hintText: "Enter your User Name",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(
            color: Constants.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }
}
