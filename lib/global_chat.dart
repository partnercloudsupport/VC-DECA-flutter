import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GlobalChatPage extends StatefulWidget {
  @override
  _GlobalChatPageState createState() => _GlobalChatPageState();
}

class ChatMessage {
  String key;
  String message;
  String author;
  String authorRole;

  ChatMessage(this.message, this.author, this.authorRole);

  ChatMessage.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        message = snapshot.value["message"].toString(),
        authorRole = snapshot.value["role"].toString(),
        author = snapshot.value["author"].toString();

  toJson() {
    return {
      "message": message,
      "author": author
    };
  }
}

class _GlobalChatPageState extends State<GlobalChatPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();
  final myController = new TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  ScrollController _scrollController = new ScrollController();
  List<ChatMessage> messageList = new List();
  bool _visible = false;

  _GlobalChatPageState() {
    databaseRef.child("chat").child(selectedChat).onChildAdded.listen(onNewMessage);
    if (role == "Admin") {
      _visible = true;
    }
  }

  onNewMessage(Event event) async {
    setState(() {
      messageList.add(new ChatMessage.fromSnapshot(event.snapshot));
    });
    await new Future.delayed(const Duration(milliseconds: 300));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 10.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage(String input) {
    if (input != "" && input != " ") {
      databaseRef.child("chat").child(selectedChat).push().update({
        "author": name,
        "message": input,
        "userID": userID,
        "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
        "role": role
      });
    }
    myController.clear();
  }

  Color getColor(String authorRole, String messageAuthor) {
    if (messageAuthor == name && authorRole == role) {
      return mainColor;
    }
    else if (authorRole == "Member") {
      return Colors.amber;
    }
    else if (authorRole == "Bot") {
      return Colors.greenAccent;
    }
    else {
      return Colors.redAccent;
    }
  }

  bool getVisibility(String authorRole, String messageAuthor) {
    if (messageAuthor == name && authorRole == role) {
      return false;
    }
    else if (authorRole == "Member") {
      return false;
    }
    else {
      return true;
    }
  }

  Future<Null> focusNodeListener() async {
    if (myFocusNode.hasFocus) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 10.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(focusNodeListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text(chatTitle),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: Column(
          children: <Widget>[
            new Expanded(
              child: new Container(
                padding: EdgeInsets.all(8.0),
                child: new ListView.builder(
                  itemCount: messageList.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return new Slidable(
                      delegate: new SlidableDrawerDelegate(),
                      child: new Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: new BoxDecoration(
                          border: new Border(
                            left: new BorderSide(
                              color: getColor(messageList[index].authorRole, messageList[index].author),
                              width: 3.0,
                            )
                          ),
                        ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  messageList[index].author,
                                  style: TextStyle(
                                      fontFamily: "Product Sans",
                                      color: getColor(messageList[index].authorRole, messageList[index].author),
                                      fontSize: 16.0
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(4.0)),
                                new Visibility(
                                  visible: getVisibility(messageList[index].authorRole, messageList[index].author),
                                  child: new Card(
                                      color: getColor(messageList[index].authorRole, messageList[index].author),
                                      child: new Container(
                                        padding: EdgeInsets.all(4.0),
                                        child: new Text(
                                          messageList[index].authorRole,
                                          style: TextStyle(
                                              fontFamily: "Product Sans",
                                              color: Colors.white,
                                              fontSize: 16.0
                                          ),
                                        ),
                                      )
                                  ),
                                )
                              ],
                            ),
                            new Text(
                              messageList[index].message,
                              style: TextStyle(
                                  fontFamily: "Product Sans",
                                  color: Colors.black,
                                  fontSize: 16.0
                              ),
                            ),
                          ],
                        )
                      ),
                      secondaryActions: <Widget>[
                        new Visibility(
                          visible: _visible,
                          child: new IconSlideAction(
                            icon: Icons.clear,
                            caption: "Delete",
                            color: Colors.red,
                            onTap: () {
                              setState(() {
                                databaseRef.child("chat").child(selectedChat).child(messageList[index].key).remove();
                                messageList.removeAt(index);
                              });
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            new ListTile(
              title: Container(
                height: 75.0,
                child: new TextField(
                  controller: myController,
                  focusNode: myFocusNode,
                  autocorrect: true,
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontFamily: "Product Sans", color: Colors.black, fontSize: 16.0),
                  onSubmitted: sendMessage,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(fontFamily: "Product Sans",),
                      hintText: "Enter Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
