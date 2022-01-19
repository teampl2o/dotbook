import 'package:flutter/material.dart';

class ShowDialogSignUp extends StatelessWidget {
  final Size size ;
  final String content;
  final bool condition ;
  final Function func ;
  ShowDialogSignUp({this.size,this.content,this.condition,this.func});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(),),
        Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width *0.05)
            ),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                    child: Column(
                      children: [
                        Text(condition ? "Success":'Warning !!!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.black.withOpacity(0.7)),),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(child: Text(content,textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.7)),)),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          width: size.width * 0.3,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              color: condition ? Color(0xFF84DE66) :Color(0xFFFF6961),
                              onPressed: func,
                              child: Text(
                                condition ? "Okay" : "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: condition ? Color(0xFF84DE66) :Color(0xFFFF6961) ,
                      radius: 50,
                      child: Icon( condition ? Icons.done : Icons.error, color: Colors.white, size: 50,),
                    )
                ),
              ],
            )
        ),
        Expanded(child: Container(),),
      ],
    );
  }
}
