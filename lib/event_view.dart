import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class EventListing {
  String key;
  String eventTime;
  String eventSchool;
  String eventPerson;

  EventListing(this.eventTime, this.eventPerson, this.eventSchool);

  EventListing.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventTime = snapshot.value["time"].toString(),
        eventPerson = snapshot.value["name"].toString(),
        eventSchool = snapshot.value["school"].toString();
}

class _EventPageState extends State<EventPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  List<EventListing> eventList = new List();

  String categoryShort = "";
  String categoryTitle = "";
  String categoryBody = "";
  String eventLocation = "";

  DateTime selectedDate;

  String backdrop = "Nothing to see here!\nCheck back later for event time listings.";

  bool _visible = false;

  void getEventData() {
    databaseRef.child("events").child(selectedCategory).child(selectedEvent).once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      categoryTitle = snapshot.key;
      var categoryInfo = snapshot.value;
      setState(() {
        categoryShort = categoryInfo["short"];
        categoryBody = categoryInfo["body"];
      });
      databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        if (selectedYear == "Please select a conference") {
          setState(() {
            eventLocation = "";
            backdrop = "Nothing to see here!\nCheck back later for event time listings.";
          });
        }
        else if (snapshot.value["events"] != null) {
          setState(() {
            eventLocation = snapshot.value["location"];
            backdrop = "";
          });
        }
        else {
          setState(() {
            eventLocation = snapshot.value["location"];
            backdrop = "Nothing to see here!\nCheck back later for event time listings.";
          });
        }
      });
    });
    databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).child("events").onChildAdded.listen(onEventAdded);
  }

  _EventPageState() {
    if (role == "Admin") {
      _visible = true;
    }
    getEventData();
  }

  onEventAdded(Event event) {
    setState(() {
      eventList.add(new EventListing.fromSnapshot(event.snapshot));
    });
  }

  Icon addCheckmark(String title) {
    if (title == selectedYear) {
      return Icon(Icons.check, color: eventColor);
    }
    else {
      return null;
    }
  }

  Widget returnEvents() {
    List<Widget> returnList = new List();
    for (var item in yearsList) {
      returnList.add(addEventSelection(item));
      returnList.add(new Divider(color: eventColor, height: 0.0));
    }
    return Column(
      children: returnList,
    );
  }

  Widget addEventSelection(String title) {
    return new ListTile(
      trailing: addCheckmark(title),
      title: new Text(title),
      onTap: () {
        setState(() {
          eventList.clear();
          selectedYear = title;
          getEventData();
        });
        Navigator.pop(context);
      },
    );
  }

  void selectYearDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Select a Conference"),
          content: new Container(
            height: 150.0,
            child: new SingleChildScrollView(
              child: returnEvents()
            ),
          ),
        );
      },
    );
  }

  void newTimeDialog() {
    String name = "";
    String time = "";
    String date = "";
    String school = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add Time Listing"),
          content: new Container(
            width: 1000.0,
            child: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      decoration: InputDecoration(
                        labelText: "Enter Student Names"
                      ),
                      onChanged: (String input) {
                        name = input;
                      },
                    ),
                    new TextField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Enter Listing Date",
                      ),
                      onChanged: (String input) {
                        date = input;
                      },
                    ),
                    new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Enter Listing Time",
                      ),
                      onChanged: (String input) {
                        time = input;
                      },
                    ),
                    new TextField(
                      decoration: InputDecoration(
                        labelText: "Enter Listing School",
                        hintText: "Leave Blank for VCHS"
                      ),
                      onChanged: (String input) {
                        school = input;
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
                if (school == "") {
                  school = "Valley Christian High School";
                }
                if (selectedYear != "Please select a conference" && name != "" && date != "") {
                  databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).child("events").push().update({
                    "name": name,
                    "school": school,
                    "time": time,
                    "date": date
                  });
                  Navigator.pop(context);
                }
              },
            ),
            new FlatButton(
              textColor: eventColor,
              child: new Text("CANCEL"),
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
        actions: <Widget>[
          new IconButton(
            icon: new Image.asset('images/filter.png', color: Colors.white, height: 25.0,),
            color: Colors.white,
            onPressed: () {
              selectYearDialog();
            },
          ),
          new Visibility(
             child: new IconButton(
               icon: Icon(Icons.add),
               onPressed: () {
                 newTimeDialog();
               },
             ),
            visible: _visible,
          )
        ],
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
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text(
                ("$eventLocation - $selectedYear"),
                style: TextStyle(
                  color: eventColor,
                  fontFamily: "Product Sans",
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  fontSize: 18.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
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
                "Event Schedule:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Product Sans",
                  fontSize: 18.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(0.0)),
              new Expanded(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      child: new Center(
                        child: new Text(
                          backdrop,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eventColor,
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
                                        style: TextStyle(fontFamily: "Product Sans", color: eventColor, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                  new Padding(padding: EdgeInsets.all(5.0)),
                                  new Column(
                                    children: <Widget>[
                                      new Container(
//                                        width: MediaQuery.of(context).size.width - 185,
                                        child: new Text(
                                          eventList[index].eventPerson,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Product Sans",
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
//                                  new Padding(padding: EdgeInsets.all(5.0)),
//                                  new Container(
//                                      child: new Icon(
//                                        Icons.arrow_forward_ios,
//                                        color: eventColor,
//                                      )
//                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              )
            ],
          ),
      ),
    );
  }
}
