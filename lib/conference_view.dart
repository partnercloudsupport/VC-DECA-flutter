import 'package:flutter/material.dart';
import 'user_info.dart';

class ConferenceViewPage extends StatefulWidget {
  @override
  _ConferenceViewPageState createState() => _ConferenceViewPageState();
}

class _ConferenceViewPageState extends State<ConferenceViewPage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: new Text(selectedYear.split(" ")[1]),
          centerTitle: true,
          textTheme: TextTheme(
              title: TextStyle(
                  fontFamily: "Product Sans",
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              )
          ),
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(text: "Hello",),
              new Tab(text: "Ok",)
            ],
          ),
        ),

        body: new TabBarView(
          children: <Widget>[
            Center( child: Text("Page 1")),
            Center( child: Text("Page 2")),
          ],
        ),
      ),
    );
  }
}
