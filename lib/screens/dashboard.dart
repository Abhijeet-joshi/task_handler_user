import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_report/custom_widgets/app_widgets.dart';
import 'package:task_report/screens/tasks_page.dart';

import 'login_page.dart';

String? userID_Dashboard;

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required String mUserID}) {
    userID_Dashboard = mUserID;
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late FirebaseFirestore db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("users").doc(userID_Dashboard).collection("tasks").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text(userID_Dashboard.toString())),
            InkWell(
                onTap: () {
                  confirmationDialogBox(
                      ctx: context,
                      diaTitle: "Log out from session?",
                      actionBtnTxt: "Log Out",
                      voidCallback: (){
                        setLoginPreferences(loggedIn: false, userID: "");
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LoginPage()));
                      });
                },
                child: const Icon(Icons.logout, color: Colors.white,)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
              stream: db.collection("users").doc(userID_Dashboard).collection("tasks").snapshots(),
              builder: (_, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index){
                        var taskDates = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) =>
                                        TasksPage(mId: userID_Dashboard.toString(), mDate: taskDates.id)));
                              },
                              child: ListTile(
                                leading: CircleAvatar(radius: 16, backgroundColor: Colors.red, foregroundColor: Colors.white, child: Text('${index+1}'),),
                                title: Text(taskDates.id),
                              ),
                            ),
                            const Divider(color: Colors.grey,),
                          ],
                        );
                  });
                }else{
                  return Center(child: Text("Error fetching rooms"),);
                }
          }),
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
