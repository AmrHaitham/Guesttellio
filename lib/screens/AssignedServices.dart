import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:guesttellio/networks/GetServices.dart';
import 'package:guesttellio/providers/UserData.dart';
import 'package:guesttellio/widgets/BottomSheetWidget.dart';
import 'package:guesttellio/widgets/Constants.dart';
import 'package:guesttellio/widgets/DefaultButton.dart';
import 'package:guesttellio/widgets/InfoText.dart';
import 'package:guesttellio/widgets/Loading.dart';
import 'package:guesttellio/widgets/ScreenContainer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class AssignedServices extends StatefulWidget {
  @override
  State<AssignedServices> createState() => _AssignedServicesState();
}

class _AssignedServicesState extends State<AssignedServices> {
  GetServices _getServices = GetServices();

  Duration? duration;

  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();

  String? note;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        onRefresh: ()async{
          setState(() {});
        },
        name: "Assigned Services",
        topCenterAction: Container(
          height: 70,
          width: MediaQuery.of(context).size.width*0.86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
                offset:const Offset(3, 4), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${context.read<UserData>().Assigned_services+context.read<UserData>().Old_services}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Constants.titleTextColor
                      ),
                    ),
                    Text("Total services",style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 16
                    ),)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${context.read<UserData>().Assigned_services}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constants.titleTextColor
                      ),
                    ),
                    Text("Assigned",style: TextStyle(
                        color: Constants.textColor,
                        fontSize: 16
                    ),)
                  ],
                ),
              ],
            ),
          ),
        ),
        child: FutureBuilder(
            future: _getServices.getAllServices(context.read<UserData>().token),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.5,
                    child: Center(child: CustomLoading())
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // error in data
                  print(snapshot.error.toString());
                  return  Container();
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) => const Padding(
                            padding:  EdgeInsets.only(left: 15,right: 15),
                            child:  Divider(height: 1 , thickness: 1,),
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            duration = DateTime.now().difference(DateTime.parse(snapshot.data[index]['start_time']));
                            Future.delayed(Duration.zero,(){
                              context.read<UserData>().set_assigned_services(snapshot.data.length);
                              print("new assigned services ${context.read<UserData>().Assigned_services}");
                            });
                            return ListTile(
                              title: Text(
                                "Room ${snapshot.data[index]["room"]}  | ${snapshot.data[index]["category"]}",
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Constants.titleTextColor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  const SizedBox(height: 20,),
                                  Text("${Constants.priority[int.parse(snapshot.data[index]["priority"])-1]}  |  "),
                                  SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: Image.asset("assets/since.png"),
                                  ),
                                  Text("  ${(duration! >= const Duration(minutes: 60))?"${duration!.inHours} hour.":"${duration!.inMinutes} min."}")
                                ],
                              ),
                              trailing: InkWell(
                                child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Image.asset("assets/right-arrow_gray.png")
                                ),
                                onTap: (){
                                  _bottomSheetWidget.showBottomSheetButtons(
                                      context,
                                      200.0,
                                      Text(
                                        "Close service  #${snapshot.data[index]["id"]}  |  Room ${snapshot.data[index]["room"]}",
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Constants.mainColor,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      [
                                        SizedBox(height: 20,),
                                        buildNoteFormField(),
                                        SizedBox(height: 20,),
                                        DefaultButton(
                                          text: "Mark Service As Done",
                                          press: ()async{
                                            try{
                                              EasyLoading.show(status: "Mark Service As Done");
                                              var response = await _getServices.markServiceAsDone(context.read<UserData>().token, snapshot.data[index]["id"].toString(), note.toString());
                                              if(response.statusCode == 200){
                                                print(response.stream.bytesToString());
                                                context.read<UserData>().set_assigned_services(context.read<UserData>().Assigned_services-1);
                                                EasyLoading.showSuccess("Done");
                                                EasyLoading.dismiss();
                                                Navigator.pop(context);
                                                setState(() {});
                                              }else{
                                                print(response.stream.bytesToString());
                                                EasyLoading.dismiss();
                                                Navigator.pop(context);
                                              }
                                            }catch(v){
                                              print(v);
                                              EasyLoading.dismiss();
                                              Navigator.pop(context);
                                            }
                                          },
                                        )
                                      ]
                                  );
                                },
                              ),
                              onTap: (){
                                _bottomSheetWidget.showBottomSheetButtons(
                                    context,
                                    300.0,
                                    const Text(""),
                                    [
                                      InfoText(
                                          lp: 48,
                                          name: "Room",
                                          value: snapshot.data[index]['room']
                                      ),
                                      InfoText(
                                          lp: 25,
                                          name: "Category",
                                          value: snapshot.data[index]['category']
                                      ),
                                      InfoText(
                                          lp: 40,
                                          name: "Service",
                                          value: snapshot.data[index]['service']
                                      ),
                                      InfoText(
                                          lp: 38,
                                          name: "Priority",
                                          value: Constants.priority[int.parse(snapshot.data[index]['priority'])-1]
                                      ),
                                      InfoText(
                                          lp: 18,
                                          name: "Start Time",
                                          value: DateFormat('MMM. dd, yyyy, h:mm a').format(DateTime.parse(snapshot.data[index]['start_time'])).toString()
                                          // value: DateTime.parse(snapshot.data[index]['start_time']).toString(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Status:",
                                              style: TextStyle(
                                                  color: Constants.mainColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 48),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 15,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Constants.statusColors[int.parse(snapshot.data[index]['status'])-1]
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${Constants.status[int.parse(snapshot.data[index]['status'])-1]}",
                                                      overflow: TextOverflow.fade,
                                                      style: TextStyle(
                                                          color: Constants.textColor,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      InfoText(
                                          lp: 50,
                                          name: "Notes",
                                          value: "${(snapshot.data[index]['notes'] == "")?"None":snapshot.data[index]['notes']}"
                                      ),
                                      // DefaultButton(
                                      //   text: "Mark Service As Done",
                                      // )
                                    ]
                                );
                              },
                            );
                          }
                      ),
                    ),
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
        ),
    );
  }
  TextFormField buildNoteFormField() {
    return TextFormField(
      onSaved: (newValue) => note = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          note = value;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Employee Notes",
        labelStyle: TextStyle(
          color: Constants.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
