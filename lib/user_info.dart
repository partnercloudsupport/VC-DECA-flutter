import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

final router = Router();

double appVersion = 1.0;
int appBuild = 22;
String appStatus = "";
String appFull = "Version $appVersion";

String name = "";
String email = "";
String userID = "";
String chapGroupID = "Not in a Group";
String mentorGroupID = "Not in a Group";

var profilePic;

bool darkMode = false;
bool notifications = true;
bool chatNotifications = true;

String role = "Member";

String selectedAlert = "";

String selectedYear = "Please select a conference";

String selectedCategory = "";
String selectedEvent = "";
String selectedType = "";

String selectedAgenda = "";

Color eventColor = const Color(0xFF0073CE);
Color mainColor = const Color(0xFF0073CE);

String selectedMessage = "";
String selectedChat = "";
String chatTitle = "General";

List<String> yearsList = new List();

// Body Colors
Color primaryColor = Colors.white;
Color primaryAccent = null;

// Text Colors
Color primaryTextColor = Colors.black;
Color secondaryTextColor = Colors.grey;

String appLegal = """
MIT License

Copyright (c) 2018 Equinox Initiative

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";