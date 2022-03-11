import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
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
            'https://admin.sherkhanril.com/api/withdraw/history?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14'),
        headers: header,
      );
      var model = json.decode(response.body);
      // print('----sss--- $model');
      if (response.statusCode == 200) {
        setState(() {
          dataShow = model['data'];
        });
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
        title: Text(
          'Withdraw History',
          style: TextStyle(
            color: CustomColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ListView.builder(
                itemCount: dataShow.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final DateTime now =
                      DateTime.parse(dataShow[index]['created_at']);
                  final DateFormat formatter =
                      DateFormat('dd MMM yyyy hh:mm:ss');
                  final String formatted = formatter.format(now);
                  var i = int.parse(dataShow[index]['status']);
                  var status = i == 1
                      ? 'Success'
                      : i == 2
                          ? 'Pending'
                          : i == 3
                              ? 'Cancel'
                              : '';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          // setBackToOrderQues(_list, index, "OrderPaymentDetail");
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trx Number #' +
                                          dataShow[index]['trx'].toString(),
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.black),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'Amount ₹' +
                                          dataShow[index]['amount'].toString(),
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.black),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Charges: ₹" +
                                          dataShow[index]['charge'].toString(),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Date: " + formatted.toString(),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6.0,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Status: ",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        getStatus(status),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    // orderStatusSet(dataShow, index),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  );
                }),
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
      ),
    );
  }

  getStatus(status) {
    return Container(
      height: 25,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(39),
      ),
      alignment: Alignment.center,
      child: Text(
        status,
        style: TextStyle(
          color: CustomColors.white,
        ),
      ),
    );
  }

  orderStatusSet(list, index) {
    //1=new order,2=dispatch ready,3=on the way,4=delivered,5=cancel by user,6=cancel by admin
    var colour = Colors.green;
    var text = "";
    if (list[index]['status'] == "1") {
      colour = Colors.red;
      text = "new_order";
    } else if (list[index]['status'] == "2") {
      colour = Colors.green;
      text = "dispatch_ready";
    } else if (list[index]['status'] == "3") {
      colour = Colors.green;
      text = "on_the_way";
    } else if (list[index]['status'] == "4") {
      colour = Colors.green;
      text = "delivered";
    } else if (list[index]['status'] == "5") {
      colour = Colors.red;
      text = "cancelled_by_user";
    } else if (list[index]['status'] == "6") {
      colour = Colors.red;
      text = "cancelled_by_admin";
    } else {
      colour = Colors.green;
      text = "cancelled_by_admin";
    }
    return Text(
      text.toString(),
      maxLines: 1,
      style: TextStyle(
        fontSize: 16.0,
        color: colour,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montaga',
      ),
    );
  }
}
