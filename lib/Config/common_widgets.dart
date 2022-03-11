import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomColors {
  static const Color orange = Color(0xffFF4500);
  static const Color lightOrange = Color(0xFFe9523f);
  static const Color darkOrange = Color(0xffEA1600);
  static const Color appBarColor1 = Color(0xffFF4500);
  static const Color appBarColor = Color(0xffEA1600);
  static const Color peach = Color(0xfffab087);
  static const Color white = Color(0xffffffff);
  static const Color black = Colors.black;
  static const Color darkGrey = Colors.grey;
}

// // ignore: non_constant_identifier_names
// var FIRSTNAME = "";
// // ignore: non_constant_identifier_names
// var LASTNAME = "";
// ignore: non_constant_identifier_names
var ISREF = false;
// // ignore: non_constant_identifier_names
// var USEREMAIL = "";
// // ignore: non_constant_identifier_names
// var USEREMAIL2 = "";
// // ignore: non_constant_identifier_names
// var USERNAME1 = "";
// // ignore: non_constant_identifier_names
// var USERMOBILE = "";
// ignore: non_constant_identifier_names
var MYBALANCE = "";
// ignore: non_constant_identifier_names
var TOTALBIT = "";
// ignore: non_constant_identifier_names
var TOTALIPO = "";
// ignore: non_constant_identifier_names
String TEAMBITID = "";
// // ignore: non_constant_identifier_names
// String USERIMAGE = "";
// // ignore: non_constant_identifier_names
// String KYCSTATUS = "";
const String baseURL = 'https://admin.sherkhanril.com/api/';
Future showToast(message) {
  return Fluttertoast.showToast(
    msg: message.toString(),
    backgroundColor: CustomColors.orange,
    textColor: CustomColors.white,
  );
}
