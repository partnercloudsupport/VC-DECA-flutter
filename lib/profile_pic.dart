import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  final storageRef = FirebaseStorage.instance.ref();

  double _progress = 0.0;
  String uploadStatus = "";
  bool _visible = true;
  Icon buttonTxt = Icon(Icons.clear);

  Future<void> updateProfile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          ratioX: 1.0,
          ratioY: 1.0,
          maxHeight: 512,
          maxWidth: 512,
          toolbarColor: Colors.blue,
      );
      if (croppedImage != null) {
        setState(() {
          _visible = false;
        });
        print("UPLOADING");
        StorageUploadTask profileUploadTask = storageRef.child("users").child("$userID.png").putFile(croppedImage);
        profileUploadTask.events.listen((event) {
          print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
          setState(() {
            uploadStatus = "Uploading - ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble() * 100}%";
            _progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
            if (event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble() == 1.0) {
              setState(() {
                uploadStatus = "Saving Changes...";
              });
              print("DOWNLOADING");
              storageRef.child("users").child("$userID.png").getData(10000000).then((data) {
                setState(() {
                  uploadStatus = "Finished!";
                  profilePic = data;
                  buttonTxt = Icon(Icons.check);
                  _visible = true;
                });
              });
              print("DONE!");
            }
          });
        });
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Update Profile"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
        leading: new Container(
          child: new Visibility(
            child: new IconButton(
              icon: buttonTxt,
              color: Colors.white,
              onPressed: () {
                router.pop(context);
              },
            ),
            visible: _visible,
          ),
        )
      ),
      body: new Container(
        width: 1000.0,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              child: new ClipOval(
                child: new Image.memory(
                  profilePic,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.fill,
                ),
              ),
              onTap: updateProfile,
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              "(Click to edit)",
              style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        padding: EdgeInsets.all(16.0),
        height: 150.0,
        child: new Column(
          children: <Widget>[
            new Text(
              uploadStatus,
              style: TextStyle(fontFamily: "Product Sans", fontSize: 25.0),
            ),
            new Padding(padding: EdgeInsets.all(8.0)),
            new LinearProgressIndicator(
              value: _progress,
            )
          ],
        ),
      )
    );
  }
}
