import 'package:dot_book/firebase/MyFirestore.dart';
import 'package:dot_book/screen/login/LoginPage.dart';
import 'package:dot_book/screen/signup/component/ShowDialogSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../ConstantStyle.dart';
import '../../main.dart';

class AutoLoginPage extends StatefulWidget {
  @override
  _AutoLoginPageState createState() => _AutoLoginPageState();
}

class _AutoLoginPageState extends State<AutoLoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signInWithGoogle();
  }

  Future<void> signInWithGoogle() async {
    User user = await FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      await MyFirestore().registerInformation(user, context);
      // try {
      //   final GoogleSignInAccount googleUser =
      //       await GoogleSignIn().signInSilently();
      //
      //   final GoogleSignInAuthentication googleAuth =
      //       await googleUser.authentication;
      //
      //   final _credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth.accessToken,
      //     idToken: googleAuth.idToken,
      //   );
      //   UserCredential userCredential =
      //       await FirebaseAuth.instance.signInWithCredential(_credential);
      //   await MyFirestore().registerInformation(userCredential.user, context);
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == "user-disabled") {
      //     await GoogleSignIn().signOut();
      //   }
      //   await _showDialogError(e.message);
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => LoginPage()));
      // }
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 300,
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: primaryColor,
    );
  }
}
