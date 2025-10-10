import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color.fromARGB(255, 149, 18, 18),
      ),
      body: const Center(
        child: Text('Contact us or help info here.'),
      ),
    );
  }
}

