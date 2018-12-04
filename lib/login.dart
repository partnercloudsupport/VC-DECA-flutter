import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  String _email = "";
  String _password = "";

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  Widget buttonChild = new Text("Login");

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Error"),
          content: new Text(
            "There was an error logging you in: $error",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 14.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GOT IT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void login() async {
    setState(() {
      buttonChild = new HeartbeatProgressIndicator(
        child: Image.asset(
          'images/logo_white_trans.png',
          height: 15.0,
        ),
      );
    });
    try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      print("Signed in! ${user.uid}");

      userID = user.uid;

      databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
        var userInfo = snapshot.value;
        email = userInfo["email"];
        role = userInfo["role"];
        name = userInfo["name"];
        chapGroupID = userInfo["group"];
        darkMode = userInfo["darkMode"];
        print("");
        print("------------ USER DEBUG INFO ------------");
        print("NAME: $name");
        print("EMAIL: $email");
        print("ROLE: $role");
        print("USERID: $userID");
        print("-----------------------------------------");
        print("");
      });

      storageRef.child("users").child("$userID.png").getData(10000000).then((data) {
        profilePic = data;
      });

      router.navigateTo(context,'/registered', transition: TransitionType.fadeIn, clearStack: true);
    }
    catch (error) {
      print("Error: ${error.details}");
      accountErrorDialog(error.details);
    }
    setState(() {
      buttonChild = new Text("Login");
    });
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "VC DECA",
          style: TextStyle(
              fontFamily: "Product Sans",
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text("Login to your VC DECA Account below!", style: TextStyle(fontFamily: "Product Sans",),),
              new Padding(padding: EdgeInsets.all(8.0)),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.email),
                    labelText: "Email",
                    hintText: "Enter your email"
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                onChanged: emailField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Password",
                    hintText: "Enter a password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: passwordField,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: login,
                color: Colors.blue,
                textColor: Colors.white,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                splashColor: Colors.blue,
                onPressed: () {
                  router.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
