import 'package:flutter/material.dart';
import 'user_info.dart';
import 'dart:io';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String devicePlatform = "";
  String deviceName = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      devicePlatform = "iOS";
    }
    else if (Platform.isAndroid) {
      devicePlatform = "Android";
    }
    deviceName = Platform.localHostname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("About"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: new SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              new Card(
                color: primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("Device", style: TextStyle(color: Colors.blue, fontFamily: "Product Sans",fontWeight: FontWeight.bold),),
                    ),
                    new ListTile(
                      title: new Text("App Version", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Text("$appVersion$appStatus", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                    ),
                    new Divider(height: 0.0, color: Colors.blue),
                    new ListTile(
                      title: new Text("Device Name", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Text("$deviceName", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                    ),
                    new Divider(height: 0.0, color: Colors.blue),
                    new ListTile(
                      title: new Text("Platform", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Text("$devicePlatform", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                    ),
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("Credits", style: TextStyle(fontFamily: "Product Sans", color: Colors.blue, fontWeight: FontWeight.bold),),
                    ),
                    new ListTile(
                      title: new Text("Bharat Kathi", style: TextStyle(fontFamily: "Product Sans",)),
                      subtitle: new Text("App Development", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                    new Divider(height: 0.0, color: Colors.blue),
                    new ListTile(
                      title: new Text("Myron Chan", style: TextStyle(fontFamily: "Product Sans",)),
                      subtitle: new Text("App Design", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                    new Divider(height: 0.0, color: Colors.blue),
                    new ListTile(
                      title: new Text("Ian Lau", style: TextStyle(fontFamily: "Product Sans",)),
                      subtitle: new Text("Marketing", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                    new Divider(height: 0.0, color: Colors.blue),
                    new ListTile(
                      title: new Text("Kashyap Chaturvedula", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                    new ListTile(
                      title: new Text("Andrew Zhang", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                    new ListTile(
                      title: new Text("Thomas Liang", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                    new ListTile(
                      subtitle: new Text("Beta Testers\n", style: TextStyle(fontFamily: "Product Sans",)),
                    ),
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new Text("© Equinox Initiative 2018", style: TextStyle(fontFamily: "Product Sans", color: Colors.grey),)
            ],
          ),
        ),
      )
    );
  }
}
