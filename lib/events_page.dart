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
    if (name == "Business Management") {
        imagePath = 'images/business.png';
    }
    else if (name == "Entrepreneurship") {
      imagePath = 'images/entrepreneurship.png';
    }
    else if (name == "Finance") {
      imagePath = 'images/finance.png';
    }
    return Image.asset(
      imagePath,
      height: 35.0,
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
            child: new ListView.builder(
              itemCount: eventList.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new ListTile(
                        onTap: () {
                          selectedType = eventList[index].key;
                          print(selectedType);
                          router.navigateTo(context, '/eventCluster', transition: TransitionType.native);
                        },
                        leading: getLeadingPic(eventList[index].key),
                        title: new Text(
                            eventList[index].key,
                            style: TextStyle(
                              fontFamily: "Product Sans",
                            ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                      ),
                      new Divider(
                        height: 8.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }
}
