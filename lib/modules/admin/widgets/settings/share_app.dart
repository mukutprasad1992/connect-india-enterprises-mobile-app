import 'package:flutter/material.dart';

class ShareAppPage extends StatelessWidget {
  const ShareAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Application'),
        backgroundColor: const Color.fromARGB(255, 149, 18, 18),
      ),
      body: const Center(
        child: Text('Sharing options and referral code go here.'),
      ),
    );
  }
}
