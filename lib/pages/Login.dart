import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'Home.dart';
import 'Signup.dart';
import '../Widgets/Loader.dart';
import '../Modal/Authenication.dart';
import '../Modal/User.dart';
import '../Theme/CustomStyle.dart';
import '../Widgets/CustomFlatButton.dart';
import '../Widgets/CustomTextButton.dart';
import '../Modal/Validation.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login>{

  FocusNode email,passowrd;
  TextEditingController emailCtrl,passwordCtrl;
  bool _autovalid = false;
  final _formKey = GlobalKey<FormState>();
  bool loader = false;

  Authentication _authentication;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authentication = Authentication();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    email = FocusNode();
    passowrd = FocusNode();

  }


  userLogin(BuildContext context)async{
    setState(() {
      _autovalid = true;
    });
    if(_formKey.currentState.validate()){
      try{
        setState(() {
          loader = true;
        });
        FirebaseUser user = await _authentication.LoginUser(user: User(email: emailCtrl.value.text,password: passwordCtrl.value.text));
        setState(() {
          loader = false;
        });
        _authentication.ShowToast(context, "Login successful");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context)=>Home(user: user)),
            ModalRoute.withName("/root")
        );

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
        body: Stack(
          children: <Widget>[
            loginForm(context),
            LoadingWidget(loader)
          ],
        )
    );
  }

  Widget LoadingWidget(bool flag){
    if(flag){
      return Loader();
    }else{
      return Container();
    }
  }

  Widget loginForm(BuildContext context){
    return Builder(
      builder: (context){
        return Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              autovalidate: _autovalid,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Login",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w500),),
                  SizedBox(height:10.0),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: TextFieldDecoration(
                        hintText: "Email",
                        labelText: "Email"
                    ),
                    controller: emailCtrl,
                    focusNode: email,
                    validator: (value) => checkFieldValidation(
                      val: value,
                      fieldName: "Email",
                      fieldType: VALIDATION_TYPE.EMAIL
                    ),
                    onFieldSubmitted: (value){
                      email.unfocus();
                      FocusScope.of(context).requestFocus(passowrd);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: TextFieldDecoration(
                        hintText: "Password",
                        labelText: "Password"
                    ),
                    controller: passwordCtrl,
                    focusNode: passowrd,
                    validator: (value) => checkFieldValidation(
                        val: value,
                        fieldName: "Password",
                        fieldType: VALIDATION_TYPE.PASSWORD
                    ),
                    onFieldSubmitted: (value){
                      passowrd.unfocus();
                      userLogin(context);
                    },
                  ),
                  SizedBox(height: 10.0,),
                  CustonFlatButton(
                    title: "Login",
                    onPressed: (){
                      email.unfocus();
                      passowrd.unfocus();
                      userLogin(context);
                    },
                  ),
                  CustomTextButton(
                    title:"Create new account",
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signup()));
                    },
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
