import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:guesttellio/helper/Dialogs.dart';
import 'package:guesttellio/helper/actions.dart';
import 'package:guesttellio/networks/UserProfile.dart';
import 'package:guesttellio/providers/UserData.dart';
import 'package:guesttellio/widgets/Loading.dart';
import 'package:guesttellio/widgets/ProfilePic.dart';
import 'package:guesttellio/widgets/ScreenContainer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/Constants.dart';
import '../widgets/DefaultButton.dart';
class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserProfile _profile = UserProfile();

  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  final _passwordFormKey = GlobalKey<FormState>();

  String? email;

  String? password;

  String? oldPassword;

  String? conform_password;

  String? firstName;

  String? lastName;

  String? phoneNumber;

  String? job;

  String? department;

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: _profile.getUserProfileData(context.read<UserData>().token),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomLoading());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // error in data
                print(snapshot.error.toString());
                return  Container();
              } else if (snapshot.hasData) {
                print(snapshot.data);
                return ScreenContainer(
                    name: "User Profile",
                    topRightaction: InkWell(
                      onTap: ()async{
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // save data
                          EasyLoading.show(status: "Edit User Profile");
                          var changeProfileResponse = await _profile.updateUserProfile(
                            context.read<UserData>().token,
                            email,
                            firstName,
                            lastName,
                            phoneNumber,
                          );
                          if (await changeProfileResponse.statusCode == 200) {
                            _dialogs.doneDialog(context,"You Are Successfully Updated Information","Ok",(){});
                          }else{
                            var error = jsonDecode(await changeProfileResponse.stream.bytesToString());
                            print(error);
                            _dialogs.errorDialog(context, "Error Please Check Your Internet Connection");
                          }
                          EasyLoading.dismiss();
                          setState(() {});
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 25,
                        height: 25,
                        child: Image.asset("assets/save.png"),
                      ),
                    ),
                    topCenterAction: ProfilePic(
                      profile: snapshot.data['image'],
                      uploadImage: () async{
                        var imagePicker;
                        imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                        String imageLocation = imagePicker.path.toString();
                        EasyLoading.show(status: "UpdatingPatientImage");
                        var picResponse =await _profile.updateUserProfileImage(
                            context.read<UserData>().token,
                            snapshot.data['username'],
                            snapshot.data['first_name'],
                            snapshot.data['last_name'],
                            snapshot.data['phone'],
                            imageLocation
                        );
                        if (await picResponse.statusCode == 200) {
                          _dialogs.doneDialog(context,"You Are Successfully Updated Information","Ok",(){});
                        }else{
                          print(await picResponse.stream.bytesToString());
                          _dialogs.errorDialog(context, "Error Please Check Your Internet Connection");
                        }
                        EasyLoading.dismiss();
                        setState(() {
                        });
                      },
                    ),
                    child: Expanded(
                      child: Padding(
                        padding:EdgeInsets.only(right: 15,left: 15),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                buildEmailFormField(snapshot.data['username']),
                                const SizedBox(height: 20),
                                buildFirstNameFormField(snapshot.data['first_name']),
                                const SizedBox(height: 20),
                                buildLastNameFormField(snapshot.data['last_name']),
                                const SizedBox(height: 20),
                                buildPhoneNumberFormField(snapshot.data['phone']),
                                const SizedBox(height: 20),
                                buildDepartmentFormField(snapshot.data['department']),
                                const SizedBox(height: 20),
                                buildJobFormField(snapshot.data['job']),
                                const SizedBox(height: 10),
                                const Divider(height: 2,color: Colors.grey,thickness: 0.8,),
                                const SizedBox(height: 10),
                                changePassword(context,snapshot.data['username']),
                                const SizedBox(height: 10),
                                Container(
                                  decoration:const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Color(0xfffc7866),
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      AdminActions.logout(context);
                                    },
                                    child: ListTile(
                                      leading: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Transform.scale(
                                              scaleX: -1,
                                              child: Image.asset("assets/logout.png",color: Colors.white,)
                                          )
                                      ),
                                      title:const Text(
                                        "Logout",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                );
              }else{
                //no data
                return Container();
              }
            }else{
              //error in connection
              return Container();
            }
          }
    );
  }

  TextFormField buildEmailFormField(initemail) {
    return TextFormField(
      enabled: false,
      initialValue: initemail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          email = value;
        } else if (Constants.emailValidatorRegExp.hasMatch(value)) {
          email = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kEmailNullError;
        } else if (!Constants.emailValidatorRegExp.hasMatch(value)) {
          return Constants.kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "User Name",
        // hintText: "Enter_your_email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildFirstNameFormField(name) {
    return TextFormField(
      initialValue: name,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          firstName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "This Field Is Required";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "First Name",
        // hintText: "Enter_your_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildLastNameFormField(lastname) {
    return TextFormField(
      initialValue: lastname,
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          lastName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "This Field Is Required";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText:"Last Name",
        // hintText:"Please_Enter_your_lastname",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }


  TextFormField buildPhoneNumberFormField(phone) {
    return TextFormField(
      initialValue: phone,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // labelText: "Phone_Number",
        // hintText:"Enter_your_phone_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        phoneNumber = newValue!;
      } ,
      onChanged: (value) {
        if (value != "") {
          phoneNumber = value;
        }
        return null;
      },
      validator: (value) {
        if (value=="") {
          return "This Field Is Required";
        }
        return null;
      },
    );
  }


  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          password = value;
        } else if (value.length >= 8) {
          password = value;
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if (value.length < 8) {
          return Constants.kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "New Password",
        // hintText: "Enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          conform_password = value;
        } else if (value.isNotEmpty && password == conform_password) {
          conform_password = value;
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if ((password != value)) {
          return Constants.kMatchPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: "Confirm New Password",
        // hintText: "Re_enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildOldPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => oldPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          oldPassword = value;
        } else if (value.length >= 8) {
          oldPassword = value;
        }
        oldPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if (value.length < 8) {
          return Constants.kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Old Password",
        // hintText: "Enter_your_old_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextField changePassword(context,account){
    return TextField(
      decoration: InputDecoration(
        suffixIcon:const SizedBox(
          width: 10,
          height: 10,
          child: Icon(Icons.arrow_forward_ios),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText: "Change Password",
        hintStyle:const TextStyle(
            color: Colors.black
        ),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor:
            Colors.transparent,
            builder:
                (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(
                        context)
                        .viewInsets
                        .bottom),
                child:
                SingleChildScrollView(
                  child: Form(
                    key: _passwordFormKey,
                    child: Container(
                      padding:
                      const EdgeInsets
                          .all(20),
                      height: MediaQuery.of(
                          context)
                          .size
                          .height *
                          0.5,
                      decoration: const BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius
                                  .circular(
                                  15),
                              topRight: Radius
                                  .circular(
                                  15))),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                buildOldPasswordFormField(),
                                const SizedBox(height: 20),
                                buildPasswordFormField(),
                                const SizedBox(height: 20),
                                buildConformPassFormField(),
                              ],
                            ),
                          ),
                          DefaultButton(
                            loading: _isLoading,
                            text: "Change",
                            press: () async{
                              if (_passwordFormKey.currentState!.validate()) {
                                _passwordFormKey.currentState!.save();
                                setState(() {
                                  _isLoading = true;
                                });
                                var changeResponse = await _profile.updateUserPassword(
                                    context.read<UserData>().token,
                                    account,
                                    oldPassword,
                                    password
                                );
                                if (await changeResponse.statusCode == 200) {
                                  print(await changeResponse.stream.bytesToString());
                                  _dialogs.doneDialog(context,"You Are Successfully Updated Information","Ok",(){
                                    Navigator.pop(context);
                                  });
                                }else{
                                  if(jsonDecode(await changeResponse.stream.bytesToString())['error'] == "703"){
                                    _dialogs.errorDialog(context, "Wrong Old Password");
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }else{
                                    print(await changeResponse.stream.bytesToString());
                                    _dialogs.errorDialog(context, "Error Please Check Your Internet Connection");
                                  }
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  TextFormField buildDepartmentFormField(name) {
    return TextFormField(
      readOnly: true,
      initialValue: name,
      onSaved: (newValue) => department = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          department = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "This Field Is Required";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Department",
        // hintText: "Enter_your_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildJobFormField(name) {
    return TextFormField(
      readOnly: true,
      initialValue: name,
      onSaved: (newValue) => job = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          job = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "This Field Is Required";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Job",
        // hintText: "Enter_your_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
