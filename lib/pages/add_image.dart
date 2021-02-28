import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebaseStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

  CollectionReference imgRef;
  _firebaseStorage.Reference ref;
  File _image;
  bool is_loading = false;
  String downloadUrl = '';
  String likes = '0';
  String views = '0';
  double val = 0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('images');
  }

  Future getImage() async {
    var pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile?.path);
    });
  }

  Future uploadImg() async {
    if (_image != null) {
      setState(() {
        is_loading = true;
      });
      ref = _firebaseStorage.FirebaseStorage.instance
          .ref()
          .child('ix_image')
          .child("${randomAlphaNumeric(9)}.jpg");

      await ref.putFile(_image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'image_url': value, 'likes': likes, 'views': views});
        });
      });

      //downloadUrl = await (await task.onComplete).ref.getDownloadURL();

      print("the id is : $downloadUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffKey,
        appBar: AppBar(
          title: Text('Add your own image!'),
          backgroundColor: Colors.blue[900],
        ),
        body: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: _image != null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        width: MediaQuery.of(context).size.width,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              prefixIcon: Icon(
                                Icons.favorite,
                                color: Colors.black,
                              ),
                              hintText: "Enter likes",
                              filled: true,
                              fillColor: Colors.grey[200]),
                          validator: (val) =>
                              val.isEmpty ? 'Cannot be left empty' : null,
                          onChanged: (val) {
                            setState(() {
                              likes = val.trim();
                            });
                          },
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              prefixIcon: Icon(
                                Icons.view_list,
                                color: Colors.black,
                              ),
                              hintText: "Enter views",
                              filled: true,
                              fillColor: Colors.grey[200]),
                          validator: (val) =>
                              val.isEmpty ? 'Cannot be left empty' : null,
                          onChanged: (val) {
                            setState(() {
                              views = val.trim();
                            });
                          },
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                      Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              setState(() {
                                is_loading = true;
                              });
                              uploadImg().whenComplete(
                                  () => Navigator.of(context).pop());
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff374ABE),
                                    Color(0xff64B6FF)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 300.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Upload!",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              is_loading
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20.0),
                        Container(
                          child: Text(
                            'uploading...',
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          value: val,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        )
                      ],
                    ))
                  : Container(),
            ],
          )
        ]));
  }
}
