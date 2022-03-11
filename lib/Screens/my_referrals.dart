// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';

class MyReferrals extends StatefulWidget {
  final String title;
  final String id;
  const MyReferrals({Key? key, required this.title, required this.id})
      : super(key: key);
  @override
  _MyReferralsState createState() => _MyReferralsState();
}

class _MyReferralsState extends State<MyReferrals> {
  bool isLoading = false;
  List dataShow = [];
  var isBack = 0;
  // ignore: prefer_typing_uninitialized_variables
  var getId;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    _selectFun().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  Future<void> _selectFun() async {
    getId = widget.id;
    String title = widget.title;
    switch (title) {
      case 'BIT':
        await getTeamIpo();
        break;
      case 'BIT ':
        await getTeamIpo();
        break;
      case 'My Referrals':
        await getReferrals();
        break;
      case 'IPO':
        await getTeamIpo();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: dataShow.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Center(
                        child: Text(isLoading ? '' : 'No Data Found'),
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isBack == 0
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        getTeamIpo();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          // shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2, left: 10),
                                        child: Stack(
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              color: CustomColors.white,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: CustomColors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.topRight,
                              child: widget.title == 'BIT' ||
                                      widget.title == 'BIT ' ||
                                      widget.title == 'IPO'
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        'Total ${widget.title}- ' +
                                            '${widget.title == 'BIT' ? TOTALBIT : TOTALIPO}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        ListView.builder(
                            itemCount: dataShow.length, //_list.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                                25.0, 10.0, 25.0, 10.0),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final DateTime now =
                                  DateTime.parse(dataShow[index]['created_at']);
                              final DateFormat formatter =
                                  DateFormat('dd MMM yyyy');
                              final String formatted = formatter.format(now);
                              return GestureDetector(
                                onTap: () {
                                  // print(dataShow[index]['id']);
                                  setState(() {
                                    getId = dataShow[index]['id'];
                                  });
                                  widget.title == 'BIT' || widget.title == 'IPO'
                                      ? getTeamIpo()
                                      : null;
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 10.0, 25.0, 10.0),
                                  margin: const EdgeInsets.only(top: 15),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    tileColor: Colors.grey[100],
                                    leading: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: CustomColors.white,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://admin.sherkhanril.com/assets/images/user/profile/' +
                                                dataShow[index]['image'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      dataShow[index]['firstname'] +
                                          ' ' +
                                          dataShow[index]['lastname'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          dataShow[index]['username'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Joined At: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              formatted.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: CustomColors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Total Investment: ₹',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              dataShow[index]['total_invest']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: CustomColors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(2, 5),
                                      )
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                ),
                              );
                            }),
                      ],
                    )),
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

  Future<void> getReferrals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          baseURL + 'referrals?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      // print('------- $model');
      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            dataShow = model['logs']['data'];
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

  Future<void> getTeamBit() async {
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
              'myteam?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14&team_type=BIT',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      // print('------- $model');
      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            dataShow = model['logs']['data'];
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

  Future<void> getTeamIpo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    var url = isBack == 0
        ? baseURL +
            'myteam?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14&team_type=IPO&id=$getId'
        : baseURL +
            'myteam?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14&team_type=IPO&id=${getId}&id=${isBack}';
    // print(url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      var model = json.decode(response.body);
      // print('------- $model');
      if (response.statusCode == 200) {
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            dataShow = model['logs'];
            isBack = model['back_id'];
          });
        }
      } else {
        showToast(model["msg"].toString());
      }
    } catch (error) {
      showToast(error.toString());
    }
  }
}
