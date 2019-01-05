import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'network_check_again.dart';
import 'user_info.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'network_checker.dart';
import 'onboarding_page.dart';
import 'register_page.dart';
import 'auth_checker.dart';
import 'alert_view.dart';
import 'tab_bar_controller.dart';
import 'global_chat.dart';
import 'about_page.dart';
import 'bug_report.dart';
import 'event_category.dart';
import 'event_view.dart';
import 'conference_event_view.dart';
import 'conference_view.dart';
import 'help_page.dart';
import 'mydeca_page.dart';
import 'package:fluro/fluro.dart';
import 'profile_pic.dart';
import 'event_cluster.dart';

void main() {

  router.define('/checkConnection', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConnectionChecker();
  }));

  router.define('/checkConnectionAgain', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConnectionCheckerAgain();
  }));

  router.define('/alert', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AlertPage();
  }));

  router.define('/checkAuth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthChecker();
  }));

  router.define('/logged', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));

  router.define('/notLogged', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OnboardingPage();
  }));

  router.define('/toRegister', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));

  router.define('/toLogin', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  router.define('/registered', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));

  router.define('/chat', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new GlobalChatPage();
  }));

  router.define('/event', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventViewPage();
  }));

  router.define('/eventCategory', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventCategoryPage();
  }));

  router.define('/eventCluster', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ClusterPage();
  }));

  router.define('/myDECA', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new MyDecaPage();
  }));

  router.define('/conference', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceViewPage();
  }));

  router.define('/bugReport', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new BugReportPage();
  }));

  router.define('/aboutPage', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AboutPage();
  }));

  router.define('/helpPage', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HelpPage();
  }));

  router.define('/profilePic', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ProfilePic();
  }));

  router.define('/hotelMap', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HotelMapView();
  }));

  router.define('/conferenceAnnouncements', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceAnnouncementsPage();
  }));

  runApp(new MaterialApp(
    title: "VC DECA",
    home: ConnectionChecker(),
    onGenerateRoute: router.generator,
    debugShowCheckedModeBanner: false,
  ));
}