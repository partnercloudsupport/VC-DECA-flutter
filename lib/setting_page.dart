import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluro/fluro.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (role == "Admin") {
      _visible = true;
    }
    else {
      _visible = false;
    }
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
                  title: new Text('Are you sure you want to sign out?', style: TextStyle(fontFamily: "Product Sans")),
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

  void newEventConference() {
    String name = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add Time Listing"),
          content: new Container(
            width: 1000.0,
            child: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          labelText: "Enter Conference Name",
                          hintText: "2018 SCDC"
                      ),
                      onChanged: (String input) {
                        name = input;
                      },
                    ),
                  ],
                )
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("ADD"),
              onPressed: () {
                // Update database here
                if (name != "") {
                  databaseRef.child("conferences").child(name).update({"body": "event description goes here"});
                  Navigator.pop(context);
                }
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void deleteAccountBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to delete your VC DECA Account?', style: TextStyle(fontFamily: "Product Sans")),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yes, delete my account!'),
                  onTap: () {

                  },
                  onLongPress: () {},
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel', style: TextStyle(fontFamily: "Product Sans")),
                  onTap: () {
                    router.pop(context);
                  },
                  onLongPress: () {},
                ),
              ],
            ),
          );
        }
    );
  }

  launchHelpUrl() async {
    const url = 'https://github.com/BK1031/VC-DECA-flutter/wiki/Help';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchBugReportUrl() async {
    const url = 'https://github.com/BK1031/VC-DECA-flutter/issues';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchFeedbackUrl() async {
    const url = 'https://docs.google.com/forms/d/e/1FAIpQLScI-s76eVApPqCMVs5rtJ3KObxaB9qURfN0CzS4kl0lU3GdqA/viewform?usp=sf_link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Card(
            color: primaryColor,
            child: Column(
              children: <Widget>[
                new Container(
                  width: 1000.0,
                  padding: EdgeInsets.all(16.0),
                  child: new Text(
                    name,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: mainColor,
                        fontFamily: "Product Sans",
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                new Container(
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("Email", style: TextStyle(fontFamily: "Product Sans"),),
                        trailing: new Text(email, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                      ),
                      new ListTile(
                        title: new Text("Role", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text(role, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                      ),
                      new ListTile(
                        title: new Text("Chaperone Group", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text(chapGroupID, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                      ),
                      new ListTile(
                        title: new Text("User ID", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text(userID, style: TextStyle(fontSize: 14.0, fontFamily: "Product Sans")),
                      ),
                      new ListTile(
                        title: new Text("Update Profile", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
                        onTap: () {
                          router.navigateTo(context, '/profilePic', transition: TransitionType.nativeModal);
                        },
                      )
                    ],
                  ),
                )
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
                  child: new Text("General", style: TextStyle(color: mainColor, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                ),
                new ListTile(
                  title: new Text("About", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                  onTap: () {
                    router.navigateTo(context, '/aboutPage', transition: TransitionType.native);
                  },
                ),
                new Divider(height: 0.0, color: mainColor),
                new ListTile(
                  title: new Text("Help", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                  onTap: () {
                    launchHelpUrl();
                  },
                ),
                new Divider(height: 0.0, color: mainColor),
                new ListTile(
                  title: new Text("Legal", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationVersion: appFull + appStatus,
                      applicationName: "VC DECA App",
                      applicationLegalese: appLegal,
                      applicationIcon: new Image.asset(
                        'images/logo_blue_trans',
                        height: 35.0,
                      )
                    );
                  }
                ),
                new Divider(height: 0.0, color: mainColor),
                new ListTile(
                  title: new Text("Sign Out", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                  onTap: signOutBottomSheetMenu,
                ),
                new Divider(height: 0.0, color: mainColor),
                new ListTile(
                  title: new Text("\nDelete Account\n", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                  subtitle: new Text("Deleting your VC DECA Account will remove all the data linked to your account as well. You will be required to create a new account in order to sign in again.\n", style: TextStyle(fontSize: 12.0, fontFamily: "Product Sans")),
                  onTap: deleteAccountBottomSheet,
                )
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
                  child: new Text("Preferences", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                ),
                new SwitchListTile(
                  title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                  value: notifications,
                  onChanged: (bool value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),
                new Divider(height: 0.0, color: mainColor),
                new SwitchListTile(
                  title: new Text("Chat Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                  value: chatNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      chatNotifications = value;
                    });
                  },
                ),
//                new Divider(height: 0.0, color: mainColor),
//                new SwitchListTile(
//                  title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans",)),
//                  value: darkMode,
//                  onChanged: (bool value) {
//                    setState(() {
//                      darkMode = value;
//                      databaseRef.child("users").child(userID).update({"darkMode": darkMode});
//                    });
//                  },
//                ),
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
                  child: new Text("Feedback", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                ),
                new ListTile(
                  title: new Text("Provide Feedback", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                  onTap: () {
                    launchFeedbackUrl();
                  },
                ),
                new Divider(height: 0.0, color: mainColor),
                new ListTile(
                  title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                  onTap: () {
                    launchBugReportUrl();
                  },
                ),
                new Divider(height: 0.0, color: mainColor),
              ],
            ),
          ),
          new Visibility(
            visible: _visible,
            child: new Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(8.0)),
                new Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Developer", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                      ),
                      new ListTile(
                        leading: new Icon(Icons.developer_mode),
                        title: new Text("Test Firebase Upload", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          FirebaseDatabase.instance.reference().child("testing").push().set("$name - $role");
                        },
                      ),
                      new ListTile(
                        leading: new Icon(Icons.event_note),
                        title: new Text("Add New Conference", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          newEventConference();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
