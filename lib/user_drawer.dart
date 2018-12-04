import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main.dart';
import 'package:fluro/fluro.dart';
import 'user_info.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
  }

  void signOutBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to sign out?'),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yes, sign me out!'),
                  onTap: () {
                    name = "";
                    email = "";
                    userID = "";
                    chapGroupID = "Not in a Group";
                    role = "Member";
                    appStatus = "";
                    selectedAlert = "";
                    selectedYear = "Please select a conference";
                    selectedCategory = "";
                    selectedEvent = "";
                    storageRef.child("default.png").getData(10000000).then((data) {
                      profilePic = data;
                    });
                    FirebaseAuth.instance.signOut();
                    router.navigateTo(context, '/notLogged', clearStack: true);
                  },
                  onLongPress: () {
                    print("long press");
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel'),
                  onTap: () {
                    router.pop(context);
                  },
                  onLongPress: () {

                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
          child: new ListTile(
            title: new RaisedButton(
              child: new Text("Sign Out", style: TextStyle(fontFamily: "Product Sans", fontSize: 17.0)),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: signOutBottomSheetMenu,
            ),
          ),
        ),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.blue,
                height: 200.0,
                width: 1000.0,
                child: new Stack(
                  children: <Widget>[
                    new Image.asset(
                      'images/vcdeca_white_trans.png',
                      width: 1000.0,
                      height: 125.0,
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(50.0)),
                        new Row(
                          children: <Widget>[
                            new ClipOval(
                              child: new Image.memory(
                                profilePic,
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            new Padding(padding: EdgeInsets.all(8.0)),
                            new Text(
                              name,
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                  fontFamily: "Product Sans",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
            ),
            new Container(
              padding: EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(email, style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                    leading: Icon(Icons.email),
                  ),
                  new ListTile(
                    title: new Text(role, style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                    leading: Icon(Icons.verified_user),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
