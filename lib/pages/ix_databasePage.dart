import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ix_app_demo/database/firebase_service.dart';
import 'package:ix_app_demo/models/imageModel.dart';
import 'package:ix_app_demo/pages/add_image.dart';

class IXPage extends StatefulWidget {
  @override
  _IXPageState createState() => _IXPageState();
}

class _IXPageState extends State<IXPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('IX Image App'),
        backgroundColor: Colors.blue[900],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.photo,
              color: Colors.white,
            ),
            label: Text(
              'Add Image',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddImage()));
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseService().getItems(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ImageModel>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData)
              return CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ImageModel img = snapshot.data[index];

                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      Image.network(img.image_url),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.pink,
                          ),
                          Text(
                            img.likes,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          SizedBox(width: 50.0),
                          Icon(
                            Icons.visibility,
                            color: Colors.blue,
                          ),
                          Text(
                            img.views,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () async {
                              try {
                                await FirebaseService().deleteImage(img.id);
                              } catch (e) {
                                print(e);
                              }
                            },
                            color: Colors.red[700],
                            elevation: 7.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              "DELETE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
