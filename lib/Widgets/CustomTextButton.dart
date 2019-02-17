import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget{
  String title;
  GestureTapCallback onTap;

  CustomTextButton({@required this.title,@required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10.0,bottom: 5.0),
      alignment: Alignment.centerRight,
      child: InkResponse(
        onTap: onTap,
        child:  Text(title),
      ),
    );
  }
}
