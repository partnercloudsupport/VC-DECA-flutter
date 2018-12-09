import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'user_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class ConferenceViewPage extends StatefulWidget {
  @override
  _ConferenceViewPageState createState() => _ConferenceViewPageState();
}

class _ConferenceViewPageState extends State<ConferenceViewPage> {
  @override

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String mainUrl = "http://www.californiadeca.org/m/img/scdc-logo-white.png";

  _ConferenceViewPageState() {
    databaseRef.child("conferences").child(selectedYear).once().then((DataSnapshot snapshot) {
      setState(() {
        mainUrl = snapshot.value["imageUrl"];
      });
    });
  }

  List buildTextViews(int count) {
    List<Widget> strings = List();
    for (int i = 1; i <= count; i++) {
      strings.add(new Padding(padding: new EdgeInsets.all(16.0),
          child: new Text("Item number " + i.toString(),
              style: new TextStyle(fontSize: 20.0))));
    }
    return strings;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            largeTitle: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  selectedYear.split(" ")[0],
                  style: TextStyle(fontFamily: "Product Sans", fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                new Text(
                  selectedYear.split(" ")[1],
                  style: TextStyle(fontFamily: "Product Sans", fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          new SliverList(delegate: new SliverChildListDelegate(buildTextViews(20))),
        ],
      ),
    );
  }
}