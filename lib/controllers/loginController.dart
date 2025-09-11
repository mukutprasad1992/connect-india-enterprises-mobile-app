import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/services/authServices/loginApi_service.dart';
import '/controllers/authController.dart'; 
import '/consts/appConstants.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String errorMessage = '';
  final apiService = ApiService();

  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!emailRegExp.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  bool trySubmit(VoidCallback refreshUI, BuildContext context) {
    final isValid = formKey.currentState?.validate() ?? false;
    if (isValid) {
      formKey.currentState?.save();
      _login(context).then((success) {
        if (!success) refreshUI();
      });
      return true;
    }
    return false;
  }

  /// ✅ Login using backend API
  
  Future<bool> _login(BuildContext context) async {
    try {
      final response = await apiService.loginUser(email, password);

      if (response != null && response['status'] == true) {
        final data = response['data'];
        final prefs = await SharedPreferences.getInstance();

        // Save essential login data

        await prefs.setString('user_email', data['email']);
        await prefs.setString(KEYTOKEN, data['accessToken']);
        await prefs.setBool(KEYLOGIN, true);
        await prefs.setInt(KEYROLEID, data['roleId']);

        // Optional: store extra profile info if needed
        // await prefs.setString('firstName', data['firstName']);
        // await prefs.setString('lastName', data['lastName']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Great! You've logged in successfully."),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate using AuthController for consistency
        AuthController.checkLoginStatus(context);

        return true;
      } else {
        errorMessage = response?['message'] ?? 'Invalid email or password';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
      );
      return false;
    }
  }
}
