import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';

class NewAlertPage extends StatefulWidget {
  @override
  _NewAlertPageState createState() => _NewAlertPageState();
}

class _NewAlertPageState extends State<NewAlertPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String alertTitle = "";
  String alertBody = "";
  String notifBody = "";

  bool sendNotif = false;

  double notifcationContainerHeight = 0.0;

  final bodyController = new TextEditingController();

  publish(String title, String alert) {
    if (title != "" && alert != "") {
      databaseRef.child("alerts").push().update({
        "title": title,
        "body": alert,
        "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', mm])
      });
      if (sendNotif) {
        print("Notify");
        if (notifBody != "") {
          databaseRef.child("notifications").push().update({
            "title": title,
            "body": notifBody,
          });
        }
        else {
          databaseRef.child("notifications").push().update({
            "title": title,
            "body": alert,
          });
        }
      }
      router.pop(context);
    }
    else {
      print("Missing Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: mainColor,
        title: new Text("New Announcement"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: new SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16.0),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    decoration: InputDecoration(
                      labelText: "Title"
                    ),
                    autocorrect: true,
                    onChanged: (input) {
                      setState(() {
                        alertTitle = input;
                      });
                    },
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        labelText: "Details"
                    ),
                    maxLines: null,
                    autocorrect: true,
                    onChanged: (input) {
                      setState(() {
                        alertBody = input;
                      });
                    },
                  ),
                  new SwitchListTile.adaptive(
                    activeColor: mainColor,
                    activeTrackColor: mainColor,
                    value: sendNotif,
                    title: new Text("Send Notification", style: TextStyle(fontFamily: "Product Sans"),),
                    onChanged: (bool) {
                      setState(() {
                        sendNotif = !sendNotif;
                        if (sendNotif) {
                          notifcationContainerHeight = 125;
                        }
                        else {
                          notifcationContainerHeight = 0;
                        }
                      });
                      print("Send Notification: $sendNotif");
                    },
                  ),
                  new AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: notifcationContainerHeight,
                    child: Column(
                      children: <Widget>[
                        new Card(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(alertTitle, style: TextStyle(fontFamily: "Product Sans", fontSize: 20.0),),
                                new Padding(padding: EdgeInsets.all(4.0)),
                                new TextField(
                                  controller: bodyController,
                                  onChanged: (input) {
                                    notifBody = input;
                                  },
                                  decoration: InputDecoration(
                                    hintText: alertBody
                                  ),
                                  style: TextStyle(
                                    fontFamily: "Product Sans",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(4.0),),
                        new Text("This is a preview of the notification", style: TextStyle(fontFamily: "Product Sans", color: Colors.grey),),
                      ],
                    ),
                  )
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              child: new RaisedButton(
                onPressed: () {
                  publish(alertTitle, alertBody);
                },
                color: mainColor,
                child: new Text("Publish Announcement", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
              ),
              padding: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
    );
  }
}
