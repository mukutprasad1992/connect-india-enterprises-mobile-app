import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '/modules/admin/admin_dashboard.dart';
import '/modules/vendor/vendor_dashboard.dart';
import '/modules/user/user_dashboard.dart';
import '/views/login/login_page.dart';


class AuthController {

  ///  Check login + token validity
  
  static Future<void> checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Saved values

    final isLoggedIn = prefs.getBool('KEYLOGIN') ?? false;
    final token = prefs.getString('KEYTOKEN');
    final roleId = prefs.getInt('KEYROLEID') ?? 0;

    
    final hasNoToken = token == null || token.isEmpty;
    final isTokenExpired = token != null && JwtDecoder.isExpired(token);

    //  If not logged in, no token, or token expired → logout

    if (!isLoggedIn || hasNoToken || isTokenExpired) {
      _logoutAndRedirect(context, prefs);
      return;
    }

    //  Navigate to dashboard based on role

    switch (roleId) {
      case 1:
        _navigateTo(context, const AdminDashboardPage());
        break;
      case 2:
        _navigateTo(context, const VendorDashboardPage());
        break;
      case 3:
        _navigateTo(context, const UserDashboardPage());
        break;
      default:
        _logoutAndRedirect(context, prefs);
    }
  }

  // Logout + Redirect to login page

  static void _logoutAndRedirect(
      BuildContext context, SharedPreferences prefs) {
    prefs.clear();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }


  static void _navigateTo(BuildContext context, Widget page) {
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
