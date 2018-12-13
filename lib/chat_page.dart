import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();

  var _visible = false;

  String joinGroup = "";

  void toOfficerChat() {
    router.navigateTo(context, '/officerChat', transition: TransitionType.native);
  }

  void toChaperoneChat() {
    if (chapGroupID != "Not in a Group") {
      print("Already in a group!");
      router.navigateTo(context, '/chapChat', transition: TransitionType.native);
    }
    else {
      print("Need to join a group!");
      joinGroupDialog();
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

  void leaveGroupBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to leave your chaperone group?'),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yeah, I wanna leave!'),
                  onTap: () {
                    chapGroupID = "Not in a Group";
                    router.pop(context);
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
  void initState() {
    super.initState();
    if (role != "Member") {
      _visible = true;
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
              router.navigateTo(context, '/globalChat', transition: TransitionType.native);
            },
            trailing: new Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
            ),
          ),
          new Divider(
            height: 0.0,
            color: Colors.blue,
          ),
          new ListTile(
            title: Text("Chaperone Group", style: TextStyle(fontFamily: "Product Sans")),
            subtitle: Text(chapGroupID, style: TextStyle(fontFamily: "Product Sans")),
            onTap: () {
              print("Entering Chaperone Chat");
              toChaperoneChat();
            },
            trailing: new Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
            ),
          ),
          new Divider(
            height: 0.0,
            color: Colors.blue,
          ),
          new Visibility(
            visible: _visible,
            child: new ListTile(
              title: Text("Officer Chat", style: TextStyle(fontFamily: "Product Sans")),
              onTap: toOfficerChat,
              trailing: new Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
              ),
            ),
          ),
          new Visibility(
            visible: _visible,
            child: new Divider(
              height: 0.0,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
