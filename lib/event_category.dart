import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';

class EventCategoryPage extends StatefulWidget {
  @override
  _EventCategoryPageState createState() => _EventCategoryPageState();
}

class EventEntry {
  String key;
  String eventBody;
  String eventShort;

  EventEntry(this.eventBody, this.eventShort);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventBody = snapshot.value["body"].toString(),
        eventShort = snapshot.value["short"].toString();
}

class _EventCategoryPageState extends State<EventCategoryPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<EventEntry> eventList = new List();

  bool _visible = false;

  _EventCategoryPageState() {
    if (role == "Admin") {
      _visible = true;
    }
    databaseRef.child("events").child(selectedType).child(selectedCategory).onChildAdded.listen(onEventAdded);
  }

  onEventAdded(Event event) {
    setState(() {
      eventList.add(new EventEntry.fromSnapshot(event.snapshot));
    });
  }

  void newEventDialog() {
    String name = "";
    String short = "";
    String body = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add New Event"),
          content: new Container(
            width: 1000.0,
            child: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: "Enter Event Name"
                      ),
                      onChanged: (String input) {
                        name = input;
                      },
                    ),
                    new TextField(
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: "Enter Event Short-Form",
                      ),
                      onChanged: (String input) {
                        short = input;
                      },
                    ),
                    new TextField(

                      decoration: InputDecoration(
                        labelText: "Enter Event Description",
                      ),
                      onChanged: (String input) {
                        body = input;
                      },
                    ),
                  ],
                )
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("ADD"),
              textColor: eventColor,
              onPressed: () {
                // Update database here
                if (name != "" && short != "" && body != "") {
                  databaseRef.child("events").child(selectedType).child(selectedCategory).child(name).update({
                    "body": body,
                    "short": short
                  });
                  for (int i = 0; i < yearsList.length; i++) {
                    databaseRef.child("events").child(selectedType).child(selectedCategory).child(name).child(yearsList[i]).update({
                      "location": "Location TBD"
                    });
                  }
                  Navigator.pop(context);
                }
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              textColor: eventColor,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: eventColor,
        title: new Text(selectedCategory),
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            )
        ),
        actions: <Widget>[
          new Visibility(
            child: new IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                newEventDialog();
              },
            ),
            visible: _visible,
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Text("Select a event below.", style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0)),
            new Expanded(
              child: new ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      selectedEvent = eventList[index].key;
                      print(selectedEvent);
                      router.navigateTo(context, '/event', transition: TransitionType.native);
                    },
                    child: new Card(
                      child: new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                child: new Text(
                                  eventList[index].eventShort,
                                  style: TextStyle(color: eventColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                                )
                            ),
                            new Padding(padding: EdgeInsets.all(5.0)),
                            new Column(
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width - 178,
                                  child: new Text(
                                    eventList[index].key,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: "Product Sans",
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            new Padding(padding: EdgeInsets.all(5.0)),
                            new Container(
                                child: new Icon(
                                  Icons.arrow_forward_ios,
                                  color: eventColor,
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}
