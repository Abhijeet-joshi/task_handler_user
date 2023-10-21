import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

int generateID(){
  int timeStamp = DateTime.now().millisecondsSinceEpoch;
  return timeStamp;
}

Widget textBox({required String text, required FontWeight weight, required double size}){
  return Text(text, style: TextStyle(
    fontSize: size,
    fontWeight: weight,
  ),);
}

Widget vSpace({required double mHeight}){
  return SizedBox(height: mHeight,);
}

Widget hSpace({required double mWidth}){
  return SizedBox(width: mWidth,);
}

void confirmationDialogBox({required BuildContext ctx,
  required String diaTitle,
  required String actionBtnTxt,
  required VoidCallback voidCallback}){


  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(ctx);
    },
  );
  Widget actionBtn = TextButton(
    onPressed: voidCallback,
    child: Text(actionBtnTxt),
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    title: Text(
      diaTitle,
      style: const TextStyle(color: Colors.black),
    ),
    actions: [
      cancelButton,
      actionBtn,
    ],
  );

  // show the dialog
  showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return alert;
      });


}

