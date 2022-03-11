import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:isolate';
import 'dart:ui';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    initDown();
    super.initState();
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
        title: const Text('About Us'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
              await FlutterDownloader.enqueue(
                url: "https://admin.sherkhanril.com/assets/pdfs/ABOUT.pdf",
                savedDir: externalDir!.path,
                fileName: "download",
                showNotification: true,
                openFileFromNotification: true,
              );
            }
            // else {
            //   print("Permission deined");
            // }
          }),
      body: SfPdfViewer.network(
        'https://admin.sherkhanril.com/assets/pdfs/ABOUT.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}
