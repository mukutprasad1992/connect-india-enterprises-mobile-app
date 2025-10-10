import 'package:flutter/material.dart';
import '/consts/appColors.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('My Wishlist',style: TextStyle(fontSize: 18, color: Colors.white),),
        backgroundColor:  AppColors.background,
      ),
      body: const Center(
        child: Text(
          'Your wishlist is empty!',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
