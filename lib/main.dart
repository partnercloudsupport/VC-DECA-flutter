import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:vc_deca_flutter/new_alert_page.dart';
import 'conference_schedule_view_page.dart';
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

  router.define('/newAlert', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NewAlertPage();
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

  router.define('/mapUrl', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new MapLocationView();
  }));

  router.define('/conferenceSite', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceSitePage();
  }));

  router.define('/compEventSite', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new CompetitiveEventsPage();
  }));

  router.define('/conferenceScheduleView', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceScheduleViewPage();
  }));

  router.define('/chatImage', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ChatImageUpload();
  }));

  router.define('/sampleEvent', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SampleEventPage();
  }));

  router.define('/sampleExam', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SampleExamPage();
  }));

  router.define('/sampleGuidelines', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SampleGuidelinesPage();
  }));

  runApp(new MaterialApp(
    title: "VC DECA",
    home: ConnectionChecker(),
    onGenerateRoute: router.generator,
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primaryColor: mainColor,
    ),
  ));
}