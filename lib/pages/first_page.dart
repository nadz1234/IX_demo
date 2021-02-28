import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ix_app_demo/pages/home.dart';
import 'package:ix_app_demo/pages/ix_databasePage.dart';
import 'dart:io';
import 'package:universal_platform/universal_platform.dart';

class FirstPage extends StatefulWidget {
  String search;

  FirstPage(this.search);
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

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

  int _currentIndex = 0;
  String searched;

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    connection();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [HomePage(widget.search), IXPage()];

    return new Scaffold(
      key: _scaffKey,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                ),
                title: new Text("API"),
                backgroundColor: Colors.purple),
            BottomNavigationBarItem(
                icon: new Icon(Icons.dashboard),
                title: new Text("IX DB"),
                backgroundColor: Colors.blue),
          ]),
    );
  }
}
