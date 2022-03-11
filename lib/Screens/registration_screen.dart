import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:test_project/Config/validations.dart';
import 'package:test_project/Screens/kyc_detail.dart';
import 'package:test_project/Services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool isLoading = false;
  bool isChecked = false;
  bool _isCheck = false;

  @override
  void didChangeDependencies() {
    if (ISREF && mounted) {
      final user = Provider.of<UserService>(context, listen: false).user;
      setState(() {
        _referalController.text = user?.userName ?? "";
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _referalController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      const Text(
                        'Registration',
                        style: TextStyle(
                          color: CustomColors.darkOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 40),
                      AllInputDesign(
                        controller: _firstNameController,
                        labelText: 'First Name',
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: validateName,
                      ),
                      const SizedBox(height: 18),
                      AllInputDesign(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: validateLastName,
                      ),
                      const SizedBox(height: 18),
                      AllInputDesign(
                        controller: _mobileController,
                        labelText: 'Mobile Number',
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: validateMobile,
                      ),
                      const SizedBox(height: 18),
                      AllInputDesign(
                        controller: _referalController,
                        labelText: 'Reference',
                        fillColor: CustomColors.white,
                        autoValidate: true,
                        onChanged: (String val) {
                          checkReferal();
                        },
                        suffixIcon: isChecked
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const SizedBox.shrink(),
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (val) {
                          if (isChecked) {
                            return null;
                          } else {
                            return 'Invalid referal';
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      AllInputDesign(
                        controller: _emailController,
                        labelText: 'Email',
                        keyBoardType: TextInputType.emailAddress,
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 18),
                      AllInputDesign(
                        controller: _userIdController,
                        labelText: 'Create User Name',
                        keyBoardType: TextInputType.emailAddress,
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 15),
                      AllInputDesign(
                        controller: _passwordController,
                        labelText: 'Password',
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        obsecureText: passwordVisible,
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
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Checkbox(
                              value: _isCheck,
                              onChanged: (val) {
                                setState(() {
                                  _isCheck = val!;
                                });
                              }),
                          RichText(
                            text: TextSpan(
                                text: 'Please accept ',
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => tnc(),
                                  )
                                ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
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
                                child: isLoading
                                    ? const SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          color: CustomColors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: CustomColors.white,
                                        ),
                                      ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (mounted) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                    if (isChecked) {
                                      if (_isCheck) {
                                        signUp();
                                      }
                                    } else {
                                      showToast(
                                          'Please add valid referral code');
                                    }
                                    if (mounted) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
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
      ),
    );
  }

  Future<void> tnc() async {
    try {
      if (!await launch(
        'https://admin.sherkhanril.com/terms-conditions',
        forceSafariVC: true,
        forceWebView: true,
        enableDomStorage: true,
      )) {
        throw 'Could not launch ';
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> signUp() async {
    final bodyReq = {
      'secret': 'bd5c49f2-a-44d4-8daa-6ff67ab1bc14',
      'referral': _referalController.text,
      'email': _emailController.text,
      'username': _userIdController.text,
      'password': _passwordController.text,
      'mobile': _mobileController.text,
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text
    };
    try {
      final response = await http.post(
        Uri.parse(baseURL + 'register'),
        body: bodyReq,
      );
      final model = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('authToken', model['access_token']);
          prefs.setBool('isLogin', true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const KycDetail(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> checkReferal() async {
    final bodyReq = {
      'secret': 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
      'ref_id': _referalController.text,
    };
    try {
      final response = await http.post(
        Uri.parse(baseURL + 'check/referral'),
        body: bodyReq,
      );
      final model = json.decode(response.body);
      if (response.statusCode == 200) {
        if (model["status"] == 'fail') {
          setState(() {
            isChecked = false;
          });
        } else {
          if (model['msg'] == 'Referrer username matched') {
            setState(() {
              isChecked = true;
            });
          }
        }
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }
}
