import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';
import 'package:fluro/fluro.dart';

class MyDecaPage extends StatefulWidget {
  @override
  _MyDecaPageState createState() => _MyDecaPageState();
}

class MyEventListing {
  String eventName;
  String eventCategory;
  String listingKey;
  String eventDate;
  String location;
  String eventTime;

  MyEventListing(this.eventName, this.eventTime, this.eventDate, this.location, this.eventCategory, this.listingKey);

  MyEventListing.fromSnapshot(DataSnapshot snapshot)
      : listingKey = snapshot.key,
        eventCategory = snapshot.value["category"].toString(),
        location = snapshot.value["location"].toString(),
        eventTime = snapshot.value["time"].toString(),
        eventDate = snapshot.value["date"].toString(),
        eventName = snapshot.value["event"].toString();

}

class _MyDecaPageState extends State<MyDecaPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  List<MyEventListing> myEventsList = new List();

  _MyDecaPageState() {
    if (selectedYear == "Please select a conference") {
      selectedYear = "2019 SVDC";
    }
    getMyEvents();
  }

  onEventAdded(Event event) {
    setState(() {
      myEventsList.add(new MyEventListing.fromSnapshot(event.snapshot));
    });
  }

  void getMyEvents() {
    print("");
    print("Searching for your events...");
    print("");
    databaseRef.child("events").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> allCategories = snapshot.value;
      allCategories.forEach((eventCategory, value) {
        databaseRef.child("events").child(eventCategory).once().then((DataSnapshot snapshot2) {
          Map<dynamic, dynamic> allEvents = snapshot2.value;
          allEvents.forEach((eventName, value2) {
            if (value2[selectedYear]["events"] != null) {
              String location = value2[selectedYear]["location"];
              Map<dynamic, dynamic> timeListings = value2[selectedYear]["events"];
              timeListings.forEach((listingID, listingData) {
                databaseRef.child("events").child(eventCategory).child(eventName).child(selectedYear).child("events").remove();
                String listingName = listingData["name"];
                String listingTime = listingData["time"];
                String eventDate = listingData["date"];
                if (listingName == name) {
                  print("FOUND UR EVENT");
                  print(listingName);
                  print(listingID);
                  print(eventName);
                  print(eventCategory);
                  print("");
                  databaseRef.child("users").child(userID).child("myDECA").child(selectedYear).child(listingID).update({
                    "category": eventCategory,
                    "event": eventName,
                    "date": eventDate,
                    "location": location,
                    "time": listingTime
                  });
                }
              });
            }
          });
        });
      });
    });
    databaseRef.child("events").child("myDECA").onChildAdded.listen((Event event) {
      setState(() {
        var commonEvent = event.snapshot.value[selectedYear];
        String eventName = event.snapshot.key;
        String eventTime = commonEvent["time"];
        String eventLocation = commonEvent["location"];
        String eventDate = commonEvent["date"];
        myEventsList.add(new MyEventListing(eventName, eventTime, eventDate, eventLocation, "myDECA", "none"));
      });
    });
    databaseRef.child("users").child(userID).child("myDECA").child(selectedYear).onChildAdded.listen(onEventAdded);
    myEventsList.sort((MyEventListing a, MyEventListing b) {
      (a.eventDate).compareTo(b.eventDate);
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
          myEventsList.clear();
          selectedYear = title;
          getMyEvents();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("myDECA"),
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 20.0,
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
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            new Text(
                "$selectedYear DECA schedule:",
                style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0)
            ),
            new Expanded(
              child: new ListView.builder(
                itemCount: myEventsList.length,
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
                                  myEventsList[index].eventTime,
                                  style: TextStyle(color: eventColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                                )
                            ),
                            new Padding(padding: EdgeInsets.all(5.0)),
                            new Column(
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width - 185,
                                  child: new Text(
                                    myEventsList[index].eventName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: "Product Sans",
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
//                                new Padding(padding: EdgeInsets.all(5.0)),
//                                new Container(
//                                  width: MediaQuery.of(context).size.width - 150,
//                                  child: new Text(
//                                    myEventsList[index].location,
//                                    textAlign: TextAlign.start,
//                                    style: TextStyle(
//                                      fontSize: 15.0,
//                                    ),
//                                  ),
//                                ),
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
