import 'package:flutter/material.dart';
import 'package:ix_app_demo/database/firebase_service.dart';
import 'dart:io';
import 'package:universal_platform/universal_platform.dart';

class ImageDetails extends StatefulWidget {
  var tags;
  var views;
  var img;
  var downloads;
  var likes;

  ImageDetails(this.tags, this.views, this.img, this.downloads, this.likes);
  @override
  _ImageDetailsState createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

  void addToDatabase(String img, String view, String likes) async {
    try {
      await FirebaseService().addToOurDb(img, view, likes);
      showSnackSaved();
    } catch (err) {
      print(err);
    }
  }

  showSnackSaved() {
    final snackbar = new SnackBar(
      content: new Text("Saved to database"),
      duration: new Duration(seconds: 2),
      backgroundColor: Colors.green,
    );

    _scaffKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Image details'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 500.0,
                  height: 150.0,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: NetworkImage(widget.img), fit: BoxFit.fitHeight),
                  ),
                ),
                Divider(),
                SizedBox(height: 20.0),
                Text(
                  "USER INTERACTIONS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                    Text(
                      widget.likes,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(width: 30.0),
                    Icon(
                      Icons.visibility,
                      color: Colors.blue,
                    ),
                    Text(
                      widget.views,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(width: 30.0),
                    Icon(
                      Icons.file_download,
                      color: Colors.green,
                    ),
                    Text(
                      widget.downloads,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 30.0),
                Text(
                  "USER TAGS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  widget.tags,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Divider(),
                SizedBox(height: 20.0),
                Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      addToDatabase(widget.img, widget.views, widget.likes);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Add To IX Database!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
