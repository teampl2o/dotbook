import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication{

  Future<UserCredential> emailPassLogin(TextEditingController email , TextEditingController password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text,
          password: password.text);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

}