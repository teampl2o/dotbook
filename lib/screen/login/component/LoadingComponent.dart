import 'package:flutter/material.dart';
import '../../../ConstantStyle.dart';

class LoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white.withOpacity(0.45),
      child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
          )),
    );
  }
}
