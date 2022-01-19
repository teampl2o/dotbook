import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DialogPictureUpload extends StatelessWidget {
  final Size size ;
  final Function func ;
  DialogPictureUpload({this.size,this.func});
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
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: Column(
                      children: [
                        Text("Upload Profile Picture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.black.withOpacity(0.7)),),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: size.width * 0.17,
                                  height: size.width * 0.17,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(size.width * 0.17),
                                    child: FlatButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.pop(context,ImageSource.camera);
                                        },
                                        child: Center(
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.grey,
                                            ))),
                                  ),
                                ),
                                Center(child: Text("Camera" , style: TextStyle(color: Colors.grey,fontSize: 12),))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: size.width * 0.17,
                                  height: size.width * 0.17,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(size.width * 0.17),
                                    child: FlatButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.pop(context,ImageSource.gallery);
                                        },
                                        child: Center(
                                            child: Icon(
                                              Icons.drive_file_move,
                                              color: Colors.grey,
                                            ))),
                                  ),
                                ),
                                Center(child: Text("Gallery" , style: TextStyle(color: Colors.grey,fontSize: 12),))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: size.width * 0.3,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              color: Color(0xFFFF6961),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
        Expanded(child: Container(),),
      ],
    );
  }
}
