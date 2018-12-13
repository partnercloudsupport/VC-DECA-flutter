import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String devicePlatform = "";
  String deviceName = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      devicePlatform = "iOS";
    }
    else if (Platform.isAndroid) {
      devicePlatform = "Android";
    }
    deviceName = Platform.localHostname;
  }

  launchContributeUrl() async {
    const url = 'https://github.com/BK1031/VC-DECA-flutter';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchGuidelinesUrl() async {
    const url = 'https://github.com/BK1031/VC-DECA-flutter/wiki/contributing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: new Text("About"),
          textTheme: TextTheme(
              title: TextStyle(
                  fontSize: 25.0,
                  fontFamily: "Product Sans",
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        body: new SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                new Card(
                  color: primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Device", style: TextStyle(color: Colors.blue, fontFamily: "Product Sans",fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("App Version", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$appVersion$appStatus", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Device Name", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$deviceName", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Platform", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$devicePlatform", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Credits", style: TextStyle(fontFamily: "Product Sans", color: Colors.blue, fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("Bharat Kathi", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("App Development", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://twitter.com/BK1031_OFFICIAL';
                          launch(url);
                        },
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Myron Chan", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("App Design", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://www.instagram.com/myronchan_/';
                          launch(url);
                        },
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Ian Lau", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("Marketing", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://www.instagram.com/chickian03/?hl=en';
                          launch(url);
                        },
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Andrew Zhang", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("Documentation", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://www.instagram.com/a.__.zhang/';
                          launch(url);
                        },
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Kashyap Chaturvedula", style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                      new ListTile(
                        title: new Text("Thomas Liang", style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                      new ListTile(
                          title: new Text("Micah Kim", style: TextStyle(fontFamily: "Product Sans",)),
                        ),
                    new ListTile(
                          title: new Text("Yaseen Elashmawi", style: TextStyle(fontFamily: "Product Sans",)),
                        ),
                    new ListTile(
                          title: new Text("Amber Lao", style: TextStyle(fontFamily: "Product Sans",)),
                        ),
                      new ListTile(
                        subtitle: new Text("Beta Testers\n", style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Contributing", style: TextStyle(fontFamily: "Product Sans", color: Colors.blue, fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("View on GitHub", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                        onTap: () {
                          launchContributeUrl();
                        },
                      ),
                      new Divider(height: 0.0, color: Colors.blue),
                      new ListTile(
                        title: new Text("Contributing Guidelines", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                        onTap: () {
                          launchGuidelinesUrl();
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new Text("© Equinox Initiative 2018", style: TextStyle(fontFamily: "Product Sans", color: Colors.grey),),
                new Image.asset(
                    'images/full_black_trans.png',
                    height: 120.0,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        )
    );
  }
}