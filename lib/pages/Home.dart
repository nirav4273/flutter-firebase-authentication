import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'Login.dart';

class Home extends StatefulWidget{

  FirebaseUser user;
  Home({this.user});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home>{

  logout()async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (Route<dynamic> route)=>  route.isFirst);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          InkResponse(
            onTap:logout,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.power_settings_new),
            ),
          )
        ],
      ),
      body: Center(
        child: Text("Home ${widget.user?.email}"),
      ),
    );
  }
}
