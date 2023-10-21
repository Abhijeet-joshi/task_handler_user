import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/app_widgets.dart';

String? USER_ID_taskPage;
String? DATE_taskPage;

class TasksPage extends StatefulWidget {
  TasksPage({required String mId, required String mDate}) {
    USER_ID_taskPage = mId;
    DATE_taskPage = mDate;
  }

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  late FirebaseFirestore db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("users").doc(USER_ID_taskPage).collection("tasks").doc(
        DATE_taskPage).collection("all tasks").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tasks of $DATE_taskPage'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
              stream: db
                  .collection("users")
                  .doc(USER_ID_taskPage)
                  .collection("tasks")
                  .doc(DATE_taskPage)
                  .collection("all tasks").snapshots(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        var eachTask = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 21, child: Text('${index + 1}'),backgroundColor: Colors.red, foregroundColor: Colors.white,),
                              title: Text(eachTask["task"]),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(color: Colors.red,),
                                  vSpace(mHeight: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("Deadline - ",
                                        style: TextStyle(color: Colors.black),),
                                      Text(eachTask["deadline"],
                                        style: TextStyle(color: Colors.black),),
                                    ],
                                  ),
                                  vSpace(mHeight: 10),
                                  Text(
                                    "Task uploaded at - ${eachTask["uploaded at"]}",
                                    style: TextStyle(fontSize: 15),),
                                  vSpace(mHeight: 10),
                                  Text(
                                    "Status updated at - ${eachTask["status updated at"]}",
                                    style: TextStyle(fontSize: 15),),
                                  Divider(color: Colors.red,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          var statusUpdate;
                                          var timeStamp = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                                          if(eachTask["status"] == "Pending"){
                                            statusUpdate = "Complete";
                                          }else if(eachTask["status"] == "Complete"){
                                            statusUpdate = "Pending";
                                          }
                                          confirmationDialogBox(
                                              ctx: context,
                                              diaTitle: "Want to update task status ?",
                                              actionBtnTxt: "Update",
                                              voidCallback: (){
                                                db
                                                    .collection("users")
                                                    .doc(USER_ID_taskPage)
                                                    .collection("tasks")
                                                    .doc(DATE_taskPage)
                                                    .collection("all tasks")
                                                    .doc(eachTask.id)
                                                    .update({
                                                  "status" : statusUpdate,
                                                  "status updated at" : timeStamp,

                                                });
                                                Navigator.pop(context);
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(9)),
                                              color: eachTask["status"] ==
                                                  "Pending"
                                                  ? Colors.red
                                                  : Colors.green
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 7),
                                            child: Text(eachTask["status"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey.shade800,),
                          ],
                        );
                      });
                } else {
                  return Center(child: Text('Error fetching tasks'),);
                }
              }),
        ),
      ),
    );
  }
}
