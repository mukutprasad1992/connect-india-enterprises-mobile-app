import 'package:flutter/material.dart';
import 'mainSplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect India Enterprises',
      //home: SplashScreen(),
      home:SplashScreen()
    );
  }
}
