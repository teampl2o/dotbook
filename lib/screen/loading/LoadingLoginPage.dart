import 'package:flutter/material.dart';
import '../../ConstantStyle.dart';

class LoadingLoginPage extends StatelessWidget {
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
                SizedBox(height: 20,),
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ],
            ),),
        ],
      ),
      backgroundColor: primaryColor,
    );
  }
}
