
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_book/firebase/MyFirestore.dart';
import 'package:dot_book/screen/Utils.dart';
import 'package:dot_book/screen/insertInformation/InsertInformationPage.dart';
import 'package:dot_book/screen/login/component/AlreadyHaveAnAccountCheck.dart';
import 'package:dot_book/screen/signup/SignUpPage.dart';
import 'package:dot_book/screen/signup/component/ShowDialogSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../ConstantStyle.dart';
import '../../main.dart';
import 'component/LoadingComponent.dart';
import 'component/SocialIcon.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final Utils utils = new Utils();
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isAuth = false;

  Future<void> _emailLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailCtrl.text, password: passwordCtrl.text);
      User user = FirebaseAuth.instance.currentUser;
      _isAuth = false;
      if (!user.emailVerified) {
        _showDialogError('Confirm your email address.Please verify your email for Login.');
      }else{
        await MyFirestore().registerInformation(userCredential.user,context);
      }
    } on FirebaseAuthException catch (e) {
      _isAuth = false;
      if (e.code == 'user-not-found') {
        _showDialogError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showDialogError('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _isAuth = true;
    });
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final _credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(_credential);
      await MyFirestore().registerInformation(userCredential.user,context);
    }on FirebaseAuthException catch (e) {
      if(e.code == "user-disabled"){
        await GoogleSignIn().signOut();
      }
      await _showDialogError(e.message);
      setState(() {
        _isAuth = false;
      });
    }on NoSuchMethodError catch (e) {
      setState(() {
        _isAuth = false;
      });
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
                      "LOGIN",
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
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
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
                                    return "Please enter your Password.";

                                  if (input.length < 8)
                                    return "Password not less than 8 characters";

                                  return null;
                                },
                                obscureText: _obscureText,
                                controller: passwordCtrl,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
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
                                        _obscureText = !_obscureText;
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
                                  if (enterComplete && passwordCtrl.text.length >= 8) {
                                    setState(() {
                                      _isAuth = true;
                                    });
                                    _emailLogin();
                                  }
                                },
                                child: Text(
                                  "LOGIN",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpPage();
                            },
                          ),
                        );
                      },
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      width: size.width * 0.8,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocialIcon(
                          func: signInWithGoogle,
                          iconSrc: "assets/images/google-plus.png",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          _isAuth
              ? LoadingComponent()
              : Container(),
        ],
      ),
      backgroundColor: primaryColor,
    );
  }
}
