import 'package:flutter/material.dart';
import 'package:test_project/Config/common_widgets.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkOrange,
        title: const Text('Contacts Us'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
