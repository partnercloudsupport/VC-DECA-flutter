import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'user_info.dart';
import 'package:fluro/fluro.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class GlobalChatPage extends StatefulWidget {
  @override
  _GlobalChatPageState createState() => _GlobalChatPageState();
}

class ChatMessage {
  String key;
  String message;
  String author;
  String authorID;
  String authorRole;
  String mediaType;

  ChatMessage(this.message, this.author, this.authorRole);

  ChatMessage.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        message = snapshot.value["message"].toString(),
        authorRole = snapshot.value["role"].toString(),
        authorID = snapshot.value["userID"].toString(),
        mediaType = snapshot.value["type"].toString(),
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

  Color sendColor = Colors.grey;

  Color memberColor = Colors.grey;
  Color officerColor = Colors.grey;
  Color adminColor = Colors.grey;
  Color botColor = Colors.grey;
  Color advisorColor = Colors.grey;

  String type = "text";
  String message = "";

  _GlobalChatPageState() {
    databaseRef.child("chatColors").once().then((DataSnapshot snapshot) {
      setState(() {
        memberColor = HexColor(snapshot.value["memberColor"]);
        officerColor = HexColor(snapshot.value["officerColor"]);
        adminColor = HexColor(snapshot.value["adminColor"]);
        botColor = HexColor(snapshot.value["botColor"]);
        advisorColor = HexColor(snapshot.value["advisorColor"]);
      });
    });
    databaseRef.child("chat").child(selectedChat).onChildAdded.listen(onNewMessage);
    if (role != "Member") {
      _visible = true;
    }
  }

  void sendImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Send Image", style: TextStyle(fontFamily: "Product Sans"),),
            content: new ChatImageUpload(),
          );
        }
    );
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

  void sendMessage() {
    if (message != "" && message != " " && message != "  " && message != "  ") {
      databaseRef.child("chat").child(selectedChat).push().update({
        "author": name,
        "message": message,
        "userID": userID,
        "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
        "role": role,
        "type": type,
      });
      myController.clear();
      setState(() {
        message = "";
        sendColor = Colors.grey;
      });
    }
  }
  
  void textChanged(String input) {
    if (input != "" && input != " " && input != "  " && input != "  ") {
      type = "text";
      setState(() {
        message = input;
        sendColor = mainColor;
      });
    }
    else {
      setState(() {
        message = input;
        sendColor = Colors.grey;
      });
    }
  }

  Color getColor(String authorRole, String messageAuthor) {
    if (messageAuthor == name && authorRole == role) {
      return mainColor;
    }
    else if (authorRole == "Member") {
      return memberColor;
    }
    else if (authorRole == "Officer") {
      return officerColor;
    }
    else if (authorRole == "Admin") {
      return adminColor;
    }
    else if (authorRole == "Advisor") {
      return advisorColor;
    }
    else if (authorRole == "Bot") {
      return botColor;
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

  Widget getMessageBody(int index) {
    if (messageList[index].mediaType == "text") {
      return new Linkify(
        onOpen: (url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        text: messageList[index].message,
        linkStyle: TextStyle(
            fontFamily: "Product Sans",
            color: getColor(messageList[index].authorRole, messageList[index].author),
            fontSize: 16.0
        ),
        style: TextStyle(
            fontFamily: "Product Sans",
            color: Colors.black,
            fontSize: 16.0
        ),
      );
    }
    else {
      return new Container(
        padding: EdgeInsets.all(8.0),
        child: new ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: new CachedNetworkImage(
            imageUrl: messageList[index].message,
            height: 300.0,
            width: 300.0,
            fit: BoxFit.cover,
          ),
        ),
      );
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
                            getMessageBody(index)
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
                child: Row(
                  children: <Widget>[
                    // Button send image
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          icon: new Icon(Icons.image),
                          color: Colors.grey,
                          onPressed: () {
                            sendImageDialog();
//                            router.navigateTo(context, '/chatImage', transition: TransitionType.nativeModal);
                          },
                        ),
                      ),
                      color: Colors.white,
                    ),
                    // Edit text
                    Flexible(
                      child: Container(
                        child: TextField(
                          controller: myController,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(fontFamily: "Product Sans", color: Colors.black, fontSize: 16.0),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(fontFamily: "Product Sans")
                          ),
                          focusNode: myFocusNode,
                          onChanged: textChanged,
                        ),
                      ),
                    ),
                    new Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 8.0),
                        child: new IconButton(
                            icon: new Icon(Icons.send),
                            color: sendColor,
                            onPressed: sendMessage
                        ),
                      ),
                      color: Colors.white,
                    )
                  ],
                ),
                width: double.infinity,
                height: 50.0,
                decoration: new BoxDecoration(
                  border: new Border(top: new BorderSide(color: mainColor, width: 0.5)), color: Colors.white),
              )
            )
          ],
        ),
      ),
    );
  }
}

class ChatImageUpload extends StatefulWidget {
  @override
  _ChatImageUploadState createState() => _ChatImageUploadState();
}

class _ChatImageUploadState extends State<ChatImageUpload> {

  final storageRef = FirebaseStorage.instance.ref();
  final databaseRef = FirebaseDatabase.instance.reference();

  double _progress = 0.0;
  String uploadStatus = "";

  Future<void> updateProfile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("UPLOADING");
      StorageUploadTask profileUploadTask = storageRef.child("chat").child("${formatDate(DateTime.now(), [dd, mm, yyyy, HH, nn, ss])}.png").putFile(image);
      profileUploadTask.events.listen((event) {
        print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
        setState(() {
          uploadStatus = "Uploading - ${(event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble() * 100).round()}%";
          _progress = (event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble());
          if (event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble() == 1.0) {
            uploadStatus = "Sent!";
            print("DONE!");
          }
        });
      });
      var downUrl = await (await profileUploadTask.onComplete).ref.getDownloadURL();
      var url = downUrl.toString();
      databaseRef.child("chat").child(selectedChat).push().update({
        "author": name,
        "message": url,
        "userID": userID,
        "date": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
        "role": role,
        "type": "media",
      });
      router.pop(context);
    }
    else {
      router.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      height: 200.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            child: new CachedNetworkImage(
              imageUrl: "https://raw.githubusercontent.com/Team3256/myWB-flutter/master/images/new.png",
              height: 100.0,
              fit: BoxFit.fitHeight,
            ),
            onTap: updateProfile,
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Container(
            child: new Column(
              children: <Widget>[
                new Text(
                  uploadStatus,
                  style: TextStyle(fontFamily: "Product Sans", fontSize: 20.0),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new LinearProgressIndicator(
                  value: _progress,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
