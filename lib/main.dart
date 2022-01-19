import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_book/firebase/MyFirestore.dart';
import 'package:dot_book/screen/home/HomePage.dart';
import 'package:dot_book/screen/login/LoginPage.dart';
import 'package:dot_book/screen/loading/LoadingLoginPage.dart';
import 'package:dot_book/screen/loading/AutoLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ConstantPageName.dart';
import 'ConstantStyle.dart';
import 'model/UserModel.dart';
import 'screen/home/component/PosterHead.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<FirebaseApp> initFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 1), () {});
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
      ),
      home: FutureBuilder(
        future: initFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AutoLoginPage();
          }

          return LoadingLoginPage();
        },
      ),
      routes: {loginPage: (context) => LoginPage()},
    );
  }
}

class MainPage extends StatefulWidget {

  final User user;
  MainPage({@required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MyFirestore().activeOnline(widget.user.uid);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      MyFirestore().activeOnline(widget.user.uid);
    }else{
      MyFirestore().activeOffline(widget.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.93),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: primaryColor,
        selectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friend',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: HomePage(),
    );
  }
}
