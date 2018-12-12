import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'conference_media_page.dart';
import 'user_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

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
    databaseRef.child("conferences").child(selectedYear).once().then((DataSnapshot snapshot) {
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
              Tab(text: "OVERVIEW",),
              Tab(text: "SCHEDULE",),
              Tab(text: "MEDIA"),
            ],
          ),
          title: new Text(selectedYear.split(" ")[1]),
          centerTitle: true,
          textTheme: TextTheme(
              title: TextStyle(
                  fontFamily: "Product Sans",
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              )
          ),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Text("Ya idk what goes here..."),
    );
  }
}
