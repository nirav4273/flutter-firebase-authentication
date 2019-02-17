import 'package:flutter/material.dart';

InputDecoration TextFieldDecoration({String hintText,String labelText}){
  return InputDecoration(
      hintText: hintText,
      labelText: labelText,
//        errorStyle: TextStyle(
//          color: Colors.red,
//          wordSpacing: 5.0,
//        ),
//        labelStyle: TextStyle(
//          color: Colors.green,
//            letterSpacing: 1.3
//        ),
      hintStyle: TextStyle(
          letterSpacing: 1.3
      ),
      contentPadding: EdgeInsets.all(13.0), // Inside box padding
      border: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(1.5)
      )
  );
}