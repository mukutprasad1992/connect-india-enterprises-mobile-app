import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/modules/admin/admin_dashboard.dart';
import '/services/loginApi_service.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String errorMessage = '';
  final _apiService = ApiService();

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

  // ✅ Login using backend API
  Future<bool> _login(BuildContext context) async {
    final response = await _apiService.loginUser(email, password);

    if (response != null && response['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response['token']);
      await prefs.setString('user_email', email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
      return true;
    } else {
      errorMessage = 'Invalid email or password';
      return false;
    }
  }
}
