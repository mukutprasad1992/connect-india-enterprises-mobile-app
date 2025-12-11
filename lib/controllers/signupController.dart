import 'package:flutter/material.dart';
import 'package:myapp/views/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/authServices/registerApi.dart';
import '/services/authServices/loginApi_service.dart';
import '/controllers/authController.dart';
import '/consts/appConstants.dart';

class SignupController {
  final formKey = GlobalKey<FormState>();

  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String enteredPassword = '';

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
    if (value != enteredPassword) return 'Passwords do not match';
    return null;
  }
  
  /// Submit signup form


Future<void> submitForm(BuildContext context, Function refreshUI) async {
    // 1. Validate
    if (!formKey.currentState!.validate()) {
      refreshUI();
      return;
    }

    // 2. Save form fields (ensure your TextFormFields have onSaved handlers)
    formKey.currentState!.save();

    // 3. Trim inputs defensively
    final trimmedEmail = email.trim();
    final trimmedPhone = phone.trim();
    final trimmedPassword = password.trim();

    // 4. Call register API (do NOT pass optional fields unless non-empty)
    Map<String, dynamic>? registerResponse;
    try {
      registerResponse = await RegisterApi.registerUser(
        email: trimmedEmail,
        mobileNo: trimmedPhone,
        roleId: 3,
        password: trimmedPassword,
        status: "Enable",
        // omit businessName/vendorCode/address here unless you have values
      );
    } catch (e) {
      // unexpected error from RegisterApi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Registration error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // 5. Debug: print full response to inspect server message
    print('Register response: $registerResponse');

    // 6. Handle response
    if (registerResponse != null && registerResponse['status'] == true) {
      // success -> show message and redirect to Login page (no auto-login)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please log in to continue.'),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: small delay so user sees the snackbar (remove if you prefer immediate navigation)
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to Login page (replace with your actual LoginPage widget)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

      return;
    } else {
      // registration failed -> show server message and stop
      final msg =
          (registerResponse != null && registerResponse['message'] != null)
              ? registerResponse['message'].toString()
              : 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}

