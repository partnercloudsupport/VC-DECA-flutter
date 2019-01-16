import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:fluro/fluro.dart';
import 'user_info.dart';

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> checkUserLogged() async {

    storageRef.child("default.png").getData(10000000).then((data) {
      profilePic = data;
    });

    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      //User logged in
      print("User Logged");
      userID = user.uid;

      databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
        var userInfo = snapshot.value;
        email = userInfo["email"];
        role = userInfo["role"];
        name = userInfo["name"];
        chapGroupID = userInfo["group"];
        mentorGroupID = userInfo["mentorGroup"];
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

      router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, replace: true);
    }
    else {
      //User log required
      print("User Not Logged");

      router.navigateTo(context, '/notLogged', transition: TransitionType.fadeIn, replace: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
    );
  }
}
