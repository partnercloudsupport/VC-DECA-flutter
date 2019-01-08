import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'setting_page.dart';
import 'events_page.dart';
import 'chat_page.dart';
import 'conferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'user_drawer.dart';
import 'user_info.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class EventYearListing {
  String key;

  EventYearListing(this.key);

  EventYearListing.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key;
}

class _TabBarControllerState extends State<TabBarController> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseRef = FirebaseDatabase.instance.reference();

  String title = "VC DECA";

  PageController pageController;
  int currentTab = 0;

  var currentTabButton;
  var currentButton;

  var newAlertTitle = "";
  var newAlertBody = "";

  var newGroupCode = "";
  var newChaperoneName = "";

  void alertTitleText(String input) {
    setState(() {
      newAlertTitle = input;
    });
  }

  void alertBodyText(String input) {
    setState(() {
      newAlertBody = input;
    });
  }

  void addAlertDialog() {
    newAlertBody = "";
    newAlertTitle = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Create New Announcement"),
          content: new Container(
            height: 200.0,
            width: 1000.0,
            child: new Column(
              children: <Widget>[
                new TextField(
                  onChanged: alertTitleText,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      labelText: "Announcement Title",
                      hintText: "Enter announcement title"
                  ),
                ),
                new TextField(
                  onChanged: alertBodyText,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelText: "Announcement Body",
                      hintText: "Enter announcement body"
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CREATE"),
              onPressed: () {
                if (newAlertTitle != "" && newAlertBody != "") {
                  databaseRef.child("alerts").push().update({
                    "title": newAlertTitle,
                    "body": newAlertBody,
                    "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn])
                  });
                  newAlertBody = "";
                  newAlertTitle = "";
                  Navigator.of(context).pop();
                }
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                newAlertBody = "";
                newAlertTitle = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void serverUpdateDialog() {
    newAlertBody = "";
    newAlertTitle = "";
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Server Update", style: TextStyle(fontFamily: "Product Sans"),),
          content: new Container(
            height: 250.0,
            child: new Column(
              children: <Widget>[
                new Text(
                  "The server is currently updating. We appreciate your patience during this time. This alert will automatically disappear when the server is finished updating.",
                  style: TextStyle(fontFamily: "Product Sans"),
                ),
                new Padding(padding: EdgeInsets.all(25.0)),
                new HeartbeatProgressIndicator(
                  child: new Image.asset(
                    'images/logo_blue_trans.png',
                    height: 75.0,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void createGroupDialog() {
    newGroupCode = "";
    newChaperoneName = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Create Chaperone Group"),
          content: new Container(
            height: 150.0,
            child: new Column(
              children: <Widget>[
                new TextField(
                  onChanged: (String input) {
                    newChaperoneName = input;
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      labelText: "Chaperone Name",
                      hintText: "Enter chaperone's name"
                  ),
                ),
                new Padding(padding: EdgeInsets.all(5.0)),
                new TextField(
                  onChanged: (String input) {
                    newGroupCode = input;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      labelText: "Group Code",
                      hintText: "Enter chaperone group code"
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CREATE"),
              onPressed: () {
                if (newGroupCode != "" && newChaperoneName != "") {
                  databaseRef.child("chat").child(newGroupCode).push().update({
                    "author": "GroupCreatorBot",
                    "message": "Welcome to $newChaperoneName's chaperone group!",
                    "date": "N/A",
                    "role": "Bot"
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void tabTapped(int index) {
    setState(() {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  void pageChanged(int index) {
    print("Current Tab: $index");
    setState(() {
      currentTabButton = null;
      currentTab = index;
      if (currentTab == 1) {
        title = "Conferences";
      }
      else if (currentTab == 2) {
        title = "Events";
      }
      else if (currentTab == 3) {
        title = "Chat";
        if (role == "Admin") {
          currentTabButton = new FloatingActionButton(
            backgroundColor: mainColor,
            child: Icon(Icons.group_add),
            onPressed: createGroupDialog,
          );
        }
      }
      else if (currentTab == 4) {
        title = "Settings";
      }
      else {
        title = "VC DECA";
        if (role == "Admin" || role == "Officer") {
          currentTabButton = new FloatingActionButton(
            backgroundColor: mainColor,
            child: Icon(Icons.add),
            onPressed: addAlertDialog,
          );
        }
      }
      currentButton = currentTabButton;
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print("FCM Token: " + token);
      databaseRef.child("users").child(userID).update({"fcmToken": token});
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }
  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    pageController = new PageController();
    databaseRef.child("stableVersion").once().then((DataSnapshot snapshot) {
      var stable = snapshot.value;
      print("Current Version: $appVersion");
      print("Stable Version: $stable");
      if (appVersion < stable) {
        print("OUTDATED APP!");
        appStatus = " [OUTDATED]";
      }
      else if (appVersion > stable) {
        print("BETA APP!");
        appStatus = " Beta $appBuild";
      }
      _firebaseMessaging.subscribeToTopic("allDevices");
      print("All Devices Subscribed");
      if (role == "Officer" || role == "Admin") {
        _firebaseMessaging.subscribeToTopic("officers");
        print("Officer Subscribed");
      }
      else {
        _firebaseMessaging.unsubscribeFromTopic("officers");
      }
    });
    databaseRef.child("conferences").onChildAdded.listen((Event event) {
      setState(() {
        yearsList.add(new EventYearListing.fromSnapshot(event.snapshot).key);
      });
    });
    databaseRef.child("serverUpdate").once().then((DataSnapshot snapshot) {
      if (snapshot.value) {
        print("SERVER UPDATING...");
        serverUpdateDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: new Text(title),
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 25.0,
              fontFamily: "Product Sans",
              fontWeight: FontWeight.bold
            )
          ),
        ),
        backgroundColor: primaryAccent,
        floatingActionButton: currentButton,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: mainColor,
          currentIndex: currentTab,
          onTap: tabTapped,
          items: [
            new BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home", style: TextStyle(fontFamily: "Product Sans", fontSize: 13.0))),
            new BottomNavigationBarItem(
                icon: Icon(Icons.group),
                title: Text("Conferences", style: TextStyle(fontFamily: "Product Sans", fontSize: 13.0))),
            new BottomNavigationBarItem(
                icon: Icon(Icons.event),
                title: Text("Events", style: TextStyle(fontFamily: "Product Sans", fontSize: 13.0))),
            new BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                title: Text("Chat", style: TextStyle(fontFamily: "Product Sans", fontSize: 13.0))),
            new BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text("Settings", style: TextStyle(fontFamily: "Product Sans", fontSize: 13.0))),
          ],
        ),
        drawer: Drawer(
          child: UserDrawer(),
        ),
        body: new Container(
          child: new PageView(
            onPageChanged: pageChanged,
            controller: pageController,
            children: <Widget>[
              HomePage(),
              ConferencesPage(),
              EventPage(),
              ChatPage(),
              SettingsPage()
            ],
          ),
        ));
  }
}
