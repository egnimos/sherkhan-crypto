import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Screens/bit_deposit.dart';
import 'package:test_project/Screens/bit_income.dart';
import 'package:test_project/Screens/change_password.dart';
import 'package:test_project/Screens/dashPage.dart';
import 'package:test_project/Screens/investment_history.dart';
import 'package:test_project/Screens/kyc_detail.dart';
import 'package:test_project/Screens/my_profile.dart';
import 'package:test_project/Screens/my_referrals.dart';
import 'package:test_project/Screens/navigation_page.dart';
import 'package:test_project/Screens/onBoardingNavBar.dart';
import 'package:test_project/Screens/order_history.dart';
import 'package:test_project/Screens/transactions.dart';
import 'package:test_project/Screens/tutorials.dart';
import 'package:test_project/Screens/withdraw.dart';
import 'package:test_project/Services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_project/Screens/t_and_c.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool isLoading = false;
  bool isTap = false;
  bool isIncTap = false;
  // ignore: prefer_typing_uninitialized_variables
  var dashData;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getDashboard().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final auth = prefs.getString('authToken');
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          baseURL + 'dashboard?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      final model = json.decode(response.body);
      print('------- $model');
      if (response.statusCode == 200) {
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            dashData = model;
            MYBALANCE = dashData['user']['balance'].toString();
            TOTALBIT = dashData['total_bit'].toString();
            TOTALIPO = dashData['total_ipo'].toString();
          });
        }
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('My Account'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const LinearProgressIndicator(color: CustomColors.orange)
                else if (dashData != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                    child: Consumer<UserService>(
                      builder: (context, us, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: CustomColors.black,
                                    width: 1.3,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://admin.sherkhanril.com/assets/images/user/profile/${us.user?.imageName ?? ""}',
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${us.user?.firstName ?? ""} ${us.user?.lastName ?? ""}",
                            style: const TextStyle(
                              color: CustomColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'USER-ID:  ${us.user?.userName ?? ""}',
                            style: const TextStyle(
                              color: CustomColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'My Balance: ₹' +
                                dashData['user']['balance'].toString(),
                            style: const TextStyle(
                              color: CustomColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Total Invest: ₹' +
                                dashData['totalDeposit'].toString(),
                            style: const TextStyle(
                              color: CustomColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 15),
                commonListTile(
                  'Dashboard',
                  const Icon(
                    Icons.home,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Profile',
                  const Icon(
                    Icons.account_circle,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProfile(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'KYC',
                  const Icon(
                    Icons.verified_user,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KycDetail(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                const Divider(height: 1, thickness: 1),
                ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                  title: const Text(
                    'Income',
                    style: TextStyle(
                      color: CustomColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    isIncTap
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down,
                    size: 35,
                  ),
                  leading: const Icon(
                    Icons.business_center,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        isIncTap = !isIncTap;
                      });
                    }
                  },
                ),
                isIncTap
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 5, bottom: 15),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BITIncome(
                                      title: 'Referral Direct Bit Income',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                height: 45,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Referral Direct Bit Income',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BITIncome(
                                      title: 'Indirect Income',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                child: const Text(
                                  'Indirect Income',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BITIncome(
                                      title: 'BIT Profit',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                child: const Text(
                                  'BIT Profit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BITIncome(
                                      title: 'Cashback',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                child: const Text(
                                  'Cashback',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BITIncome(
                                      title: 'Extra Bonus',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                child: const Text(
                                  'Extra Bonus',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'BIT/IPO Deposit',
                  const Icon(
                    Icons.stay_current_portrait,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BitDeposit(
                          from: 'profile',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'IPO',
                  const Icon(
                    Icons.align_vertical_bottom_outlined,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyReferrals(
                          title: 'IPO',
                          id: TEAMBITID,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'BIT',
                  const Icon(
                    Icons.air_rounded,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyReferrals(
                          title: 'BIT',
                          id: TEAMBITID,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                  title: const Text(
                    'Withdrawal',
                    style: TextStyle(
                      color: CustomColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    isTap
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down,
                    size: 35,
                  ),
                  leading: const Icon(
                    Icons.verified_user,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  onTap: () {
                    setState(() {
                      isTap = !isTap;
                    });
                  },
                ),
                isTap
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 5, bottom: 15),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Withdraw(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                height: 45,
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Withdrawal Request',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrderHistory(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100]),
                                child: const Text(
                                  'Withdrawal History',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Investment History',
                  const Icon(
                    Icons.account_balance_sharp,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvestmentHistory(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Transaction History',
                  const Icon(
                    Icons.credit_card_rounded,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyTransactions(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Change Password',
                  const Icon(
                    Icons.password_rounded,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'My Referrals',
                  const Icon(
                    Icons.group,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyReferrals(
                          title: 'My Referrals',
                          id: '',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Become a Member',
                  const Icon(
                    Icons.person,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    setState(() {
                      ISREF = true;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingNavBar(currentTab: 1),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Invite Friend',
                  const Icon(
                    Icons.share,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    share();
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Tutorials',
                  const Icon(
                    Icons.title_outlined,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Tutorials(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Customer Support',
                  const Icon(
                    Icons.supervised_user_circle,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(
                          currentTab: 3,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Terms & Conditions',
                  const Icon(
                    Icons.person,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TAndC(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                commonListTile(
                  'Logout',
                  const Icon(
                    Icons.logout,
                    color: CustomColors.black,
                    size: 25,
                  ),
                  () async {
                    setState(() {
                      ISREF = false;
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isLogin', false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingNavBar(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 25),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ignore: unused_element
  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> tnc() async {
    if (!await launch(
      'https://admin.sherkhanril.com/terms-conditions',
      forceSafariVC: true,
      forceWebView: true,
      enableDomStorage: true,
    )) {
      throw 'Could not launch ';
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Sherkhan RIL',
      text: 'hello user',
      linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Example Chooser Title',
    );
  }

  Widget commonListTile(String title, leading, ontap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
      title: Text(
        title,
        style: const TextStyle(
          color: CustomColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: leading,
      onTap: ontap,
    );
  }
}
