import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/Config/common_widgets.dart';
import 'package:test_project/Screens/dashboard.dart';
import 'package:test_project/Screens/transactions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../Screens/navigation_page.dart';
import '../Services/user_service.dart';

enum PaymentStatus {
  fail,
  success,
  unknown,
}

class PaymentView extends StatefulWidget {
  final String orderNo;
  final String price;
  final String txnToken;
  const PaymentView({
    Key? key,
    required this.orderNo,
    required this.price,
    required this.txnToken,
  }) : super(key: key);
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String paymentView = '';
  String uri = "";
  bool isLoading = true;
  bool _isInit = true;
  PaymentStatus paymentStatus = PaymentStatus.unknown;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final user = Provider.of<UserService>(context, listen: false).user;
      setState(() {
        paymentView =
            'https://payment.sherkhanril.com?email=${user?.userEmail ?? ""}&mobile=${user?.mobile}&amount=${widget.price}&order_no=${widget.orderNo}&txnToken=${widget.txnToken}';
        uri = paymentView;
      });
      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //extract the content of the body
  // JavascriptChannel _extractDataJSChannel(BuildContext context) {
  //   return JavascriptChannel(
  //     name: 'Pay',
  //     onMessageReceived: (JavascriptMessage message) {
  //       String pageBody = message.message;
  //       print('page body: $pageBody');
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(uri),
        backgroundColor: CustomColors.orange,
      ),
      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: WebView(
              initialUrl: paymentView,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                  uri = url;
                });
              },
              onPageFinished: (String url) async {
                if (isLoading) {
                  setState(() {
                    isLoading = false;
                  });
                }

                print("finished url:: $url");

                //get the page body content
                final webView = await _controller.future;
                webView.runJavascriptReturningResult(
                    "(function(){Pay.postMessage(window.document.body.outerHTML)})();");
                if (url.contains('payment_success')) {
                  print(url);
                  // successApi();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const PaymentResult();
                  }));
                  if (mounted) {
                    setState(() {
                      paymentStatus = PaymentStatus.success;
                    });
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      paymentStatus = PaymentStatus.fail;
                    });
                  }
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

//   Future<void> successApi() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final auth = prefs.getString('authToken');
//     const uri =
//         "https://admin.sherkhanril.com/api/deposit/confirm?secret=bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14";
//     final header = {'Authorization': 'Bearer $auth'};
//     try {
//       final response = await http.post(Uri.parse(uri), headers: header, body: {
//         'secret': 'bd5c49f2-2f73-44d4-8daa-6ff67ab1bc14',
//         'payment_status': 'success',
//         'plan_id': '',
//         'Track': widget.orderNo,
//       });
//       final jsonBody = jsonDecode(response.body);
//       print('123123123123 $jsonBody');

//       if (response.statusCode == 200) {
//         showToast('Payment Successful');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const MyTransactions(),
//           ),
//         );
//       }
//     } catch (error) {
//       showToast(error.toString());
//     }
//   }
// }

class PaymentResult extends StatefulWidget {
  const PaymentResult({Key? key}) : super(key: key);

  @override
  State<PaymentResult> createState() => _PaymentResultState();
}

class _PaymentResultState extends State<PaymentResult> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () {
      showModal(
          context: context,
          configuration: const FadeScaleTransitionConfiguration(
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 100),
          ),
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
              ),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: CustomColors.orange,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'your order status is pending',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationPage(
                            currentTab: 2,
                          ),
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: CustomColors.orange,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
