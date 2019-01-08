import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'user_info.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Help"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: const WebView(
        initialUrl: 'https://github.com/BK1031/VC-DECA-flutter/wiki/Help',
        javaScriptMode: JavaScriptMode.unrestricted,
      ),
    );
  }
}
