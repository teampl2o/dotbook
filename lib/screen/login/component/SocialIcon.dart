import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  String iconSrc;
  Function func;
  SocialIcon({this.iconSrc , this.func});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          shape: BoxShape.circle,
        ),
        child: Image(
          image:
          AssetImage(iconSrc),
          width: 30,
        ),
      ),
    );
  }
}
