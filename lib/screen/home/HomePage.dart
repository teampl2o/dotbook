import 'package:dot_book/screen/home/component/PosterHead.dart';
import 'package:dot_book/screen/login/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../ConstantStyle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    color: primaryColor,
                    height: size.height * 0.18,
                    padding: EdgeInsets.only(
                      right: 20,
                      left: 20,
                    ),
                    // decoration: BoxDecoration(
                    //     color: primaryColor,
                    //     borderRadius: BorderRadius.only(
                    //       bottomLeft: Radius.circular(size.height * 0.05),
                    //       bottomRight: Radius.circular(size.height * 0.05),
                    //     )),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage("assets/images/logo.png"),
                                width: 150,
                              ),
                              Spacer(),
                              GestureDetector(
                                child: Icon(
                                  Icons.logout,
                                  color: Color(0xFFFF8D7B),
                                ),
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 43.0,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage:
                                      AssetImage("assets/images/profile.jpg"),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              onTap: () {},
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Flexible(
                              child: Text(
                                "Jeerasak Tirawongsarod",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Stack(
              children: [
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 45),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          // borderRadius:
                          //     BorderRadius.circular(size.height * 0.01),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            PosterHead(size: size),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 100,
                ),
                Container(
                  height: size.height * 0.03,
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.height * 0.2),
                        bottomRight: Radius.circular(size.height * 0.2),
                      )),
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Container(
                      height: size.height * 0.05,
                      margin: EdgeInsets.symmetric(horizontal: 36),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.04),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 5),
                                blurRadius: 80,
                                color: Colors.black.withOpacity(0.10))
                          ]),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.add_comment,
                              color: primaryColor.withOpacity(0.5),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 15),
                              child: TextField(
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.75)),
                                  decoration: InputDecoration(
                                    hintText: "Post It...",
                                    hintStyle: TextStyle(
                                        color: primaryColor.withOpacity(0.5)),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  autofocus: false,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  showCursor: true,
                                  readOnly: true),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
