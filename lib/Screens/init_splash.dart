import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Screens/kyc_detail.dart';
import 'package:test_project/Screens/navigation_page.dart';
import 'package:test_project/Screens/onBoardingNavBar.dart';
import 'package:test_project/Services/user_service.dart';

import '../models/user.dart';

class InitSplash extends StatefulWidget {
  const InitSplash({Key? key}) : super(key: key);

  @override
  _InitSplashState createState() => _InitSplashState();
}

class _InitSplashState extends State<InitSplash> {
  bool isAuth = false;
  bool isKYC = false;
  User? user;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadInfo();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAuth = prefs.getBool('isLogin') ?? false;
    if (isAuth) {
      await Provider.of<UserService>(context, listen: false).getUser();
    }
    await init();
  }

  //play the intro
  Future<void> init() async {
    isKYC = Provider.of<UserService>(context, listen: false).user?.kycStatus == "1";
    // print(auth);
    // print(isKYC);
    if (isAuth && isKYC) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(
              currentTab: 2,
            ),
          ),
          (route) => false);
    } else if (isAuth && !isKYC) {
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
            builder: (context) => OnBoardingNavBar(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: CustomColors.white,
        ),
        child: Image.asset('assets/images/ss2.jpg'),
      ),
    );
  }
}
