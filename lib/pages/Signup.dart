import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'Login.dart';

class User{
  String email;
  String password;
  User({this.email,this.password});
}

class Signup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignupState();
  }
}

class SignupState extends State<Signup>{

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
        User u = User(email: emailCtrl.value.text,password: passwordCtrl.value.text);

        print("USER $u");

        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: u.email, password: u.password);
        print("USER ${user}");
        setState(() {
          _autoValid = false;
          loader = false;
        });
        _formKey.currentState.reset();
        showToast(context, "User signup successfully");
      } on PlatformException catch(e){
        print(HandleError(e));
        showToast(context, HandleError(e));
        setState(() {
          loader = false;
        });
      }
    }
  }

  showToast(BuildContext context,String message){
    Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: new Text(message),
        )
    );
  }

  HandleError(e){
    String errorType;
    print("E ${e.message}");
    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = "User not found";
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = "Invalid username passowrd";
          break;
        case 'The email address is already in use by another account.':
          errorType = "User already register";
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = "Time our";
          break;
      // ...
        default:
          print('Case ${e.message} is not jet implemented');
      }
    } else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          errorType = "User not found";
          break;
        case 'Error 17009':
          errorType = "Invalid username password";
          break;
        case 'Error 17020':
          errorType = "Network error";
          break;
      // ...
        default:
          print('Case ${e.message} is not jet implemented');
      }
    }
    return errorType;

  }

  InputDecoration textField({String hintText,String labelText}){
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Builder(
            builder: (context){
              return Stack(
                children: <Widget>[
                  signupForm(context),
                  loader ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : Container()
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
                decoration:textField(
                    hintText: "Email",
                    labelText: "Email"
                ),
                textAlign: TextAlign.center,
                validator: (value){
                  if(value == null || value == '' ){
                    return "Enter email";
                  }
                },
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: passwordCtrl,
                focusNode: password,
                obscureText: true,
                decoration: textField(
                    labelText: "Password",
                    hintText: "Password"
                ),
                onFieldSubmitted: (value){
                  password.unfocus();
                  userSingup(context);
                },
                validator: (value){
                  if(value == null || value == '' ){
                    return "Enter password";
                  }
                },
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.blue,
                child: Container(
                  height: 45.0,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text("Signup",style: TextStyle(color: Colors.white),),
                ),
                onPressed: (){
                  password.unfocus();
                  email.unfocus();
                  userSingup(context) ;
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,bottom: 5.0),
                alignment: Alignment.centerRight,
                child: InkResponse(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                  },
                  child:  Text("Already have an account ? "),
                ),
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