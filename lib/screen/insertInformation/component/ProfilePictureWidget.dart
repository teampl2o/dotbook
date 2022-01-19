import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_book/screen/login/component/LoadingComponent.dart';
import 'package:dot_book/screen/signup/component/ShowDialogSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../ConstantStyle.dart';
import '../../Utils.dart';
import 'DialogPictureUpload.dart';
import 'package:intl/intl.dart';

class ProfilePictureWidget extends StatefulWidget {

  final User user;

  ProfilePictureWidget({this.user});

  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  File image;
  final Utils utils = new Utils();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage
      .instance;
  final picker = ImagePicker();
  String profilePicPath;
  bool _isSignUp = false;

  Future<bool> updatePicture(File file) async {
    _isSignUp = true;
    bool success = false;

    String pathStorage = "${widget.user.uid}/profile/pp${widget.user.uid}.png";
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
    _isSignUp = false;
    return success;
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

  Future<ImageSource> _showDialogPictureUpload(Size size) async {
    return await showDialog<ImageSource>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Size size = MediaQuery
            .of(context)
            .size;
        return DialogPictureUpload(
          size: size,
        );
      },
    );
  }

  Future getImage(Size size) async {
    ImageSource imageSource = await _showDialogPictureUpload(size);
    if (imageSource != null) {
      PickedFile pickedFile = await picker.getImage(source: imageSource);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        await updatePicture(image);
      } else {
        print('No image selected.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                      child: Image(
                        image: AssetImage("assets/images/logo.png"),
                        width: 300,
                      )),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "PROFILE INFORMATION",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Color(0xFF019EFA)),
                  ),
                  SizedBox(height: size.height * 0.03),
                  StreamBuilder<DocumentSnapshot>(
                      stream: users.doc(widget.user.uid).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.connectionState ==
                            ConnectionState.active) {
                          Map<String , dynamic> data =snapshot.data.data();
                          return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,
                                  vertical: 20),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 65.0,
                                          backgroundColor: Colors.green,
                                          child: CircleAvatar(
                                            radius: 62.0,
                                            backgroundImage: NetworkImage(data["photo_url"]),
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                        Positioned(
                                          child: GestureDetector(
                                            onTap: () {
                                              getImage(size);
                                            },
                                            child: CircleAvatar(
                                                radius: 25.0,
                                                backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  size: 25,
                                                )),
                                          ),
                                          bottom: 0,
                                          right: 0,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text(
                                      "${data["first_name"]} ${data["last_name"]}",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                  data["about"] != "" ?SizedBox(
                                    height: 10,
                                  ):SizedBox(),
                                  data["about"] != "" ? Center(
                                    child: Text(
                                      data["about"],
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.fade,
                                      maxLines: 5,
                                      softWrap: false,
                                    ),
                                  ) : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Gender : ",
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.3),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      Text(
                                        "${data["gender"]}",
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.6),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Birthday : ",
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.3),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      Text(
                                        "${DateFormat('dd MMM yyyy').format(data["birthday"].toDate())}",
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.6),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ],
                                  )
                                ],
                              ));
                        }
                        return Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primaryColor),
                            ));
                      }
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
    );
  }
}