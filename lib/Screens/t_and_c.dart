import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class TAndC extends StatefulWidget {
  const TAndC({Key? key}) : super(key: key);

  @override
  _TAndCState createState() => _TAndCState();
}

class _TAndCState extends State<TAndC> {
  bool isLoading = false;
  String pageUrl = '';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int progress = 0;

  final ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getTeamBit().then((_) => initDown()).then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  Future getTeamBit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth'
    };
    try {
      final response = await http.get(
        Uri.parse(
          'https://admin.sherkhanril.com/api/pages?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14&slug=terms',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      print('------- $model');
      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          await showToast(model["msg"].toString());
        } else {
          setState(() {
            pageUrl = model['sections']['secs'];
          });
        }
      } else {
        // progressHUD.state.dismiss();
        await showToast(model["msg"].toString());
      }
    } catch (error) {
      // progressHUD.state.dismiss();
      showToast(error.toString());
    }
  }

  initDown() async {
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      // print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('Terms and Conditions'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          : SfPdfViewer.network(
              pageUrl,
              key: _pdfViewerKey,
            ),
    );
  }
}
