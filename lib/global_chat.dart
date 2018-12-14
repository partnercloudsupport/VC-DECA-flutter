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
  final myController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<ChatMessage> messageList = new List();
  var listSize;
  bool _visible = false;

  _GlobalChatPageState() {
    databaseRef.child("chat").child("global").onChildAdded.listen(onNewMessage);
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

  onMessageDeletion(Event event) {
    var oldValue =
    messageList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      messageList.removeAt(messageList.indexOf(oldValue));
    });
  }

  void onMessageType(String input) {
    setState(() {
      listSize = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 1.5);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage(String input) {
    if (input != "" && input != " ") {
      databaseRef.child("chat").child("global").push().update({
        "author": name,
        "message": input,
        "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
        "role": role
      });
    }
    setState(() {
      listSize = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 4);
    });
    myController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 10,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Color getColor(String authorRole, String messageAuthor) {
    if (messageAuthor == name && authorRole == role) {
      return Colors.blue;
    }
    else if (authorRole == "Member") {
      return Colors.amber;
    }
    else {
      return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    listSize = 500.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("General"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: new Container(
        color: Colors.white,
        height: 100.0,
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: new TextField(
          controller: myController,
          autocorrect: true,
          textInputAction: TextInputAction.send,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(fontFamily: "Product Sans", color: Colors.black, fontSize: 16.0),
          onSubmitted: sendMessage,
          onChanged: onMessageType,
          decoration: InputDecoration(
            labelStyle: TextStyle(fontFamily: "Product Sans",),
            hintStyle: TextStyle(fontFamily: "Product Sans",),
            labelText: "Enter Message",
            hintText: "Type a new message to send"
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: new SafeArea(
        child: new Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.white,
          height: listSize,
//          padding: EdgeInsets.all(16.0),
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
                      new Text(
                        messageList[index].author,
                        style: TextStyle(
                            fontFamily: "Product Sans",
                            color: getColor(messageList[index].authorRole, messageList[index].author),
                            fontSize: 16.0
                        ),
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
                        databaseRef.child("chat").child("global").child(messageList[index].key).remove();
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
