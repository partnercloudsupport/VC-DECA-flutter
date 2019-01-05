import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'conference_media_page.dart';
import 'user_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluro/fluro.dart';
import 'package:progress_indicators/progress_indicators.dart';

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
    databaseRef
        .child("conferences")
        .child(selectedYear)
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        mainUrl = snapshot.value["imageUrl"];
      });
    });
  }

  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "OVERVIEW",
              ),
              Tab(
                text: "SCHEDULE",
              ),
              Tab(text: "MEDIA"),
            ],
          ),
          title: new Text(selectedYear.split(" ")[1]),
          centerTitle: true,
          textTheme: TextTheme(
              title: TextStyle(
                  fontFamily: "Product Sans",
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold)),
        ),
        body: TabBarView(
          children: [
            new ConferenceOverview(),
            Center(child: Text("Coming Soon...")),
            new ConferenceMediaPage()
          ],
        ),
      ),
    );
  }
}

class ConferenceOverview extends StatefulWidget {
  @override
  _ConferenceOverviewState createState() => _ConferenceOverviewState();
}

class _ConferenceOverviewState extends State<ConferenceOverview> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();
  
  String full;
  String desc;
  String location;
  String address;
  double lat;
  double long;
  
  _ConferenceOverviewState() {
    databaseRef.child("conferences").child(selectedYear).once().then((DataSnapshot snapshot) {
      var conferenceDetails = snapshot.value;
      setState(() {
        full = conferenceDetails["full"];
        desc = conferenceDetails["desc"];
        location = conferenceDetails["location"];
        address = conferenceDetails["address"];
        lat = conferenceDetails["lat"];
        long = conferenceDetails["long"];
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              full,
              style: TextStyle(
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
              textAlign: TextAlign.left,
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              desc,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
                fontFamily: "Product Sans",
              ),
            ),
            new Divider(
              color: Colors.blue,
              height: 20.0,
            ),
            new Text(
              "Conference Location:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Product Sans",
                fontSize: 18.0,
              ),
            ),
            new ListTile(
              title: Text(location, style: TextStyle(fontFamily: "Product Sans"),),
              subtitle: Text(address, style: TextStyle(fontFamily: "Product Sans"),),
            ),
            new ListTile(
              title: new Text("Hotel Map", style: TextStyle(fontFamily: "Product Sans"),),
              onTap: () {
                router.navigateTo(context, '/hotelMap', transition: TransitionType.native);
              },
              trailing: new Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
              ),
            ),
            new ListTile(
              title: new Text("Announcements", style: TextStyle(fontFamily: "Product Sans"),),
              onTap: () {
                router.navigateTo(context, '/conferenceAnnouncements', transition: TransitionType.native);
              },
              trailing: new Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
              ),
            )
          ],
        ),
      )
    );
  }
}

class HotelMapView extends StatefulWidget {
  @override
  _HotelMapViewState createState() => _HotelMapViewState();
}

class _HotelMapViewState extends State<HotelMapView> {
  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _HotelMapViewState() {
    databaseRef.child("conferences").child(selectedYear).child("hotelMap").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Hotel Map"),
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
    );
  }
}

class ConferenceAnnouncementsPage extends StatefulWidget {
  @override
  _ConferenceAnnouncementsPageState createState() => _ConferenceAnnouncementsPageState();
}

class _ConferenceAnnouncementsPageState extends State<ConferenceAnnouncementsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _ConferenceAnnouncementsPageState() {
    databaseRef.child("conferences").child(selectedYear).child("alerts").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Announcements"),
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
    );
  }
}

