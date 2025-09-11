import 'package:flutter/material.dart';
import 'services/authServices/app_link_handler.dart';
import 'routes/myapp_routes.dart';

import 'package:timeago/timeago.dart' as timeago;

void main() {
  timeago.setLocaleMessages('en', timeago.EnMessages());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late DeepLinkHandler _deepLinkHandler;

  @override
  void initState() {
    super.initState();
    _deepLinkHandler = DeepLinkHandler(navigatorKey);
    _deepLinkHandler.init();
  }

  @override
  void dispose() {
    _deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Connect India Enterprises',
      initialRoute: MyAppRoutes.splash,
      onGenerateRoute: MyAppRoutes.generateRoute,
    );
  }
}
