import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InvestmentHistory extends StatefulWidget {
  const InvestmentHistory({Key? key}) : super(key: key);

  @override
  _InvestmentHistoryState createState() => _InvestmentHistoryState();
}

class _InvestmentHistoryState extends State<InvestmentHistory> {
  List _list = [];

  bool isLoading = false;
  List dataShow = [];
  @override
  void initState() {
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

    super.initState();
  }

  Future<void> getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          baseURL +
              'deposit/history?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      print('------- $model');
      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            _list = model['data'];
          });
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
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: Text(
          'Investment History',
          style: TextStyle(
            color: CustomColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _list.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4),
                    child: Center(
                      child: Text(isLoading ? '' : 'No Data Found'),
                    ),
                  )
                : ListView.builder(
                    itemCount: _list.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final DateTime now =
                          DateTime.parse(_list[index]['created_at']);
                      final DateFormat formatter = DateFormat('dd MMM yyyy');
                      final String formatted = formatter.format(now);
                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              // setBackToOrderQues(_list, index, "OrderPaymentDetail");
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.credit_card_rounded,
                                              size: 45,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                              '#' +
                                                  _list[index]['trx']
                                                      .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Amount- ₹' +
                                        _list[index]['amount'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ), //invested amount
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Charges- ₹' +
                                        _list[index]['charge'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ), //invested amount
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Invested Amount- ₹' +
                                        _list[index]['final_amo'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ), //invested amount
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Date: $formatted",
                                        style: TextStyle(
                                          color: CustomColors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      status(_list[index]['status'].toString()),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomColors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
          isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget textbold(text) {
    return Text(
      text,
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
    );
  }

  Widget status(text) {
    // print('gggg $text');
    return Row(
      children: [
        const Text('Status:'),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
          child: Text(
            text == '1'
                ? 'Success'
                : text == '2'
                    ? 'Pending'
                    : 'Cancel',
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: text == '1'
                  ? Colors.green
                  : text == '2'
                      ? Colors.yellow
                      : Colors.red,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
