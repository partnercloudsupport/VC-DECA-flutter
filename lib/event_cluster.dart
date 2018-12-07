import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';

class ClusterPage extends StatefulWidget {
  @override
  _ClusterPageState createState() => _ClusterPageState();
}

class EventEntry {
  String key;
  String eventBody;

  EventEntry(this.eventBody);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventBody = snapshot.value["body"].toString();
}

class _ClusterPageState extends State<ClusterPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<EventEntry> eventList = new List();

  _ClusterPageState() {
    databaseRef.child("events").child(selectedType).onChildAdded.listen(onEventAdded);
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
    else if (name == "Hospitality + Tourism") {
      imagePath = 'images/hospitality.png';
    }
    else if (name == "Marketing") {
      imagePath = 'images/marketing.png';
    }
    else if (name == "Personal Financial Literacy") {
      imagePath = 'images/personal-finance.png';
    }
    else if(name == "myDECA") {
      return Icon(Icons.supervised_user_circle, color: Colors.blue, size: 35.0,);
    }
    return Image.asset(
      imagePath,
      height: 35.0,
    );
  }

  void getCategoryColor(String name) {
    if (name == "Business Management") {
      eventColor = Color(0xFFfcc414);
      print("YELLOW");
    }
    else if (name == "Entrepreneurship") {
      eventColor = Color(0xFF818285);
      print("GREY");
    }
    else if (name == "Finance") {
      eventColor = Color(0xFF049e4d);
      print("GREEN");
    }
    else if (name == "Hospitality + Tourism") {
      eventColor = Color(0xFF046faf);
      print("INDIGO");
    }
    else if (name == "Marketing") {
      eventColor = Color(0xFFe4241c);
      print("RED");
    }
    else if (name == "Personal Financial Literacy") {
      eventColor = Color(0xFF7cc242);
      print("LT GREEN");
    }
    else {
      eventColor = Colors.blue;
      print("COLOR NOT FOUND");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text(selectedType),
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Text(
                  "Select a category below.",
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
                              selectedCategory = eventList[index].key;
                              print(selectedCategory);
                              getCategoryColor(eventList[index].key);
                              if (selectedCategory != "myDECA") {
                                router.navigateTo(context, '/eventCategory', transition: TransitionType.native);
                              }
                              else {
                                router.navigateTo(context, '/myDECA', transition: TransitionType.native);
                              }
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
      ),
    );
  }
}
