import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class EventViewPage extends StatefulWidget {
  @override
  _EventViewPageState createState() => _EventViewPageState();
}

class EventResources {
  String key;
  String link;

  EventResources(this.key, this.link);
}

class _EventViewPageState extends State<EventViewPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String categoryShort = "";
  String categoryTitle = "";
  String categoryBody = "";

  String one;
  String two;
  String three;

  String resourcesText = "No resources are currently available for this event. Please check again later.";

  List<EventResources> resourcesList = new List();

  _EventViewPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCategory).child(selectedEvent).once().then((DataSnapshot snapshot) {
      setState(() {
        categoryTitle = snapshot.key;
        categoryShort = snapshot.value["short"];
        categoryBody = snapshot.value["body"];
        one = snapshot.value["one"];
        two = snapshot.value["two"];
        three = snapshot.value["three"];
        if (snapshot.value["resources"] != null) {
          resourcesText = "";
        }
      });
    });
    databaseRef.child("events").child(selectedType).child(selectedCategory).child(selectedEvent).child("resources").onChildAdded.listen((Event event) {
      setState(() {
        resourcesList.add(new EventResources(event.snapshot.key, event.snapshot.value));
      });
    });
  }

  String getTitles(int num) {
    String title = "[ERROR]";
    if (num == 1 && selectedType == "Roleplay") {
      title = "Participants";
    }
    else if (num == 2 && selectedType == "Roleplay") {
      title = "Preperation Time";
    }
    else if (num == 3 && selectedType == "Roleplay") {
      title = "Interview Time";
    }
    else if (num == 1 && selectedType == "Written") {
      title = "Participants";
    }
    else if (num == 2 && selectedType == "Written") {
      title = "Pages Allowed";
    }
    else if (num == 3 && selectedType == "Written") {
      title = "Presentation Time";
    }
    else if (num == 1 && selectedType == "Online") {
      title = "Participants";
    }
    else if (num == 2 && selectedType == "Online") {
      title = "";
    }
    else if (num == 3 && selectedType == "Online") {
      title = "";
    }
    return title;
  }

  String getResourceTitle(String resource) {
    if (resource == "event") {
      return "Sample Event";
    }
    else if (resource == "exam") {
      return "Sample Exam";
    }
    else if (resource == "guidelines") {
      return "Event Guidelines";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: new SingleChildScrollView(
        child: new Container(
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
                "Event Details:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Product Sans",
                  fontSize: 18.0,
                ),
              ),
              new ListTile(
                title: new Text(getTitles(1), style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, fontFamily: "Product Sans",),),
                trailing: new Text(one, style: TextStyle(fontSize: 17.0, fontFamily: "Product Sans")),
              ),
              new ListTile(
                title: new Text(getTitles(2), style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, fontFamily: "Product Sans",),),
                trailing: new Text(two, style: TextStyle(fontSize: 17.0, fontFamily: "Product Sans")),
              ),
              new ListTile(
                title: new Text(getTitles(3), style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal, fontFamily: "Product Sans",),),
                trailing: new Text(three, style: TextStyle(fontSize: 17.0, fontFamily: "Product Sans")),
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
              new Expanded(
                child: new Stack(
                  children: <Widget>[
                    new Text(
                      resourcesText,
                      style: TextStyle(
                        fontFamily: "Product Sans",
                        color: eventColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: resourcesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          onTap: () {
                            print(resourcesList[index].key);
                            if (resourcesList[index].key == "event") {
                              router.navigateTo(context, '/sampleEvent', transition: TransitionType.nativeModal);
                            }
                            if (resourcesList[index].key == "exam") {
                              router.navigateTo(context, '/sampleExam', transition: TransitionType.nativeModal);
                            }
                            if (resourcesList[index].key == "guidelines") {
                              router.navigateTo(context, '/sampleGuidelines', transition: TransitionType.nativeModal);
                            }
                          },
                          child: new Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                            child: new ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              child: new Container(
                                width: 160.0,
                                child: new Stack(
                                  alignment: FractionalOffset(0, 1),
                                  children: <Widget>[
                                    new Image.network(
                                      "https://github.com/BK1031/ImageAssets/blob/master/pdf_placeholder.png?raw=true",
                                      fit: BoxFit.cover,
                                      height: 1000.0,
                                      width: 1000.0,
                                    ),
                                    new Container(
                                      height: 35.0,
                                      width: 1000.0,
                                      color: const Color(0x99000000),
                                      child: new Center(
                                        child: new Text(
                                          getResourceTitle(resourcesList[index].key),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Product Sans",
                                              fontSize: 20.0,
                                              color: Colors.white
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

class SampleGuidelinesPage extends StatefulWidget {
  @override
  _SampleGuidelinesPageState createState() => _SampleGuidelinesPageState();
}

class _SampleGuidelinesPageState extends State<SampleGuidelinesPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  String url = "";

  _SampleEventPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCategory).child(selectedEvent).child("resources").child("guidelines").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: eventColor,
        title: new Text("Event Guidelines"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
      supportMultipleWindows: true,
    );
  }
}


class SampleExamPage extends StatefulWidget {
  @override
  _SampleExamPageState createState() => _SampleExamPageState();
}

class _SampleExamPageState extends State<SampleExamPage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  String url = "";

  _SampleEventPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCategory).child(selectedEvent).child("resources").child("exam").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: eventColor,
        title: new Text("Sample Exam"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
      supportMultipleWindows: true,
    );
  }
}


class SampleEventPage extends StatefulWidget {
  @override
  _SampleEventPageState createState() => _SampleEventPageState();
}

class _SampleEventPageState extends State<SampleEventPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  String url = "";

  _SampleEventPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCategory).child(selectedEvent).child("resources").child("event").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: eventColor,
        title: new Text("Sample Event"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
      supportMultipleWindows: true,
    );
  }
}
