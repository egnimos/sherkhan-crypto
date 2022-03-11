import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:http/http.dart' as http;

class DashPage extends StatefulWidget {
  const DashPage({Key? key}) : super(key: key);

  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  bool isLoading = false;
  var dashData;
  var getMin;
  late DateTime getTime;
  var gggg1;
  var gggg2;
  var gggg3;
  var gggg4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // final Duration _duration = const Duration(seconds: 1000000);
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getDashboard().then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  gettimestamp() async {
    final date2 = DateTime.now();
    final difference = daysBetween(date2, getTime);
    setState(() {
      gggg1 = difference;
    });
    // print('============ ============$getTime  $date2 $difference');
  }

  Future<void> getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final auth = prefs.getString('authToken');
    final header = {'Authorization': 'Bearer $auth'};
    try {
      final response = await http.get(
        Uri.parse(
          baseURL + 'dashboard?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      final model = json.decode(response.body);

      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          var q1 = DateTime.parse(model['timer_end_time']).day;
          setState(() {
            dashData = model;
            gggg1 = q1.toString();
            getMin = model['remaining_minute'];
            getTime = DateTime.parse(model['timer_end_time']);
            MYBALANCE = dashData['user']['balance'];
          });
          await gettimestamp();
        }
      } else {
        // progressHUD.state.dismiss();
        showToast(model["msg"].toString());
      }
    } catch (error) {
      // progressHUD.state.dismiss();
      showToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('DashBoard'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    gggg1 == 0
                        ? const SizedBox.shrink()
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomColors.orange, width: 1.5),
                              color: CustomColors.orange.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                            child: Column(
                              children: [
                                const Text(
                                  'Time Left to Complete IPO',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SlideCountdownClock(
                                  duration: Duration(
                                    days: gggg1,
                                  ),
                                  slideDirection: SlideDirection.Up,
                                  separator: ":",
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shouldShowDays: true,
                                  onDone: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Clock 1 finished'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        datashow(
                          'Wallet Balance',
                          '₹ ${dashData['user']['balance']}',
                          Colors.brown,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        datashow(
                          'My Investment',
                          '₹ ${dashData['totalDeposit']}',
                          Colors.lime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        datashow(
                          'Referral Team',
                          dashData['total_ref'] ?? '0',
                          Colors.black87,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        datashow(
                          'My BIT',
                          dashData['total_bit'] ?? '0',
                          Colors.pink,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        datashow(
                          'Team BIT',
                          dashData['user_extra']['total_team'] ?? '0',
                          Colors.redAccent,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        datashow(
                          'IPO',
                          dashData['total_ipo'] ?? '0',
                          Colors.greenAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        datashow(
                          'Direct BIT Income',
                          '₹ ${dashData['direct_bit_income']}',
                          Colors.deepPurple,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        datashow(
                          'BIT Profit',
                          '₹ ${dashData['bit_profit']}',
                          Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        datashow(
                          'Indirect Income',
                          '₹ ${dashData['indirect_income']}',
                          Colors.blueGrey,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        datashow(
                          'Cashback',
                          '₹ ${dashData['cashback']}',
                          Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        datashow(
                          'Extra Bonus',
                          '₹ ${dashData['extra_bonus']}',
                          Colors.greenAccent,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        datashow(
                          'Total Withdraw',
                          '₹ ${dashData['totalWithdraw']}',
                          Colors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        datashow(
                          'Complete Withdraw',
                          '₹ ${dashData['completeWithdraw']}',
                          Colors.green,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        datashow(
                          'Pending Withdraw',
                          '₹ ${dashData['pendingWithdraw']}',
                          Colors.deepPurple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }

  Widget datashow(heading, text, colorsget) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width * 0.41,
      decoration: BoxDecoration(
        color: colorsget,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            heading.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
