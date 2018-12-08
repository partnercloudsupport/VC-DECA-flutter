import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class EventViewPage extends StatefulWidget {
  @override
  _EventViewPageState createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String categoryShort = "";
  String categoryTitle = "";
  String categoryBody = "";

  _EventViewPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCategory).child(selectedEvent).once().then((DataSnapshot snapshot) {
      setState(() {
        categoryTitle = snapshot.key;
        categoryShort = snapshot.value["short"];
        categoryBody = snapshot.value["body"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: eventColor,
        title: new Text(categoryShort),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                categoryTitle,
                style: TextStyle(
                  fontFamily: "Product Sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.left,
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Card(
                color: eventColor,
                child: new Container(
                  padding: EdgeInsets.all(4.0),
                  child: new Text(
                    selectedType,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Product Sans",
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Text(
                categoryBody,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontFamily: "Product Sans",
                ),
              ),
              new Divider(
                color: eventColor,
                height: 20.0,
              ),
              new Text(
                "Event Resources:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Product Sans",
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
      ),
    );
  }
}
