import 'package:animations/animations.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Screens/about_us.dart';
import 'package:test_project/Screens/dashboard.dart';
import 'package:test_project/Screens/login_screen.dart';
import 'package:test_project/Screens/registration_screen.dart';
import 'package:test_project/Screens/t_and_c.dart';

class OnBoardingNavBar extends StatefulWidget {
  final int currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  OnBoardingNavBar({Key? key, this.currentTab = 0}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _OnBoardingNavBarState createState() => _OnBoardingNavBarState(currentTab);
}

class _OnBoardingNavBarState extends State<OnBoardingNavBar> {
  int currentTab;
  _OnBoardingNavBarState(this.currentTab);

  final List<Widget> _widgets = [
    const LoginScreen(),
    const RegistrationScreen(),
    const Trade(),
    const TAndC(),
    const AboutUs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      body: Stack(
        children: <Widget>[
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                child: child,
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
              );
            },
            child: Container(
              key: ValueKey<int>(currentTab),
              child: _widgets[currentTab],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentTab,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() {
          currentTab = index;
        }),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(
              Icons.login,
              color: currentTab == 0 ? CustomColors.darkOrange : Colors.grey,
            ),
            title: Text(
              'Sign In',
              style: TextStyle(
                color: currentTab == 0 ? CustomColors.darkOrange : Colors.white,
              ),
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.assignment_ind,
              color: currentTab == 1 ? CustomColors.darkOrange : Colors.grey,
            ),
            title: Text(
              'Sign Up',
              style: TextStyle(
                color: currentTab == 1 ? CustomColors.darkOrange : Colors.white,
              ),
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.align_vertical_bottom,
              color: currentTab == 2 ? CustomColors.darkOrange : Colors.grey,
            ),
            title: Text(
              'Trade',
              style: TextStyle(
                color: currentTab == 2 ? CustomColors.darkOrange : Colors.white,
              ),
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.document_scanner,
              color: currentTab == 3 ? CustomColors.darkOrange : Colors.grey,
            ),
            title: Text(
              'Terms', //'Contact Us', //'Privacy Policy',
              style: TextStyle(
                color: currentTab == 3 ? CustomColors.darkOrange : Colors.white,
              ),
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.admin_panel_settings_outlined,
              color: currentTab == 4 ? CustomColors.darkOrange : Colors.grey,
            ),
            title: Text(
              'About Us',
              style: TextStyle(
                color: currentTab == 4 ? CustomColors.darkOrange : Colors.white,
              ),
            ),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
