import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'Home.dart';
import 'Signup.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    email = FocusNode();
    passowrd = FocusNode();

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

  userLogin(BuildContext context)async{

    setState(() {
      _autovalid = true;
    });
    if(_formKey.currentState.validate()){
      try{
        setState(() {
          loader = true;
        });
        User u = User(email: emailCtrl.value.text,password: passwordCtrl.value.text);

        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: u.email, password: u.password);
        setState(() {
          loader = false;
        });
        showToast(context, "Login successful");
        Route route = MaterialPageRoute(builder: (context) => Home(user: user));
        Navigator.pushReplacement(context, route);

      } on PlatformException catch(e){
        showToast(context, HandleError(e));
        setState(() {
          loader = false;
        });
      }
    }
  }

  InputDecoration textField({String hintText,String labelText}){
    return InputDecoration(
        hintText: hintText,
        labelText: labelText,
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
      return Container(
        color: Colors.black26,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
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
                    decoration: textField(
                        hintText: "Email",
                        labelText: "Email"
                    ),
                    controller: emailCtrl,
                    focusNode: email,
                    validator: (value){
                      if(value == null || value == ''){
                        return "Enter email";
                      }
                    },
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
                    decoration: textField(
                        hintText: "Password",
                        labelText: "Password"
                    ),
                    controller: passwordCtrl,
                    focusNode: passowrd,
                    validator: (value){
                      if(value == null || value == ''){
                        return "Enter password";
                      }
                    },
                    onFieldSubmitted: (value){
                      passowrd.unfocus();
                      userLogin(context);
                    },
                  ),
                  SizedBox(height: 10.0,),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: (){
                      email.unfocus();
                      passowrd.unfocus();
                      userLogin(context);
                    },
                    child: Container(
                      height: 40.0,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("Login",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,bottom: 5.0),
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signup()));
                      },
                      child:  Text("Create new account"),
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }
}

class User{
  String email;
  String password;
  User({this.email,this.password});
}

