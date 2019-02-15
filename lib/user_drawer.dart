import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'user_info.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  bool _visible = true;

  @override
  void initState() {
    super.initState();
    databaseRef.child("myDeca").once().then((DataSnapshot snapshot) {
      setState(() {
        _visible = snapshot.value;
      });
    });
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
                  title: new Text('Are you sure you want to sign out?', style: TextStyle(fontFamily: "Product Sans"),),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yes, sign me out!', style: TextStyle(fontFamily: "Product Sans")),
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
                    profilePic = "https://firebasestorage.googleapis.com/v0/b/vc-deca.appspot.com/o/default.png?alt=media&token=a38584fb-c774-4f75-99ab-71b120c87df1";
                    FirebaseAuth.instance.signOut();
                    router.navigateTo(context, '/notLogged', clearStack: true);
                  },
                  onLongPress: () {
                    print("long press");
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel', style: TextStyle(fontFamily: "Product Sans")),
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
      backgroundColor: Colors.white,
      bottomNavigationBar: new SafeArea(
        child: Container(
          color: Colors.white,
          height: 200.0,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/full_black_trans.png',
                height: 100.0,
                color: Colors.grey,
              ),
              new ListTile(
                title: new RaisedButton(
                  child: new Text("Sign Out", style: TextStyle(fontFamily: "Product Sans", fontSize: 17.0)),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: signOutBottomSheetMenu,
                ),
              ),
            ],
          )
        ),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
                padding: EdgeInsets.all(16.0),
                color: mainColor,
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
                              child: new CachedNetworkImage(
                                imageUrl: profilePic,
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
            new Expanded(
              child: new Container(
                color: Colors.white,
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
                    new Visibility(
                      visible: _visible,
                      child: new ListTile(
                        title: new Text("myDECA", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                        leading: Icon(Icons.person),
                        onTap: () async {
                          router.pop(context);
                          await new Future.delayed(const Duration(milliseconds: 10));
                          router.navigateTo(context, '/myDECA', transition: TransitionType.native);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
