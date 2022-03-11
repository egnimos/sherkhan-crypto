import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Config/common_widgets.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:http/http.dart' as http;

class Tutorials extends StatefulWidget {
  const Tutorials({Key? key}) : super(key: key);

  @override
  _TutorialsState createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  String pageUrl = '';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isLoading = false;

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
    initDown();
    getTeamBit();
    super.initState();
  }

  Future getTeamBit() async {
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
          'https://admin.sherkhanril.com/api/pages?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14&slug=tutorials',
        ),
        headers: header,
      );
      var model = json.decode(response.body);
      print('------- $model');
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        // progressHUD.state.dismiss();
        if (model["status"] == 'fail') {
          showToast(model["msg"].toString());
        } else {
          setState(() {
            pageUrl = model['sections']['secs'];
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        // progressHUD.state.dismiss();
        showToast(model["msg"].toString());
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
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
        title: const Text('Tutorials'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.download),
          onPressed: () async {
            final status = await Permission.storage.request();

            if (status.isGranted) {
              final externalDir = await getExternalStorageDirectory();
              // ignore: unused_local_variable
              final id = await FlutterDownloader.enqueue(
                url: pageUrl,
                savedDir: externalDir!.path,
                fileName: "download",
                showNotification: true,
                openFileFromNotification: true,
              );
            } 
            // else {
            //   if (kDebugMode) {
            //     print("Permission deined");
            //   }
            // }
          }),
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
