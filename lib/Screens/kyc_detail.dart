import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Config/inputTextForm.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/Screens/bit_deposit.dart';
import 'package:test_project/Services/user_service.dart';
import 'package:test_project/models/user.dart';

class KycDetail extends StatefulWidget {
  const KycDetail({Key? key}) : super(key: key);

  @override
  _KycDetailState createState() => _KycDetailState();
}

class _KycDetailState extends State<KycDetail> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _bankAccController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isInit = true;
  User? user;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // if (mounted) {
      //   setState(() {
      //     isLoading = true;
      //   });
      // }
      // getProfile().then((value) {
      //   if (mounted) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //   }
      // });
      //user
      user = Provider.of<UserService>(context, listen: false).user;
      if (mounted) {
        setState(() {
          _fnameController.text = user?.firstName ?? "";
          _lnameController.text = user?.lastName ?? "";
          _panController.text = user?.panNo ?? "";
          _aadharController.text = user?.aadharNo ?? "";
          _bankAccController.text = user?.accountNo ?? "";
          _ifscController.text = user?.ifsc ?? "";
          _bankNameController.text = user?.bankName ?? "";
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // Future<void> getProfile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var auth = prefs.getString('authToken');
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var header = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $auth'
  //   };
  //   try {
  //     // print(baseURL + 'myprofile?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14');
  //     final response = await http.get(
  //       Uri.parse(
  //         baseURL + 'myprofile?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
  //       ),
  //       headers: header,
  //     );
  //     var model = json.decode(response.body);
  //     // print('------- ${model['image']}');
  //     // print('------- $model');
  //     if (response.statusCode == 200) {
  //       if (model["status"] == 'fail') {
  //         showToast(model["msg"].toString());
  //       } else {
  //         if (mounted) {
  //           setState(() {

  //           });
  //         }
  //       }
  //     } else {
  //       showToast(model["msg"].toString());
  //     }
  //   } catch (error) {
  //     showToast(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text(
          'MY KYC',
          style: TextStyle(
            color: CustomColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _fnameController,
                        labelText: 'First Name',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter first name';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _lnameController,
                        labelText: 'Last Name',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter last name';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _panController,
                        labelText: 'PAN Number',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter PAN number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _aadharController,
                        labelText: 'Aadhar Number',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter aadhar number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _bankAccController,
                        labelText: 'Bank Account Number',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter bank account number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _bankNameController,
                        labelText: 'Bank Name',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter bank name';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 1, 2),
                      child: AllInputDesign(
                        controller: _ifscController,
                        labelText: 'IFSC Code',
                        keyBoardType: TextInputType.emailAddress,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: CustomColors.white,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        inputborder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5.0),
                        validator: (text) {
                          if (text.isEmpty || text == null) {
                            return 'please enter IFSC code';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
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
                        child: const Text(
                          'complete KYC',
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
                            final userInfo = User(
                              id: 0,
                              firstName: _fnameController.text.toString(),
                              lastName: _lnameController.text.toString(),
                              userName: user?.userName ?? "",
                              email: user?.email ?? "",
                              userEmail: user?.userEmail ?? "",
                              mobile: user?.mobile ?? "",
                              panNo: _panController.text.toString(),
                              aadharNo: _aadharController.text.toString(),
                              bankName: _bankNameController.text.toString(),
                              accountNo: _bankAccController.text.toString(),
                              ifsc: _ifscController.text.toString(),
                              balance: user?.balance ?? "",
                              refNo: user?.refNo ?? "",
                              totalInvested: user?.totalInvested ?? "",
                              imageName: user?.imageName ?? "",
                              kycStatus: "1",
                              // address: user?.address ?? "",
                              // state: user?.state ?? "",
                              // zip: user?.zip ?? "",
                              // country: user?.country ?? "",
                              paidDate: user?.paidDate ?? "",
                              updatedAt: user?.updatedAt ?? "",
                              secret: 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
                            );
                            await Provider.of<UserService>(context,
                                    listen: false)
                                .updateUser(context, userInfo);
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
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? const CircularProgressIndicator()
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
