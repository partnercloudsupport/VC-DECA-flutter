import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';
import 'package:fluro/fluro.dart';

class MyDecaPage extends StatefulWidget {
  @override
  _MyDecaPageState createState() => _MyDecaPageState();
}

class _MyDecaPageState extends State<MyDecaPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("myDECA"),
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            )
        ),
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
