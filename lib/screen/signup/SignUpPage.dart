import 'package:dot_book/screen/Utils.dart';
import 'package:dot_book/screen/login/component/AlreadyHaveAnAccountCheck.dart';
import 'package:dot_book/screen/login/component/LoadingComponent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ConstantStyle.dart';
import 'component/ShowDialogSignUp.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  TextEditingController confirmPasswordCtrl = new TextEditingController();
  Utils utils = new Utils();
  bool _obscurePass1 = true;
  bool _obscurePass2 = true;
  bool _isSignUp = false ;

  Future<void> register() async {
    if (passwordCtrl.text == passwordCtrl.text && passwordCtrl.text.length >= 8 && confirmPasswordCtrl.text.length >= 8)
      setState(() {
        _isSignUp = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailCtrl.text, password: passwordCtrl.text);
        User user = FirebaseAuth.instance.currentUser;
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        _isSignUp = false;
        _showDialogSuccess(
            "You have successfully Sign up.\nPlease go to Login.");
      } on FirebaseAuthException catch (e) {
        _isSignUp = false;
        if (e.code == 'weak-password') {
          _showDialogError('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showDialogError('The account already exists for that email.');
        }else if(e.code == 'invalid-email'){
          _showDialogError('The email is invalid email.');
        }
        print("FirebaseAuthException : ${e.code}");
      } catch (e) {
        print(e);
      }
  }

  Future<void> _showDialogError(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return ShowDialogSignUp(
          size: size,
          condition: false,
          content: content,
          func: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _showDialogSuccess(String content) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return ShowDialogSignUp(
          size: size,
          condition: true,
          content: content,
          func: () {
            Navigator.pop(context);
          },
        );
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(250)),
                color: Color(0xFFF8ECBD)),
          )),
          Positioned(
              bottom: 0,
              right: 1,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(100)),
                    color: Color(0xFFFFDDDD)),
              )),
          Positioned(
              bottom: size.height / 2,
              left: size.width / 2,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFFB9D9CF)),
              )),
          Positioned(
              top: size.height / 1.5,
              right: size.width / 1.2,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Color(0xFFD1DFB7)),
              )),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Image(
                      image: AssetImage("assets/images/logo.png"),
                      width: 300,
                    )),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Color(0xFF019EFA)),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (input) {
                                if (input.isEmpty)
                                  return "Please enter your email.";

                                if (utils.validateEmail(input))
                                  return "Please enter your valid email.";

                                return null;
                              },
                              controller: emailCtrl,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: primaryColor,
                                ),
                                hintText: "Your Email",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.isEmpty)
                                    return "Please enter your password.";
                                  if (input.length < 8)
                                    return "Password not less than 8 characters";

                                  return null;
                                },
                                controller: passwordCtrl,
                                obscureText: _obscurePass1,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  icon: Icon(
                                    Icons.lock,
                                    color: primaryColor,
                                  ),
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      Icons.visibility,
                                      color: primaryColor,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _obscurePass1 = !_obscurePass1;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                validator: (input) {
                                  if (input.isEmpty)
                                    return "Please enter your confirm password.";

                                  if(input != passwordCtrl.text && passwordCtrl.text.isNotEmpty)
                                  return  "Password do not match.";

                                  return null;
                                },
                                controller: confirmPasswordCtrl,
                                obscureText: _obscurePass2,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  icon: Icon(
                                    Icons.lock,
                                    color: primaryColor,
                                  ),
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      Icons.visibility,
                                      color: primaryColor,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _obscurePass2 = !_obscurePass2;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: size.width * 0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(29),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                                color: Color(0xFF019EF3),
                                onPressed: () {
                                  bool enterComplete =
                                  _formKey.currentState.validate();
                                  if (enterComplete) {
                                    register();
                                  }

                                },
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.pop(context);
                      },
                      login: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _isSignUp
              ? LoadingComponent()
              : Container(),
        ],
      ),
      backgroundColor: primaryColor,
    );
  }
}
