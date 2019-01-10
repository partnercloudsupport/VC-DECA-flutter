import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';


class ConferenceWinnerPage extends StatefulWidget {
  @override
  _ConferenceWinnerPageState createState() => _ConferenceWinnerPageState();
}

class Winner {
  String key;
  String name;
  String award;
  String event;

  Winner.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.key,
      name = snapshot.value["name"].toString(),
      award = snapshot.value["award"].toString(),
      event = snapshot.value["event"].toString();

}

class _ConferenceWinnerPageState extends State<ConferenceWinnerPage> {

  String backdrop = "The $selectedYear winners list is currently not available. Please check again later.";

  final databaseRef = FirebaseDatabase.instance.reference();

  List<Winner> winnerList = List();

  _ConferenceWinnerPageState() {
    databaseRef.child("conferences").child(selectedYear).child("winners").onChildAdded.listen((Event event) {
      setState(() {
        backdrop = "";
        winnerList.add(Winner.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: new EdgeInsets.all(16.0),
      child: new Stack(
        children: <Widget>[
          new Container(
              height: 75.0,
              child: new Center(
                child: new Text(
                  backdrop,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 13.0,
                    fontFamily: "Product Sans",
                  ),
                ),
              )
          ),
          new ListView.builder(
            itemCount: winnerList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: new Card(
                  child: new Container(
                    padding: EdgeInsets.all(16.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                            child: new Text(
                              winnerList[index].award,
                              style: TextStyle(color: mainColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                            )
                        ),
                        new Padding(padding: EdgeInsets.all(5.0)),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                child: new Text(
                                  winnerList[index].name,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Product Sans",
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              new Container(
                                child: new Text(
                                  winnerList[index].event,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: "Product Sans",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
