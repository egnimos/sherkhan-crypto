import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/Screens/create_ticket.dart';
import 'package:test_project/Screens/view_ticket_detail.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = false;
  bool isTap = false;
  // ignore: prefer_typing_uninitialized_variables
  var supportData;
  var isSet = 'all';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getSupport().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> getSupport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          baseURL + 'ticket?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
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
            supportData = model['data'];
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

  Future<void> getOpenSupport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    setState(() {
      isLoading = true;
    });
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          baseURL + 'ticket/new?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      print('------- $model');
      if (response.statusCode == 200) {
        // setState(() {
        //   isLoading = false;
        // });
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            supportData = model['data'];
          });
        }
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        // progressHUD.state.dismiss();
        showToast(model["msg"].toString());
      }
    } catch (error) {
      // setState(() {
      //   isLoading = false;
      // });
      // progressHUD.state.dismiss();
      showToast(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('Support'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // const Center(child: Text('Call')),
          IconButton(
            onPressed: () => UrlLauncher.launch("tel:1800-258-5458"),
            icon: const Icon(Icons.call),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTicket(),
                    ),
                  );
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSet = 'all';
                            });
                            getSupport();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSet == 'all'
                                    ? CustomColors.appBarColor
                                    : CustomColors.black,
                              ),
                              color: isSet == 'all'
                                  ? CustomColors.appBarColor
                                  : CustomColors.white,
                            ),
                            child: Text(
                              'All Ticket',
                              style: TextStyle(
                                color: isSet == 'all'
                                    ? CustomColors.white
                                    : CustomColors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSet = 'new';
                            });
                            getSupport();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSet == 'new'
                                    ? CustomColors.appBarColor
                                    : CustomColors.black,
                              ),
                              color: isSet == 'new'
                                  ? CustomColors.appBarColor
                                  : CustomColors.white,
                            ),
                            child: Text(
                              'New Ticket',
                              style: TextStyle(
                                color: isSet == 'new'
                                    ? CustomColors.white
                                    : CustomColors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSet = 'open';
                            });
                            getOpenSupport();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSet == 'open'
                                    ? CustomColors.appBarColor
                                    : CustomColors.black,
                              ),
                              color: isSet == 'open'
                                  ? CustomColors.appBarColor
                                  : CustomColors.white,
                            ),
                            child: Text(
                              'Open Ticket',
                              style: TextStyle(
                                color: isSet == 'open'
                                    ? CustomColors.white
                                    : CustomColors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (int i = 0; i < supportData.length; i++) ...[
                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
                      color: CustomColors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewTicketDetail(
                                id: supportData[i]['id'],
                                ticket: supportData[i]['ticket'],
                              ),
                            ),
                          );
                        },
                        title: Text(supportData[i]['subject'],
                            style: TextStyle(
                                color: CustomColors.black,
                                fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(supportData[i]['name'],
                                style: TextStyle(
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400)),
                            Text(supportData[i]['email'],
                                style: TextStyle(
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400)),
                            Text(
                              supportData[i]['status'] == '0'
                                  ? 'Open'
                                  : 'Close',
                              style: TextStyle(
                                  color: supportData[i]['status'] == '0'
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
    );
  }
}
