import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_book/screen/login/component/LoadingComponent.dart';
import 'package:dot_book/screen/signup/component/ShowDialogSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../ConstantStyle.dart';
import '../../main.dart';
import '../Utils.dart';
import 'component/DialogPictureUpload.dart';
import 'component/InformationWidget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart' show rootBundle;

import 'component/ProfilePictureWidget.dart';

class InsertInformationPage extends StatefulWidget {
  final User user;

  InsertInformationPage({@required this.user});

  @override
  _InsertInformationPageState createState() => _InsertInformationPageState();
}

class _InsertInformationPageState extends State<InsertInformationPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage
      .instance;
  final Utils utils = new Utils();
  TextEditingController fnameCtrl = new TextEditingController();
  TextEditingController lnameCtrl = new TextEditingController();
  TextEditingController bdayCtrl = new TextEditingController();
  TextEditingController aboutCtrl = new TextEditingController();
  TextEditingController genderCtrl = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int page = 0;
  File image;
  final Directory systemTempDir = Directory.systemTemp;
  bool _isSignUp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user.displayName != null) {
      fnameCtrl.text = widget.user.displayName.split(" ")[0];
      lnameCtrl.text = widget.user.displayName.split(" ")[1];
    }
  }

  Future<bool> addProfile() async {
    _isSignUp = true;
    bool success = false;
    String path;

    if (genderCtrl.text == "Male") {
      path = 'assets/images/profile_male.png';
    } else {
      path = 'assets/images/profile_female.png';
    }

    final file = await getFile(path, systemTempDir.path);
    String pathStorage = "${widget.user.uid}/profile/pp${widget.user.uid}.png";
    await users
        .doc(widget.user.uid)
        .set({'first_name': fnameCtrl.text,
      'last_name': lnameCtrl.text,
      'birthday': utils.string2Datetime(bdayCtrl.text, "dd MMM yyyy"),
      'gender': genderCtrl.text,
      'about': aboutCtrl.text,
      'uid': widget.user.uid,
      'email': widget.user.email,
      'create_time' : new DateTime.now(),
      'last_online' : new DateTime.now()
    }).then((value) async {
      await storage.ref(pathStorage)
          .putFile(file)
          .then((value) async {
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref(pathStorage)
            .getDownloadURL();
        await users
            .doc(widget.user.uid)
            .update({'photo_url': downloadURL
        }).then((value) async {
          success = true;
        }).catchError((error) {
          _showDialogError("Please try again.");
        });
      }).catchError((error) {
        _showDialogError("Please try again.");
      });
    }).catchError((error) {
      _showDialogError("Please try again.");
    });
    _isSignUp = false;
    return success;
  }

  Future<File> getFile(String filePath, String dirPath) async {
    var byteData;
    byteData = await rootBundle.load(filePath);
    String imageName = filePath.substring(
        filePath.lastIndexOf("/"), filePath.lastIndexOf(".")).replaceAll(
        "/", "");
    final file = File('$dirPath/$imageName.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<void> _showDialogError(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery
            .of(context)
            .size;
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> informationList = [
      InformationWidget(
        formKey: formKey,
        aboutCtrl: aboutCtrl,
        bdayCtrl: bdayCtrl,
        fnameCtrl: fnameCtrl,
        lnameCtrl: lnameCtrl,
        genderCtrl: genderCtrl,
      ),
      ProfilePictureWidget(
          user: widget.user)
    ];
    Size size = MediaQuery
        .of(context)
        .size;
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
          PageView.builder(
            physics: new NeverScrollableScrollPhysics(),
            controller: _controller,
            itemCount: informationList.length,
            itemBuilder: (BuildContext context, int index) {
              return informationList[index % informationList.length];
            },
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              width: size.width,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: size.width * 0.17,
                    height: size.width * 0.17,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.17),
                      child: page == 0
                          ? Container()
                      // ? FlatButton(
                      //     color: Color(0xFFFF6961),
                      //     onPressed: () async {
                      //       FocusScope.of(context).unfocus();
                      //       await FirebaseAuth.instance.signOut();
                      //       Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => LoginPage()));
                      //     },
                      //     child: Center(
                      //         child: Text(
                      //       "Logout",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: size.width * 0.025),
                      //     )))
                          : FlatButton(
                          color: Color(0xFF019EF3),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _controller.previousPage(
                                duration: _kDuration, curve: _kCurve);
                            setState(() {
                              page = 0;
                            });
                          },
                          child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ))),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: size.width * 0.17,
                    height: size.width * 0.17,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.17),
                      child: page == 0
                          ? FlatButton(
                          color: Color(0xFF019EF3),
                          onPressed: () async {
                            bool informationComplete =
                            formKey.currentState.validate();
                            FocusScope.of(context).unfocus();
                            if (informationComplete) {
                              if (await addProfile()) {
                                _controller.nextPage(
                                    duration: _kDuration, curve: _kCurve);
                                setState(() {
                                  page = 1;
                                });
                              }
                            }
                          },
                          child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                              )))
                          : FlatButton(
                          color: Color(0xFF7ABD7E),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(user: widget.user,)));
                          },
                          child: Center(
                              child: Text(
                                "Finish",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.025),
                              ))),
                    ),
                  ),
                ],
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

