import 'package:flutter/material.dart';
class BottomSheetWidget{
  showBottomSheetButtons(
      context, height, title , List<Widget> children ) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                      height: height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        title,
                        SingleChildScrollView(child: Column(children: children)),
                      ]))));
        });
  }
}