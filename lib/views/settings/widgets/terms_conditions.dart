import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: const Color.fromARGB(255, 149, 18, 18),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Terms and conditions content goes here...'),
      ),
    );
  }
}
