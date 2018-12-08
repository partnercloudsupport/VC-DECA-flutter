import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_info.dart';

class ConferencesPage extends StatefulWidget {
  @override
  _ConferencesPageState createState() => _ConferencesPageState();
}

class ConferenceListing {
  String key;
  String full;
  String body;
  String imageUrl;

  ConferenceListing(this.key);

  ConferenceListing.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        full = snapshot.value["full"],
        body = snapshot.value["body"],
        imageUrl = snapshot.value["imageUrl"];
}

class _ConferencesPageState extends State<ConferencesPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  List<ConferenceListing> conferenceList = new List();

  _ConferencesPageState() {
    databaseRef.child("conferences").onChildAdded.listen((Event event) {
      setState(() {
        conferenceList.add(new ConferenceListing.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: new ListView.builder(
        itemCount: conferenceList.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {
              selectedYear = conferenceList[index].key;
              router.navigateTo(context, '/conference', transition: TransitionType.native);
            },
            child: new Card(
              child: new Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  new ClipRRect(
                    child: new Image.network(
                      conferenceList[index].imageUrl,
                      height: 120.0,
                      width: 1000.0,
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  new Container(
                    height: 120.0,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          conferenceList[index].key.split(" ")[1],
                          style: TextStyle(fontFamily: "Product Sans", fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        new Text(
                          conferenceList[index].key.split(" ")[0],
                          style: TextStyle(fontFamily: "Product Sans", fontSize: 20.0, color: Colors.white, decoration: TextDecoration.overline),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
