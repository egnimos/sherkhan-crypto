import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Trade extends StatefulWidget {
  const Trade({Key? key}) : super(key: key);

  @override
  _TradeState createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('Trade'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: WebView(
              backgroundColor: const Color(0xff32373a),
              initialUrl: "https://payment.sherkhanril.com/graph.php",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) async {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}