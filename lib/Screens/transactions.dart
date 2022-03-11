import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';

class MyTransactions extends StatefulWidget {
  const MyTransactions({Key? key}) : super(key: key);

  @override
  _MyTransactionsState createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyTransactions> {
  List _list = [];
  bool isLoading = false;
  List dataShow = [];

  @override
  void initState() {
    if (mounted) {
      setState(() {
        isLoading = false;
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
          'https://admin.sherkhanril.com/api/report/transactions/log?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      // print('------- $model');
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            _list = model['transactions']['data'];
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
        title: const Text(
          'Transaction History',
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "My Available Balance: ",
                              style: TextStyle(
                                color: CustomColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹' + MYBALANCE.toString(),
                              style: const TextStyle(
                                color: CustomColors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ListView.builder(
                          itemCount: _list.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final DateTime now =
                                DateTime.parse(_list[index]['created_at']);
                            final DateFormat formatter =
                                DateFormat('dd MMM yyyy');
                            final String formatted = formatter.format(now);
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 0.0),
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    // setBackToOrderQues(_list, index, "OrderPaymentDetail");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.credit_card_rounded,
                                              size: 45,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            Flexible(
                                              child: Text(
                                                '#' +
                                                    _list[index]['trx']
                                                        .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: CustomColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '₹' +
                                                    _list[index]['amount']
                                                        .toString(),
                                                style: const TextStyle(
                                                    color: CustomColors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Date: $formatted",
                                                style: const TextStyle(
                                                  color: CustomColors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          "Remark: " +
                                              _list[index]['details']
                                                  .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: CustomColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColors.white,
                                  border: Border.all(
                                    color: _list[index]['trx_type'] == '+'
                                        ? Colors.green
                                        : Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          10.0) //                 <--- border radius here
                                      ),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: 20.0),
                    ],
                  ),
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
            text == '+' ? 'Success' : 'Cancel',
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: text == '+' ? Colors.green : Colors.red,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
