import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'dart:developer';

class DeepLinkHandler {
  final GlobalKey<NavigatorState> navigatorKey;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  DeepLinkHandler(this.navigatorKey) {
    _appLinks = AppLinks();
  }

  void init() async {
    // Handle cold start
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri);
      }
    } catch (e) {
      log('Error getting initial link: $e');
    }

    // Listen for runtime links
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleLink(uri);
      }
    }, onError: (err) {
      log('Link stream error: $err');
    });
  }

  void _handleLink(Uri uri) {
    log('Received deep link: $uri');

    if (uri.scheme == 'myapp' && uri.host == 'reset-password') {
      navigatorKey.currentState?.pushNamed('/reset-password');
    }
  }

  void dispose() {
    _linkSub?.cancel();
  }
}
