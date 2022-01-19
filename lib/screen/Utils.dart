
import 'package:intl/intl.dart';

class Utils{
  bool validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return true;
    else
      return false;
  }

  bool wordOnly(String value) {
    Pattern pattern =
        r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return false;
    else
      return true;
  }

  String datetime2String(DateTime dateTime , String format){
    var formatter = new DateFormat(format);
    return formatter.format(dateTime);
  }

  DateTime string2Datetime(String dateTime , String format){
    return new DateFormat(format).parse(dateTime);
  }
}