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

  publish(String title, String alert) {
    if (title != "" && alert != "") {
      databaseRef.child("alerts").push().update({
        "title": title,
        "body": alert,
        "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', mm])
      });
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
                      alertTitle = input;
                    },
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        labelText: "Details"
                    ),
                    maxLines: null,
                    autocorrect: true,
                    onChanged: (input) {
                      alertBody = input;
                    },
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
                child: new Text("Publish", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
              ),
              padding: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
    );
  }
}
