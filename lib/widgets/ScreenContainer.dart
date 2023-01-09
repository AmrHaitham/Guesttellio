import 'package:flutter/material.dart';
import 'package:guesttellio/widgets/Constants.dart';
class ScreenContainer extends StatelessWidget {
  final  topRightaction;
  final  topCenterAction;
  final  topLeftAction;
  final String name;
  final Widget child;
  final onRefresh;
  const ScreenContainer({Key? key, this.topRightaction, this.topCenterAction, this.topLeftAction,required this.name,required this.child, this.onRefresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          onRefresh();
        },
        child: Stack(
          children: [
            Container(
              width:double.infinity,
              height: 170,
              decoration: BoxDecoration(
                color: Constants.mainColor,
                borderRadius:const BorderRadius.only(bottomRight:Radius.circular(40) ,bottomLeft: Radius.circular(40))
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: topLeftAction==null?MainAxisAlignment.end:MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: topLeftAction??Container(),
                        ),
                        Expanded(child: Container()),
                        Align(
                          alignment: Alignment.centerRight,
                          child: topRightaction??Container(),
                        ),
                      ],
                    ),
                  ),
                  Text(name,style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                    // fontFamily: "Segoe UI Bold Italic",
                  ),),
                  const SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.center,
                    child: topCenterAction??Container(),
                  ),
                  child
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
