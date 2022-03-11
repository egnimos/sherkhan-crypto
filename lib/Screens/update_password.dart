import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/Screens/onBoardingNavBar.dart';

class UpdatePassword extends StatefulWidget {
  final String username;
  const UpdatePassword({Key? key, required this.username}) : super(key: key);
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _pswdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: CustomColors.appBarColor,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/shekhan logo.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Update Password',
                      style: TextStyle(
                        color: CustomColors.darkOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _pswdController,
                        labelText: 'Password',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        obsecureText: true,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'Please Enter Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
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
                              child: isUpdating
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
                                if (_formKey.currentState!.validate()) {
                                  if (mounted) {
                                    setState(() {
                                      isUpdating = true;
                                    });
                                  }
                                  await updatePassword();
                                  if (mounted) {
                                    setState(() {
                                      isUpdating = false;
                                    });
                                  }
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
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updatePassword() async {
    final header = {
      'Content-Type': 'application/json',
    };
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://admin.sherkhanril.com/api/password/update'));
      request.fields.addAll({
        'secret': 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        'username': widget.username,
        'password': _pswdController.text.toString(),
      });
      request.headers.addAll(header);

      var response = await request.send();

      if (response.statusCode == 200) {
        final model = await response.stream.bytesToString();
        final fnh = jsonDecode(model);
        if (fnh['status'] == 'success') {
          showToast(fnh["msg"].toString());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OnBoardingNavBar(),
              ),
              (route) => false);
        } else {
          showToast(fnh["msg"].toString());
        }
      }
    } catch (error) {
      showToast(error.toString());
    }
  }
}
