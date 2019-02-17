import 'package:flutter/material.dart';

class Loader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.black26,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}