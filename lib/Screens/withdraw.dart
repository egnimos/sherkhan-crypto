import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:test_project/Config/validations.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  final GlobalKey<FormState> _keyValid = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accNoController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;
  bool isLoading2 = false;
  bool isAdd = false;
  List dataShow = [];
  // ignore: prefer_typing_uninitialized_variables
  var charge;
  // ignore: prefer_typing_uninitialized_variables
  var payable;
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
            'https://admin.sherkhanril.com/api/mybanks?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14'),
        headers: header,
      );
      var model = json.decode(response.body);
      // print('----sss--- $model');
      if (response.statusCode == 200) {
        setState(() {
          dataShow = model;
        });
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> addBank() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var headerGet = {'Authorization': 'Bearer $auth'};
    var params = {
      'acountname': _nameController.text,
      'account': _accNoController.text,
      'ifsc': _ifscController.text,
    };
    try {
      // print(headerGet);
      // print(params);
      final response = await http.post(
        Uri.parse(
          'https://admin.sherkhanril.com/api/add-banks?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        body: params,
        headers: headerGet,
      );
      var model = json.decode(response.body);
      print('----sss--- $model');
      if (response.statusCode == 200) {
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          getDashboard();
        }
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> withdrawl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    // var amount = int.parse(_amountController.text) * 0.18;
    var header = {'Authorization': 'Bearer $auth'};
    var params = {
      'method_code': '1',
      'amount': _amountController.text,
      'bank_id': typeIs.toString(),
    };
    try {
      final response = await http.post(
        Uri.parse(
            'https://admin.sherkhanril.com/api/withdraw?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14'),
        headers: header,
        body: params,
      );
      var model = json.decode(response.body);
      print('----sss--- $model');
      if (response.statusCode == 200) {
        showToast(model["msg"].toString());
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var typeIs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        automaticallyImplyLeading: true,
        title: Text(
          'Withdraw',
          style: TextStyle(
            color: CustomColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
          child: Stack(
            children: [
              Form(
                key: _keyValid,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: CustomColors.orange, width: 1.5),
                        color: CustomColors.orange.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Text(
                        '*EVERY WITHDRAWALS ON MONDAY 10AM to 3PM. \n\n*ALL WITHDRAWALS PAY SERVICE TAX WILL BE – 18% GST. \n\n*MINIMUM WITHDRAWAL = Rs.4000/',
                        style: TextStyle(
                          color: CustomColors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Available Balance: ",
                          style: TextStyle(
                            color: CustomColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹' + MYBALANCE.toString(),
                          style: TextStyle(
                            color: CustomColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Your Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    for (int i = 0; i < dataShow.length; i++) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CustomColors.orange),
                        ),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              typeIs = dataShow[i]['id'];
                            });
                          },
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          title:
                              Text('Name: ${dataShow[i]['acountname'] ?? ''}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Account Number: ${dataShow[i]['account'] ?? ''}'),
                              Text('IFSC Code: ${dataShow[i]['ifsc'] ?? ''}'),
                            ],
                          ),
                          trailing: typeIs == dataShow[i]['id']
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.circle),
                          // subtitle: Text(withdrawSelect[i]['des']),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAdd = !isAdd;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Account',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          isAdd
                              ? const Icon(
                                  Icons.arrow_circle_up,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.arrow_circle_down,
                                  size: 30,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    isAdd ? selectType() : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                      ),
                      child: AllInputDesign(
                        controller: _amountController,
                        labelText: 'Enter Amount',
                        keyBoardType: TextInputType.number,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        onChanged: (val) {
                          setState(() {
                            charge = int.parse(val) * 0.18;
                            payable = int.parse(val) - charge;
                          });
                          // print('ruururururu$charge $payable');
                        },
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 15, 1, 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Charges '),
                            Text('${charge ?? ''}'),
                          ],
                        )),
                    const SizedBox(height: 15),
                    Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 15, 1, 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Payable amount '),
                            Text('${payable ?? ''}'),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (typeIs != null) {
                          if (_amountController.text.isEmpty) {
                            showToast('Please enter amount');
                          } else {
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                              });
                            }
                            await withdrawl();
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          showToast('Please select account');
                        }
                      },
                      child: Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        decoration: BoxDecoration(
                          color: CustomColors.orange,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: isLoading2
                            ? const CircularProgressIndicator()
                            : Text(
                                'Withdraw',
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
        ),
      ),
    );
  }

  Widget selectType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          child: AllInputDesign(
            controller: _nameController,
            labelText: 'Name',
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: CustomColors.white,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            inputborder: InputBorder.none,
            contentPadding: const EdgeInsets.all(5.0),
            validator: validateName,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
          child: AllInputDesign(
            controller: _accNoController,
            labelText: 'Account Number',
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: CustomColors.white,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            inputborder: InputBorder.none,
            contentPadding: const EdgeInsets.all(5.0),
            validator: (value) {
              if (value.isEmpty || value == null) {
                return 'Please enter account number';
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          child: AllInputDesign(
            controller: _ifscController,
            labelText: 'IFSC Code',
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: CustomColors.white,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            inputborder: InputBorder.none,
            contentPadding: const EdgeInsets.all(5.0),
            validator: (value) {
              if (value.isEmpty || value == null) {
                return 'Please enter IFSC code';
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              if (_keyValid.currentState!.validate()) {
                if (mounted) {
                  setState(() {
                    isLoading = true;
                  });
                }
                await addBank();
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
            child: const Text(
              'Add Bank',
              style: TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
