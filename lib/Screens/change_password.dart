import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:test_project/Config/validations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formValid = GlobalKey<FormState>();
  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  bool passwordVisible = true;
  bool newPasswordVisible = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('Change Password'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formValid,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    AllInputDesign(
                      controller: _currentPass,
                      labelText: 'Current Password',
                      obsecureText: passwordVisible,
                      fillColor: CustomColors.white,
                      contentPadding: const EdgeInsets.all(5.0),
                      validator: validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    AllInputDesign(
                      controller: _newPass,
                      obsecureText: newPasswordVisible,
                      labelText: 'New Password',
                      fillColor: CustomColors.white,
                      contentPadding: const EdgeInsets.all(5.0),
                      validator: validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          newPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            newPasswordVisible = !newPasswordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 45),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: <Color>[
                            const Color(0xffEA1600).withOpacity(0.7),
                            const Color(0xffEA1600),
                          ],
                        ),
                      ),
                      child: TextButton(
                        child: isLoading
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: CustomColors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'Submit',
                                style: TextStyle(
                                  color: CustomColors.white,
                                ),
                              ),
                        onPressed: () async {
                          if (_formValid.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await updateMyProfile();
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                            color: CustomColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateMyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://admin.sherkhanril.com/api/change-password'),
      );
      request.fields.addAll({
        'secret': 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        'current_password': _currentPass.text,
        'password': _newPass.text,
      });
      request.headers.addAll(header);

      var response = await request.send();

      if (response.statusCode == 200) {
        var model = await response.stream.bytesToString();
        // print('00000 $model');
        var fnh = jsonDecode(model);
        if (fnh == 'success') {
          showToast(fnh["msg"].toString());
        } else {
          showToast(fnh["msg"].toString());
        }
      }
    } catch (error) {
      showToast(error.toString());
    }
  }
}
