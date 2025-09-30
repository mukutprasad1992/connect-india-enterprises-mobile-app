import 'package:flutter/material.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  // Variables and controllers go here

  @override
  void initState() {
    super.initState();
    // Initialize data or controllers here
  }

  @override
  void dispose() {
    // Dispose controllers or streams here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insurance Page"),
      ),
      body: const Center(
        child: Text("This is the Insurance Page"),
      ),
    );
  }
}





