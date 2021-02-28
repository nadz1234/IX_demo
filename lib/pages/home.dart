import 'package:flutter/material.dart';
import 'package:ix_app_demo/pages/imgdetails.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  String search;
  HomePage(this.search);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searched = 'games';

  Future<Map> getimg() async {
    String url =
        'https://pixabay.com/api/?key=20439691-24a2b97c740e7c35ecbb9b0b0&q=$searched&image_type=photo';

    http.Response response = await http.get(url);

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    searched = widget.search;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('IX Image App'),
        backgroundColor: Colors.blue[900],
      ),
      body: new FutureBuilder(
          future: getimg(),
          builder: (context, snapshot) {
            Map data = snapshot.data;

            if (snapshot.hasError) {
              print(snapshot.error);
              return Text(
                'Failed to get response',
                style: TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var tags = '${data['hits'][index]['tags']}';
                    var img = '${data['hits'][index]['largeImageURL']}';
                    var likes = '${data['hits'][index]['likes']}';
                    var views = '${data['hits'][index]['views']}';
                    var downloads = '${data['hits'][index]['downloads']}';

                    return Container(
                      padding: EdgeInsets.all(15.0),
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          children: <Widget>[
                            Image.network(img),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                ),
                                Text(
                                  likes,
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
                                  views,
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImageDetails(
                                                tags,
                                                views,
                                                img,
                                                downloads,
                                                downloads)));
                                  },
                                  color: Colors.purple[700],
                                  elevation: 7.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    "MORE INFO > ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
