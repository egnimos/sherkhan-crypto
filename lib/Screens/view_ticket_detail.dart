import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/Config/inputTextForm.dart';
import 'package:intl/intl.dart';

class ViewTicketDetail extends StatefulWidget {
  final int id;
  final String ticket;
  const ViewTicketDetail({Key? key, required this.id, required this.ticket})
      : super(key: key);
  @override
  _ViewTicketDetailState createState() => _ViewTicketDetailState();
}

class _ViewTicketDetailState extends State<ViewTicketDetail> {
  final TextEditingController _userIdController = TextEditingController();

  bool isLoading = false;
  bool isSend = false;
  // ignore: prefer_typing_uninitialized_variables
  var supportData;
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  var my_ticket;
  @override
  void initState() {
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
    super.initState();
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
          baseURL +
              'ticket/view?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14&ticket=${widget.ticket}',
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
            supportData = model['messages'];
            my_ticket = model['my_ticket'];
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

  Future<void> sendBtn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    setState(() {
      isSend = true;
    });
    var header = {'Authorization': 'Bearer $auth'};
    var bodyParam = {
      'replayTicket': widget.id.toString(),
      'message': _userIdController.text,
      'ticket': widget.id.toString(),
    };
    try {
      final response = await http.post(
        Uri.parse(
          baseURL + 'ticket/reply?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
        ),
        headers: header,
        body: bodyParam,
      );
      var model = json.decode(response.body);
      // print('------- $model');
      if (response.statusCode == 200) {
        setState(() {
          _userIdController.clear();
        });
        await getSupport();
      } else {
        // progressHUD.state.dismiss();
        showToast(model["msg"].toString());
      }
    } catch (error) {
      // progressHUD.state.dismiss();
      showToast(error.toString());
    } finally {
      setState(() {
        isSend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('Ticket view'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: AllInputDesign(
                controller: _userIdController,
                labelText: 'Send response',
                keyBoardType: TextInputType.emailAddress,
                fillColor: CustomColors.white,
                contentPadding: const EdgeInsets.all(5.0),
                // validator: validateEmail,
              ),
            ),
            isSend
                ? const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    onPressed: () {
                      if (_userIdController.text.trim().isEmpty) {
                        // print('error error error');
                        showToast('Please Type Something');
                      } else {
                        sendBtn();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: supportData.length,
                      itemBuilder: ((context, i) {
                        final DateTime now =
                            DateTime.parse(supportData[i]['created_at']);
                        final DateFormat formatter =
                            DateFormat('dd MMM yyyy hh:mm:ss');
                        final String formatted = formatter.format(now);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              color: CustomColors.white,
                              child: ListTile(
                                title: supportData[i]['admin_id'] == '0'
                                    ? const Text('SUPPORT TEAM')
                                    : Text(my_ticket['name']),
                                subtitle: Text(supportData[i]['message']),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text('Posted on' + formatted)
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
