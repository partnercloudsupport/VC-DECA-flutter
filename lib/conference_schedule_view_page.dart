import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';

class ConferenceScheduleViewPage extends StatefulWidget {
  @override
  _ConferenceScheduleViewPageState createState() => _ConferenceScheduleViewPageState();
}

class _ConferenceScheduleViewPageState extends State<ConferenceScheduleViewPage> {

  String desc = "";
  String time = "";
  String endTime = "";
  String location = "";
  String date = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  _ConferenceScheduleViewPageState() {
    databaseRef.child("conferences").child(selectedYear).child("agenda").child(selectedAgenda).once().then((DataSnapshot snapshot) {
      setState(() {
        desc = snapshot.value["desc"];
        time = snapshot.value["time"];
        endTime = snapshot.value["endTime"];
        location = snapshot.value["location"];
        date = snapshot.value["date"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text(desc),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      body: new Container(
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              desc,
              style: new TextStyle(fontFamily: "Product Sans"),
            ),
            new Text(
              date,
              style: new TextStyle(fontFamily: "Product Sans"),
            ),
            new Text(
              time,
              style: new TextStyle(fontFamily: "Product Sans"),
            ),
            new Text(
              endTime,
              style: new TextStyle(fontFamily: "Product Sans"),
            ),
            new Text(
              location,
              style: new TextStyle(fontFamily: "Product Sans"),
            ),
          ],
        ),
      ),
    );
  }
}
