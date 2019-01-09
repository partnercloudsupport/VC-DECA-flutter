import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';

class ConferenceScheduleViewPage extends StatefulWidget {
  @override
  _ConferenceScheduleViewPageState createState() => _ConferenceScheduleViewPageState();
}

class _ConferenceScheduleViewPageState extends State<ConferenceScheduleViewPage> {

  String title = "";
  String desc = "No Description";
  String time = "";
  String endTime = "";
  String location = "";
  String date = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  _ConferenceScheduleViewPageState() {
    databaseRef.child("conferences").child(selectedYear).child("agenda").child(selectedAgenda).once().then((DataSnapshot snapshot) {
      setState(() {
        title = snapshot.value["title"];
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
        title: new Text(""),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              title,
              style: TextStyle(
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25.0,
              ),
              textAlign: TextAlign.left,
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              "$time - $endTime",
              style: TextStyle(
                fontFamily: "Product Sans",
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                color: mainColor,
                fontSize: 20.0,
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              location,
              style: TextStyle(
                fontFamily: "Product Sans",
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                color: mainColor,
                fontSize: 18.0,
              ),
            ),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Text(
              desc,
              style: TextStyle(
                fontFamily: "Product Sans",
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
