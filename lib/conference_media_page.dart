import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_info.dart';

class ConferenceMediaPage extends StatelessWidget {
  @override

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  ConferenceMediaPage() {
    print("Hello Media!");
    databaseRef.child("conferences").child(selectedYear).child("media").onChildAdded.listen((Event event) {
      print(event.snapshot.value);
      _tiles.add(_ConferenceMediaPage(event.snapshot.value));
    });
  }

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(3, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(4, 1),
  ];


  List<Widget> _tiles = <Widget>[];

  Future<void> newImage() async {
    var now = DateTime.now();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("UPLOADING");
      StorageUploadTask uploadTask = storageRef.child("conferences").child(selectedYear).child("$now.png").putFile(image);
      uploadTask.events.listen((event) {
        print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
      });
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = dowurl.toString();
      databaseRef.child("conferences").child(selectedYear).child("media").push().set(url);
    }
  }


  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: newImage,
        ),
        body: new Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: new StaggeredGridView.count(
              crossAxisCount: 4,
              staggeredTiles: _staggeredTiles,
              children: _tiles,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )));
  }
}

class _ConferenceMediaPage extends StatelessWidget {
  const _ConferenceMediaPage(this.gridImage);

  final gridImage;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: const Color(0x00000000),
      elevation: 3.0,
      child: new GestureDetector(
        onTap: () {
          print("hello");
        },
        child: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(gridImage),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
            )
        ),
      ),
    );
  }
}