import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom_widgets/app_widgets.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool obscureMode = true;
  IconData suffixIcon = Icons.visibility_off;


  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  late FirebaseFirestore db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("users").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
              stream: db.collection("users").snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasData){

                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/userlogo.png", width: 70, height: 70,),
                      vSpace(mHeight: 15),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: usernameCtrl,
                        decoration: InputDecoration(
                          //label and hints
                          labelText: 'Username',
                          labelStyle: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.normal),
                          hintText: 'Enter Username',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade600, fontWeight: FontWeight.normal),
                          //border
                          enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(width: 1, color: Colors.grey.shade600)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.red)),
                        ),
                      ),
                      vSpace(mHeight: 15),
                      StatefulBuilder(
                          builder: (_, stateBuilder) {
                            return TextField(
                              obscureText: obscureMode,
                              obscuringCharacter: '*',
                              style: const TextStyle(color: Colors.black),
                              controller: passwordCtrl,
                              decoration: InputDecoration(
                                //label and hints
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    color: Colors.red, fontWeight: FontWeight.normal),
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade600, fontWeight: FontWeight.normal),

                                //suffixes
                                suffixIcon: InkWell(
                                    onTap: (){
                                      if(obscureMode==false){
                                        stateBuilder(() => obscureMode = true);
                                        stateBuilder(() => suffixIcon = Icons.visibility_off);
                                      }else if(obscureMode==true){
                                        stateBuilder(() => obscureMode = false);
                                        stateBuilder(() => suffixIcon = Icons.visibility);
                                      }
                                    },
                                    child: Icon(suffixIcon)),

                                //border
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(width: 1, color: Colors.grey.shade600)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    borderSide:
                                    BorderSide(width: 1, color: Colors.red)),
                              ),
                            );
                          }
                      ),
                      vSpace(mHeight: 15),
                      SizedBox(
                        child: OutlinedButton(onPressed: () async{
                          if(usernameCtrl.text.isEmpty || passwordCtrl.text.isEmpty){
                            showToast(message: "All Fields are Mandatory");
                          }else{
                            var username = usernameCtrl.text.toString();
                            var password = passwordCtrl.text.toString();

                            final snap = await db.collection("users").doc(username).get();
                            if(snap.exists){
                              var userKey = snap.id.toString();//this will be passed in constructor
                              var ref = snap.data();
                              var passKey = ref!["password"];

                              if(password==passKey){
                                showToast(message: "Login Successful");
                                //open room page with passing user id in constructor
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => Dashboard(mUserID: userKey)));
                                //set preferences
                                //set login mode, userid in preferences
                                setLoginPreferences(loggedIn: true, userID: userKey);
                              }else{
                                showToast(message: "Incorrect Password");
                              }

                            }else{
                              showToast(message: "User $username does not exist");
                            }
                          }

                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.red,),
                                hSpace(mWidth: 10),
                                Text("Login", style: TextStyle(color: Colors.red,)),
                              ],
                            ),
                          ),),
                      ),
                    ],
                  ),);
                }else{
                  return Center(child: Text("Unknown error occurred in fetching credentials"));
                }
              }
          ),
        ),
      ),
    );
  }

  void setLoginPreferences({required bool loggedIn, required String userID}) async{
    var loginPref = await SharedPreferences.getInstance();
    loginPref.setBool("logged", loggedIn);
    loginPref.setString("doc_id", userID);
  }

}