import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Config/common_widgets.dart';
import '../Screens/bit_deposit.dart';
import '../models/user.dart';

class UserService with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void updateValue(User userInfo) {
    _user = userInfo;
    notifyListeners();
  }

  //get the user
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final auth = prefs.getString('authToken');
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          baseURL + 'myprofile?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      final jsonBody = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonBody["status"] == 'fail') {
          showToast(jsonBody["msg"].toString());
        } else {
          //get the current user
          _user = User.fromJson(jsonBody);
        }
      }
      notifyListeners();
    } catch (error) {
      showToast(error.toString());
    }
  }

  //update the user
  Future<void> updateUser(BuildContext context, User userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final auth = prefs.getString('authToken');
    final headers = {'Authorization': 'Bearer $auth'};
    try {
      final response = await http.post(
        Uri.parse('https://admin.sherkhanril.com/api/profile-setting'),
        headers: headers,
        body: userInfo.toJson(),
      );

      final jsonBody = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonBody['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isKYC', true);
          showToast(jsonBody["msg"].toString());
          _user = userInfo;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BitDeposit(from: 'register'),
              ),
              (route) => false);
        } else {
          showToast(jsonBody["msg"].toString());
        }
      }
      notifyListeners();
    } catch (error) {
      showToast(error.toString());
    }
  }
}
