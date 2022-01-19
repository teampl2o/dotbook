import 'package:flutter/material.dart';

import '../../../ConstantStyle.dart';
import '../../Utils.dart';

class InformationWidget extends StatefulWidget {
  final GlobalKey formKey;
  final TextEditingController fnameCtrl;
  final TextEditingController lnameCtrl;
  final TextEditingController bdayCtrl;
  final TextEditingController aboutCtrl;
  final TextEditingController genderCtrl;

  InformationWidget(
      {@required this.formKey,
      this.fnameCtrl,
      this.lnameCtrl,
      this.bdayCtrl,
      this.aboutCtrl,
      this.genderCtrl});

  @override
  _InformationWidgetState createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  DateTime selectedDate = DateTime.now();
  final Utils utils = new Utils();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        widget.bdayCtrl.text = utils.datetime2String(picked, 'dd MMM yyyy');
      });
  }

  Future<void> _showDialogGender() async {
    String gender = await showDialog<String>(
      context: context, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Choose your gender",style: TextStyle(color: Colors.black.withOpacity(0.8)),),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new SimpleDialogOption(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/male.png"),
                          color: primaryColor,
                        ),
                        SizedBox(width: 5,),
                        Text('Male'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context, "Male");
                    },
                  ),
                  new SimpleDialogOption(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/female.png"),
                          color: primaryColor,
                        ),
                        SizedBox(width: 5,),
                        Text('Female'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context, "Female");
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    setState(() {
      widget.genderCtrl.text = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
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
                "INFORMATION",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color(0xFF019EFA)),
              ),
              SizedBox(height: size.height * 0.03),
              Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (input) {
                          if (input.isEmpty)
                            return "Please enter your first name.";

                          if (utils.wordOnly(input))
                            return "Please enter your valid first name.";

                          return null;
                        },
                        controller: widget.fnameCtrl,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.assignment_ind,
                            color: primaryColor,
                          ),
                          labelText: "First name",
                          labelStyle:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.3)),
                          hintText: "First name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Please enter your last name.";

                            if (utils.wordOnly(input))
                              return "Please enter your valid last name.";

                            return null;
                          },
                          controller: widget.lnameCtrl,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.3)),
                            labelText: "Last name",
                            hintText: "Last name",
                            icon: Icon(
                              Icons.assignment_ind,
                              color: primaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty)
                              return "Please enter your gender.";

                            return null;
                          },
                          readOnly: true,
                          controller: widget.genderCtrl,
                          cursorColor: primaryColor,
                          onTap: () => _showDialogGender(),
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.3)),
                            labelText: "Gender",
                            hintText: "Gender",
                            icon: ImageIcon(
                              AssetImage("assets/images/gender.png"),
                              color: primaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          validator: (input) {
                            if (input.isEmpty)
                              return "Please enter your birthday.";

                            return null;
                          },
                          readOnly: true,
                          controller: widget.bdayCtrl,
                          cursorColor: primaryColor,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.3)),
                            labelText: "Birthday",
                            hintText: "Birthday",
                            icon: Icon(
                              Icons.date_range,
                              color: primaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          validator: (input) {
                            return null;
                          },
                          maxLines: 3,
                          controller: widget.aboutCtrl,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.3)),
                            labelText: "About with you",
                            hintText: "About with you",
                            icon: Icon(
                              Icons.assignment_outlined,
                              color: primaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
