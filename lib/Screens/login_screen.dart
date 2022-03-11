import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:test_project/Config/validations.dart';
import 'package:test_project/Screens/forgot_password.dart';
import 'package:test_project/Screens/kyc_detail.dart';
import 'package:test_project/Screens/navigation_page.dart';
import 'package:test_project/Services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
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
                        'Sign In',
                        style: TextStyle(
                          color: CustomColors.darkOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 40),
                      AllInputDesign(
                        controller: _emailController,
                        labelText: 'User Name',
                        validatorFieldValue: validateEmail,
                        keyBoardType: TextInputType.emailAddress,
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'Please enter user name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      AllInputDesign(
                        controller: _passwordController,
                        labelText: 'Password',
                        validatorFieldValue: validatePassword,
                        fillColor: CustomColors.white,
                        contentPadding: const EdgeInsets.all(5.0),
                        obsecureText: passwordVisible,
                        validator: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Please password';
                          }
                          if (value.length < 6) {
                            return "Please enter a password with at least 6 characters";
                          } else {
                            return null;
                          }
                        },
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: CustomColors.orange,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
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
                                        'Sign In',
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
                                    await logInpApi();
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

  Future<void> logInpApi() async {
    final bodyReq = {
      'secret': 'bd5c49f2-a-44d4-8daa-6ff67ab1bc14',
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    try {
      final response = await http.post(
        Uri.parse(baseURL + 'login'),
        body: bodyReq,
      );
      final model = json.decode(response.body);
      if (response.statusCode == 200) {
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('authToken', model['access_token']);
          prefs.setBool('isLogin', true);
          setState(() {
            ISREF = false;
          });
          await getUser();
        }
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> getUser() async {
    try {
      //get the user info
      await Provider.of<UserService>(context, listen: false).getUser();
      final user = Provider.of<UserService>(context, listen: false).user;
      if (user?.kycStatus == '0') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const KycDetail(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(
              currentTab: 2,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } catch (error) {
      showToast(error.toString());
    }
  }
}
