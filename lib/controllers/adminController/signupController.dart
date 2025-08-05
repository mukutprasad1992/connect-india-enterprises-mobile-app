import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/views/login/login_page.dart';
import '/controllers/adminController/myProfileController.dart';

class SignupController {
  final formKey = GlobalKey<FormState>();

  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String enteredPassword = '';

  bool obscurePassword = true;
  bool obscureConfirm = true;

  final RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  final RegExp passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  Future<void> submitForm(BuildContext context, Function refreshUI) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final prefs = await SharedPreferences.getInstance();

      // ✅ Check if this is a different user
      String? previousEmail = prefs.getString('currentUserEmail');

      if (previousEmail != email) {
        // 🧹 Clear old profile if this is a new signup
        final controller = ProfileController();
        await controller.clearOldUserProfileData(
          email: email,
          mobile: phone,
        );
      }

      // ✅ Save new user credentials
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setString('phone', phone);
      await prefs.setString('mobile', phone); // required for MyProfilePage
      await prefs.setString('currentUserEmail', email); // track active user

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Welcome! You\'ve signed up successfully.'),

          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      refreshUI();
    }
  }

  void togglePasswordVisibility(Function refreshUI) {
    obscurePassword = !obscurePassword;
    refreshUI();
  }

  void toggleConfirmVisibility(Function refreshUI) {
    obscureConfirm = !obscureConfirm;
    refreshUI();
  }
}
