import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  UserPrefs._internal();
  static final UserPrefs instance = UserPrefs._internal();

  // ValueNotifiers that widgets can listen to
  final ValueNotifier<String?> profileImg = ValueNotifier<String?>(null);
  final ValueNotifier<String?> firstName = ValueNotifier<String?>(null);

  // Call once when app starts (or before you need data)
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    profileImg.value = prefs.getString('profileImg');
    firstName.value = prefs.getString('firstName');
  }

  // Update both prefs and notifier
  Future<void> setProfileImg(String? url) async {
    final prefs = await SharedPreferences.getInstance();
    if (url == null || url.isEmpty) {
      await prefs.remove('profileImg');
      profileImg.value = null;
    } else {
      await prefs.setString('profileImg', url);
      profileImg.value = url;
    }
  }

  Future<void> setFirstName(String? name) async {
    final prefs = await SharedPreferences.getInstance();
    if (name == null || name.isEmpty) {
      await prefs.remove('firstName');
      firstName.value = null;
    } else {
      await prefs.setString('firstName', name);
      firstName.value = name;
    }
  }
}
