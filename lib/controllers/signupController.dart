import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/services/userServices/registerApi.dart';
import '/services/authServices/loginApi_service.dart';
import '/controllers/authController.dart';
import '/consts/appConstants.dart';
class SignupController {
  final formKey = GlobalKey<FormState>();

  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String enteredPassword = ''; // ✅ for live matching check

  bool obscurePassword = true;
  bool obscureConfirm = true;

  final emailRegExp =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  final passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  /// Toggle password visibility
  void togglePasswordVisibility(Function refreshUI) {
    obscurePassword = !obscurePassword;
    refreshUI();
  }

  /// Toggle confirm password visibility
  void toggleConfirmVisibility(Function refreshUI) {
    obscureConfirm = !obscureConfirm;
    refreshUI();
  }

  /// Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!emailRegExp.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length != 10) return 'Enter a valid 10-digit phone number';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must be 8+ chars, include upper/lowercase, number & special char';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != enteredPassword) return 'Passwords do not match'; // ✅ Live check
    return null;
  }

  /// Submit signup form
  Future<void> submitForm(BuildContext context, Function refreshUI) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // 1️⃣ Register
      final registerResponse = await RegisterApi.registerUser(
        email: email,
        mobileNo: phone,
        roleId: 1,
        password: password,
        status: "Enable",

      );

      if (registerResponse['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Registration successful! Logging you in...'),
            backgroundColor: Colors.green,
          ),
        );

        // 2️⃣ Login
        final loginResponse = await ApiService().loginUser(email, password);

        if (loginResponse != null && loginResponse['status'] == true) {
          final data = loginResponse['data'];
          final prefs = await SharedPreferences.getInstance();

          await prefs.setBool(KEYLOGIN, true);
          await prefs.setString('user_email', data['email']);
          await prefs.setString(KEYTOKEN, data['accessToken']);
          await prefs.setInt(KEYROLEID, data['roleId']);

          // 3️⃣ Redirect based on role
          AuthController.checkLoginStatus(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  loginResponse?['message'] ?? 'Login failed after registration'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // ❌ Registration failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registerResponse['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      refreshUI();
    }
  }
}
