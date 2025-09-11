import 'package:flutter/material.dart';
import '/views/login/login_Page.dart';
import '/views/login/resetPassword.dart';
import '/mainSplashScreen.dart';

class MyAppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String resetPassword = '/reset-password';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case resetPassword:
        final uri = Uri.parse(settings.name!);
        final token = uri.queryParameters['token'] ?? '';
        return MaterialPageRoute(builder: (_) => ResetPasswordPage(token: token));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}
