import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        backgroundColor: const Color.fromARGB(255, 149, 18, 18),
      ),
      body: const Center(
        child: Text('Frequently Asked Questions will appear here.'),
      ),
    );
  }
}
