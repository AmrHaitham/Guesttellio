import 'package:flutter/material.dart';
import 'package:guesttellio/widgets/Constants.dart';
class InfoText extends StatelessWidget {
  final String name , value;
  final double lp;

  const InfoText({Key? key,required this.name,required this.value,this.lp=0.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${name}:",
              style: TextStyle(
                color: Constants.mainColor,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: lp),
              child: Text(
                  "${value}",
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
