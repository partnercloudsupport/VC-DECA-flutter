import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirm = "";

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  Widget buttonChild = new Text("Create Account");

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Account Creation Error"),
          content: new Text(
            "There was an error creating your VC DECA Account: $error",
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

  void register() async {
    setState(() {
      buttonChild = new HeartbeatProgressIndicator(
        child: Image.asset(
          'images/logo_white_trans.png',
          height: 15.0,
        ),
      );
    });
    if (_name == "") {
      print("Name cannot be empty");
      accountErrorDialog("Name cannot be empty");
    }
    else if (_password != _confirm) {
      print("Password don't match");
      accountErrorDialog("Passwords do not match");
    }
    else if (_email == "") {
      print("Email cannot be empty");
      accountErrorDialog("Email cannot be empty");
    }
    else {
      try {
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        print("Signed in! ${user.uid}");

        name = _name;
        email = _email;
        userID = user.uid;
        role = "Member";

        user.sendEmailVerification();

//        databaseRef.child("users").child(userID).update({
//          "name": name,
//          "email": email,
//          "role": role,
//          "userID": userID,
//          "group": "Not in a Group",
//          "mentorGroup": "Not in a Group",
//          "darkMode": darkMode
//        });
//
//        print("");
//        print("------------ USER DEBUG INFO ------------");
//        print("NAME: $name");
//        print("EMAIL: $email");
//        print("ROLE: $role");
//        print("USERID: $userID");
//        print("-----------------------------------------");
//        print("");
//
//        storageRef.child("users").child("$userID.png").putData(profilePic);
//
//        router.navigateTo(context,'/registered', transition: TransitionType.fadeIn, clearStack: true);
      }
      catch (error) {
        print("Error: ${error.details}");
        accountErrorDialog(error.details);
      }
    }
    setState(() {
      buttonChild = new Text("Create Account");
    });
  }

  void nameField(input) {
    _name = input;
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void confirmField(input) {
    _confirm = input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
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
              new Text("Create your VC DECA Account below!", style: TextStyle(fontFamily: "Product Sans",),),
              new Padding(padding: EdgeInsets.all(8.0)),
              new TextField(
                decoration: InputDecoration(
                  icon: new Icon(Icons.person),
                  labelText: "Name",
                  hintText: "Enter your full name"
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: nameField,
              ),
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
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Confirm Password",
                    hintText: "Confirm your password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: confirmField,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: register,
                color: mainColor,
                textColor: Colors.white,
                highlightColor: mainColor,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
                splashColor: mainColor,
                onPressed: () {
                  router.navigateTo(context,'/toLogin', transition: TransitionType.fadeIn);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
