import 'package:flutter/material.dart';
import 'user_info.dart';
import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();

  var _visible = false;
  bool _mentorVisible = true;
  bool _advisorVisible = false;

  String joinGroup = "";
  
  final errorSnackbar = new SnackBar(content: Text("It looks like that chaperone group doesn't exist!", style: TextStyle(fontFamily: "Product Sans"),));

  void toOfficerChat() {
    chatTitle = "Officers";
    selectedChat = "officers";
    router.navigateTo(context, '/chat', transition: TransitionType.native);
  }

  void toAdvisorChat() {
    chatTitle = "Advisors";
    selectedChat = "advisors";
    router.navigateTo(context, '/chat', transition: TransitionType.native);
  }

  void toChaperoneChat() {
    if (chapGroupID != "Not in a Group") {
      print("Already in a group!");
      chatTitle = "Chaperone Group";
      selectedChat = chapGroupID;
      router.navigateTo(context, '/chat', transition: TransitionType.native);
    }
    else {
      print("Need to join a group!");
      joinGroupDialog();
    }
  }

  void toMentorChat() {
    if (mentorGroupID != "Not in a Group") {
      print("Already in a group!");
      chatTitle = "Mentor Group";
      selectedChat = mentorGroupID;
      router.navigateTo(context, '/chat', transition: TransitionType.native);
    }
    else if (role == "Officer") {
      print("Need to create a group!");
      createMentorGroupDialog();
    }
    else {
      print("Need to join a group!");
      joinMentorGroupDialog();
    }
  }
  
  void joinGroupDialog() {
    joinGroup = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Join Chaperone Group", style: TextStyle(fontFamily: "Product Sans")),
          content: new Container(
            height: 75.0,
            child: new Column(
              children: <Widget>[
                new TextField(
                  onChanged: (String input) {
                    joinGroup = input;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      labelText: "Group Code",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("JOIN"),
              onPressed: () {
                if (joinGroup != "") {
                  databaseRef.child("chat").child(joinGroup).once().then((DataSnapshot snapshot) {
                    if (snapshot.value != null) {
                      print("Group exists");
                      setState(() {
                        chapGroupID = joinGroup;
                      });
                      databaseRef.child("users").child(userID).update({
                        "group": chapGroupID
                      });
                      joinGroup = "";
                      Navigator.of(context).pop();
                    }
                    else {
                      print("Failed to find chaperone group");
                    }
                  });
                }
                else {
                  print("Failed to find chaperone group");
                }
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                joinGroup = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void joinMentorGroupDialog() {
    joinGroup = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Join Mentor Group", style: TextStyle(fontFamily: "Product Sans")),
          content: new Container(
            height: 75.0,
            child: new Column(
              children: <Widget>[
                new TextField(
                  onChanged: (String input) {
                    joinGroup = input;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: "Group Code",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("JOIN"),
              onPressed: () {
                if (joinGroup != "") {
                  databaseRef.child("chat").child(joinGroup).once().then((DataSnapshot snapshot) {
                    if (snapshot.value != null) {
                      print("Group exists");
                      setState(() {
                        mentorGroupID = joinGroup;
                      });
                      databaseRef.child("users").child(userID).update({
                        "mentorGroup": mentorGroupID
                      });
                      joinGroup = "";
                      Navigator.of(context).pop();
                    }
                    else {
                      print("Failed to find mentor group");
                    }
                  });
                }
                else {
                  print("Failed to find mentor group");
                }
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                joinGroup = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void createMentorGroupDialog() {
    String newGroupCode = "";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Create Your Mentor Group"),
          content: new Container(
            height: 150.0,
            child: new Column(
              children: <Widget>[
                new TextField(
                  onChanged: (String input) {
                    newGroupCode = input;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      labelText: "Group Code",
                      hintText: "Create a mentor group code"
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CREATE"),
              onPressed: () {
                if (newGroupCode != "") {
                  databaseRef.child("chat").child(newGroupCode).push().update({
                    "author": "Group Creator",
                    "message": "Welcome to $name's mentor group!",
                    "date": "N/A",
                    "role": "Bot",
                    "type": "text"
                  });
                  setState(() {
                    mentorGroupID = newGroupCode;
                  });
                  databaseRef.child("users").child(userID).update({
                    "mentorGroup": mentorGroupID
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

  void leaveGroupBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to leave your chaperone group?', style: TextStyle(fontFamily: "Product Sans"),),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yeah, I wanna leave!', style: TextStyle(fontFamily: "Product Sans"),),
                  onTap: () {
                    setState(() {
                      chapGroupID = "Not in a Group";
                      databaseRef.child("users").child(userID).child("group").set(chapGroupID);
                      router.pop(context);
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel', style: TextStyle(fontFamily: "Product Sans"),),
                  onTap: () {
                    router.pop(context);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  void leaveMentorGroupBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to leave your mentor group?', style: TextStyle(fontFamily: "Product Sans"),),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yeah, I wanna leave!', style: TextStyle(fontFamily: "Product Sans"),),
                  onTap: () {
                    setState(() {
                      mentorGroupID = "Not in a Group";
                      databaseRef.child("users").child(userID).child("mentorGroup").set(mentorGroupID);
                      router.pop(context);
                    });
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel', style: TextStyle(fontFamily: "Product Sans"),),
                  onTap: () {
                    router.pop(context);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    if (role != "Member") {
      _visible = true;
    }
    if (role == "Advisor" || role == "Chaperone") {
      _mentorVisible = false;
    }
    if (role == "Admin" || role == "Advisor" || role == "Chaperone") {
      _advisorVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: Text("General Chat", style: TextStyle(fontFamily: "Product Sans"),),
            onTap: () {
              print("Entering Global Chat");
              selectedChat = "global";
              chatTitle = "General";
              router.navigateTo(context, '/chat', transition: TransitionType.native);
            },
            trailing: new Icon(
              Icons.arrow_forward_ios,
              color: mainColor,
            ),
          ),
          new Divider(
            height: 0.0,
            color: mainColor,
          ),
          new ListTile(
            title: Text("Chaperone Group", style: TextStyle(fontFamily: "Product Sans")),
            subtitle: Text(chapGroupID, style: TextStyle(fontFamily: "Product Sans")),
            onTap: () {
              print("Entering Chaperone Chat");
              toChaperoneChat();
            },
            onLongPress: () {
              if (chapGroupID != "Not in a Group") {
                leaveGroupBottomSheet();
              }
            },
            trailing: new Icon(
              Icons.arrow_forward_ios,
              color: mainColor,
            ),
          ),
          new Divider(
            height: 0.0,
            color: mainColor,
          ),
          new Visibility(
            visible: _mentorVisible,
            child: new ListTile(
              title: Text("Mentor Group", style: TextStyle(fontFamily: "Product Sans")),
              subtitle: Text(mentorGroupID, style: TextStyle(fontFamily: "Product Sans")),
              onTap: () {
                print("Entering Mentor Chat");
                toMentorChat();
              },
              onLongPress: () {
                if (mentorGroupID != "Not in a Group" && role != "Officer") {
                  leaveMentorGroupBottomSheet();
                }
              },
              trailing: new Icon(
                Icons.arrow_forward_ios,
                color: mainColor,
              ),
            ),
          ),
          new Visibility(
            visible: _mentorVisible,
            child: new Divider(
              height: 0.0,
              color: mainColor,
            ),
          ),
          new Visibility(
            visible: _visible,
            child: new ListTile(
              title: Text("Officer Chat", style: TextStyle(fontFamily: "Product Sans")),
              onTap: toOfficerChat,
              trailing: new Icon(
                Icons.arrow_forward_ios,
                color: mainColor,
              ),
            ),
          ),
          new Visibility(
            visible: _visible,
            child: new Divider(
              height: 0.0,
              color: mainColor,
            ),
          ),
          new Visibility(
            visible: _advisorVisible,
            child: new ListTile(
              title: Text("Advisor Chat", style: TextStyle(fontFamily: "Product Sans")),
              onTap: toAdvisorChat,
              trailing: new Icon(
                Icons.arrow_forward_ios,
                color: mainColor,
              ),
            ),
          ),
          new Visibility(
            visible: _visible,
            child: new Divider(
              height: 0.0,
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
