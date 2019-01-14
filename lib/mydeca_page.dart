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
      body: Container(),
    );
  }
}
