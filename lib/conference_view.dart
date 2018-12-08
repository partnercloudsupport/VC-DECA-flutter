import 'package:flutter/material.dart';
import 'user_info.dart';

class ConferenceViewPage extends StatefulWidget {
  @override
  _ConferenceViewPageState createState() => _ConferenceViewPageState();
}

class _ConferenceViewPageState extends State<ConferenceViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: eventColor,
        title: new Text(selectedYear),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: new Container(),
    );
  }
}
