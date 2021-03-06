import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_info.dart';
import 'package:fluro/fluro.dart';

class ConferenceSchedulePage extends StatefulWidget {
  @override
  _ConferenceSchedulePageState createState() => _ConferenceSchedulePageState();
}

class EventListing {
  String key;
  String eventTime;
  String eventEndTime;
  String eventLocation;
  String eventDesc;
  String eventTitle;
  String eventDate;

  EventListing.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventTime = snapshot.value["time"].toString(),
        eventEndTime = snapshot.value["endTime"].toString(),
        eventDate = snapshot.value["date"].toString(),
        eventDesc = snapshot.value["desc"].toString(),
        eventTitle = snapshot.value["title"].toString(),
        eventLocation = snapshot.value["location"].toString();
}

class _ConferenceSchedulePageState extends State<ConferenceSchedulePage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  List<EventListing> eventList = new List();

  String backdrop = "Nothing to see here!\nCheck back later for conference schedule listings.";

  bool _visible = false;

  _ConferenceSchedulePageState() {
    databaseRef.child("conferences").child(selectedYear).child("agenda").onChildAdded.listen((Event event) {
      setState(() {
        backdrop = "";
        eventList.add(EventListing.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: new EdgeInsets.all(16.0),
      child: new Stack(
        children: <Widget>[
          new Container(
              height: 75.0,
              child: new Center(
                child: new Text(
                  backdrop,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 13.0,
                    fontFamily: "Product Sans",
                  ),
                ),
              )
          ),
          new ListView.builder(
            itemCount: eventList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  selectedAgenda = eventList[index].key;
                  router.navigateTo(context, '/conferenceScheduleView', transition: TransitionType.native);
                },
                child: new Card(
                  child: new Container(
                    padding: EdgeInsets.all(16.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                            child: new Text(
                              eventList[index].eventTime,
                              style: TextStyle(color: mainColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                            )
                        ),
                        new Padding(padding: EdgeInsets.all(5.0)),
                        new Column(
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width - 185,
                              child: new Text(
                                eventList[index].eventTitle,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Product Sans",
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width - 185,
                              child: new Text(
                                eventList[index].eventLocation,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Product Sans",
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Container(
                            child: new Icon(
                              Icons.arrow_forward_ios,
                              color: mainColor,
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
