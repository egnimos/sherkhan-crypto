import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Screens/about_us.dart';
import 'package:test_project/Screens/chat_screen.dart';
import 'package:test_project/Screens/dashboard.dart';
import 'package:test_project/Screens/my_account_screen.dart';
import 'package:test_project/Screens/news_screen.dart';
import 'package:animations/animations.dart';

class NavigationPage extends StatefulWidget {
  final int currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  NavigationPage({Key? key, this.currentTab = 0}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _NavigationPageState createState() => _NavigationPageState(currentTab);
}

class _NavigationPageState extends State<NavigationPage> {
  int currentTab;
  _NavigationPageState(this.currentTab);
  final List<Widget> _widgets = [
    const AboutUs(),
    const NewsScreen(),
    const Trade(),
    const ChatScreen(),
    const MyAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onBackPressed(),
      child: Scaffold(
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
                Icons.admin_panel_settings_outlined,
                color: currentTab == 0 ? CustomColors.darkOrange : Colors.grey,
              ),
              title: Text(
                'About',
                style: TextStyle(
                  color:
                      currentTab == 0 ? CustomColors.darkOrange : Colors.white,
                ),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.add_location_sharp,
                color: currentTab == 1 ? CustomColors.darkOrange : Colors.grey,
              ),
              title: Text(
                'News',
                style: TextStyle(
                  color:
                      currentTab == 1 ? CustomColors.darkOrange : Colors.white,
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
                  color:
                      currentTab == 2 ? CustomColors.darkOrange : Colors.white,
                ),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.message,
                color: currentTab == 3 ? CustomColors.darkOrange : Colors.grey,
              ),
              title: Text(
                'Chat',
                style: TextStyle(
                  color:
                      currentTab == 3 ? CustomColors.darkOrange : Colors.white,
                ),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.menu,
                color: currentTab == 4 ? CustomColors.darkOrange : Colors.grey,
              ),
              title: Text(
                'My Account',
                style: TextStyle(
                  color:
                      currentTab == 4 ? CustomColors.darkOrange : Colors.white,
                ),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Do you want to exit the app?',
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }
}
