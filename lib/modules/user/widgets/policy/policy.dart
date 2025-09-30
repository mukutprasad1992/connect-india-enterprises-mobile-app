import 'package:flutter/material.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}
class _PolicyPageState extends State<PolicyPage> {
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