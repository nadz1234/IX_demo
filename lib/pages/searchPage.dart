import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_platform/universal_platform.dart';

import 'dart:async';

import 'package:ix_app_demo/pages/first_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var connectivityResult;

  connection() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
    } else {
      showAlertDialogConnect();
    }
  }

  void showAlertDialogConnect() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Connectivity'),
            content: new Text('Please check your connectivity'),
            actions: <Widget>[
              Row(children: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: new Text('Ok')),
              ]),
            ],
          );
        });
  }

  bool isIos = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;

  @override
  void initState() {
    super.initState();

    if (!isWeb) {
      connection();

      var androidInitialize = AndroidInitializationSettings('ic_launcher');
      var ioSInitialize = IOSInitializationSettings();
      var initSetttings =
          InitializationSettings(androidInitialize, ioSInitialize);

      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initSetttings);
    }
  }

  Future showNotification() async {
    if (!isWeb) {
      var android = AndroidNotificationDetails(
          'id', 'IX Notification ', 'Searching for something using the API',
          importance: Importance.High);
      var iOS = IOSNotificationDetails();
      var generalNotDetails = new NotificationDetails(android, iOS);
      await flutterLocalNotificationsPlugin.show(0, 'IX notification',
          'you have searched for $search .. ', generalNotDetails);
    }
  }

  String search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      key: _scaffKey,
      appBar: AppBar(
        title: Text('IX image app'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          Image.asset(
            'images/ix.png',
            width: 500,
            height: 170.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "WELCOME TO THE IX IMAGE APP, PLEASE ENTER SOMETHING IN THE SEARCH BOX",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ),
          Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: "Enter something to search..",
                          filled: true,
                          fillColor: Colors.grey[200]),
                      validator: (val) =>
                          val.isEmpty ? 'Cannot be left empty' : null,
                      onChanged: (val) {
                        setState(() {
                          search = val.trim();
                        });
                      },
                    ),
                    padding: EdgeInsets.all(32),
                  ),
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          setState(() {});
                          showNotification();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FirstPage(search)));
                        }
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
                            "Search!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
