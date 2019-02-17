import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'Login.dart';
import 'Home.dart';
import '../Widgets/Loader.dart';
import '../Modal/User.dart';
import '../Modal/Authenication.dart';
import '../Theme/CustomStyle.dart';
import '../Widgets/CustomFlatButton.dart';
import '../Widgets/CustomTextButton.dart';
import '../Modal/Validation.dart';


class Signup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignupState();
  }
}

class SignupState extends State<Signup>{
  Authentication _authentication;
  final _formKey = GlobalKey<FormState>();
  bool _autoValid = false;

  FocusNode email;
  FocusNode password;

  TextEditingController emailCtrl;
  TextEditingController passwordCtrl;
  bool loader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authentication = Authentication();
    email = FocusNode();
    password = FocusNode();

    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();

  }

  userSingup(BuildContext context)async{
    setState(() {
      _autoValid = true;
    });
    if(_formKey.currentState.validate()){
      try{
        setState(() {
          loader = true;
        });
        FirebaseUser user = await _authentication.SignupUser(user:  User(email: emailCtrl.value.text,password: passwordCtrl.value.text));

        setState(() {
          _autoValid = false;
          loader = false;
        });
        _formKey.currentState.reset();

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(user: user,)));
        _authentication.ShowToast(context, "User signup successfully");

      } on PlatformException catch(e){

        _authentication.ShowToast(context, _authentication.HandleError(e));
        setState(() {
          loader = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Builder(
            builder: (context){
              return Stack(
                children: <Widget>[
                  signupForm(context),
                  loader ? Loader() : Container()
                ],
              );
            }
        )
    );
  }

  Widget signupForm(BuildContext context){
    return Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          autovalidate: _autoValid,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Signup",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w500),),
              SizedBox(height:10.0),
              TextFormField(
                controller: emailCtrl,
                focusNode: email,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (value){
                  email.unfocus();
                  FocusScope.of(context).requestFocus(password);
                },
                decoration:TextFieldDecoration(
                    hintText: "Email",
                    labelText: "Email"
                ),
                validator: (value) => checkFieldValidation(value,'Email','email'),
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: passwordCtrl,
                focusNode: password,
                obscureText: true,
                decoration: TextFieldDecoration(
                    labelText: "Password",
                    hintText: "Password"
                ),
                onFieldSubmitted: (value){
                  password.unfocus();
                  userSingup(context);
                },
                validator: (value) => checkFieldValidation(value,'Passowrd','password'),
              ),
              SizedBox(height: 10.0,),
              CustonFlatButton(
                title: "Signup",
                onPressed: (){
                  password.unfocus();
                  email.unfocus();
                  userSingup(context) ;
                },
              ),
              CustomTextButton(
                title:"Already have an account ? ",
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                },
              )
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email?.dispose();
    password?.dispose();
    emailCtrl?.dispose();
    passwordCtrl?.dispose();
  }
}