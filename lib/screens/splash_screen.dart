import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_report/custom_widgets/app_widgets.dart';
import 'package:task_report/screens/dashboard.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool loggedIn = false;
  String? userID;

  void getLoginPrefs() async{
    var loginPref = await SharedPreferences.getInstance();
    loggedIn = loginPref.getBool("logged")!;
    userID = loginPref.getString("doc_id");
  }

  Widget? navigateTo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginPrefs();
    Timer(const Duration(seconds: 6), (){
      if(loggedIn==true){
        navigateTo = Dashboard(mUserID: userID.toString());
      }else{
        navigateTo = const LoginPage();
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => navigateTo!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*const CircleAvatar(
              radius: 31,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.account_circle_outlined,
                size: 37,
                color: Colors.white,
              ),
            ),*/
            Image.asset("assets/images/userlogo.png", width: 70, height: 70,),
            vSpace(mHeight: 15),
            const CircularProgressIndicator(),

          ],
        ),
      ),
    );
  }
}
