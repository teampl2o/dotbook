import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_book/screen/insertInformation/InsertInformationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyFirestore{

  CollectionReference firestoreUsers =
  FirebaseFirestore.instance.collection("users");

  Future<void> registerInformation(User user, BuildContext context)async {
    if(await getUser(user.uid)){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => InsertInformationPage(user: user,)));
    }else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MainPage(user: user,)));
    }
  }

  Future<bool> getUser(String uid) async {
    DocumentSnapshot user = await firestoreUsers.doc(uid).get();
    return user.data() == null;
  }

  Future<void> activeOnline(String uid) async {
    await firestoreUsers.doc(uid)
        .update({
      'online': true
    });
  }

  Future<void> activeOffline(String uid) async {
    await firestoreUsers.doc(uid)
        .update({
      'online': false,
      'last_online' : new DateTime.now()
    });

  }

}