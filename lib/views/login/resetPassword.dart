import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/views/login/login_page.dart';
import '/consts/appColors.dart';


//import '/views/login/resetPassword.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}
class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final RegExp passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  InputDecoration _inputDecoration(String hint, bool isPassword, VoidCallback onToggle, bool obscure) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        fontFamily: 'Manrope',
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: onToggle,
      ),
    );
  }

  Future<void> reset() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.29.161:4000/auth/resetPassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "newPassword": _passwordController.text,
          "token": widget.token,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset successfully")),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Reset failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Password Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          //textDirection: TextDirection.ltr, 
                          text: const TextSpan(
                            text: 'Password',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.deepPurple,
                            ),
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
        
                      /// New Password Field
                      TextFormField(
                        //textAlign: TextAlign.start, 
                        //textDirection: TextDirection.rtl,
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _inputDecoration(
                          "Enter your New password",
                          true,
                          () => setState(() {
                            obscurePassword = !obscurePassword;
                          }),
                          obscurePassword,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (!passwordRegExp.hasMatch(v)) {
                            return 'Use A-Z, a-z, 0-9 & special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
        
                      /// Confirm Password Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          //textDirection: TextDirection.ltr, 
                          text: const TextSpan(
                            text: 'Confirm Password',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.deepPurple,
                            ),
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
        
                      /// Confirm Password Field
                      TextFormField(
                        //textAlign: TextAlign.start, 
                        //textDirection: TextDirection.ltr,
                        controller: _confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _inputDecoration(
                          "Re-enter your New password",
                          true,
                          () => setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          }),
                          obscureConfirmPassword,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
        
                      /// Reset Button
                      SizedBox(
                        height: 41,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: reset,
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
