import 'package:flutter/material.dart';

class CustonFlatButton extends StatelessWidget{

  String title;
  GestureTapCallback onPressed;
  CustonFlatButton({@required this.title,@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      color: Colors.blue,
      child: Container(
        height: 45.0,
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(title,style: TextStyle(color: Colors.white),),
      ),
      onPressed: onPressed
    );
  }
}