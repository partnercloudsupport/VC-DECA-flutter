import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class EventEntry {
  String key;

  EventEntry(this.key);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key;
}

class _EventPageState extends State<EventPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<EventEntry> eventList = new List();

  _EventPageState() {
    databaseRef.child("events").onChildAdded.listen(onEventAdded);
  }

  onEventAdded(Event event) {
    setState(() {
      eventList.add(new EventEntry.fromSnapshot(event.snapshot));
    });
  }
  
  Widget getLeadingPic(String name) {
    String imagePath = "";
    if (name == "Online") {
        imagePath = 'images/online.png';
    }
    else if (name == "Roleplay") {
      imagePath = 'images/roleplay.png';
    }
    else if (name == "Written") {
      imagePath = 'images/written.png';
    }
    return Image.asset(
      imagePath,
      height: 200.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "Select an event type below.",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0)
          ),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: List.generate(eventList.length, (int index) {
                return new Container(
                    child: new GestureDetector(
                      onTap: () {
                        selectedType = eventList[index].key;
                        print(selectedType);
                        router.navigateTo(context, '/eventCluster', transition: TransitionType.native);
                      },
                      child: getLeadingPic(eventList[index].key),
                    ),
                );
              }),
            ),
          )
        ],
      )
    );
  }
}
