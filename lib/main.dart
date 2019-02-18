import 'package:flutter/material.dart';
import 'pages/Login.dart';
import 'pages/Home.dart';
import 'pages/Root.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Root(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/root': (context) => Root()
      },
    );
  }
}
