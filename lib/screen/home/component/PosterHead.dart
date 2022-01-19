import 'package:flutter/material.dart';

import '../../../ConstantStyle.dart';

class PosterHead extends StatelessWidget {

  Size size ;

  PosterHead({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: CircleAvatar(
            backgroundColor:
            Colors.black.withOpacity(0.5),
            radius: 25.5,
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage:
              AssetImage("assets/images/profile.jpg"),
              backgroundColor: Colors.white,
            ),
          ),
          onTap: () {},
        ),
        Padding(
          padding:
          EdgeInsets.only(left: size.width * 0.02),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Text(
                  "Jeerasak Tirawongsarod",
                  style: TextStyle(
                      color:
                      Colors.black.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),
                ),
                onTap: () {},
              ),
              Text(
                "19 เม.ย. 2021",
                style: TextStyle(
                    color:
                    Colors.black.withOpacity(0.3),
                    fontSize: 10),
              ),
            ],
          ),
        )
      ],
    );
  }
}
