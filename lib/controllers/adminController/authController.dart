import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/modules/admin/admin_dashboard.dart';
import '/views/login/login_page.dart';

const String KEYLOGIN = 'login';

class AuthController {
  static Future<void> checkLoginStatus(BuildContext context) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final bool isLoggedIn = sharedPref.getBool(KEYLOGIN) ?? false;

    //await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const DashboardPage() : const LoginPage(),
      ),
    );
  }
}
