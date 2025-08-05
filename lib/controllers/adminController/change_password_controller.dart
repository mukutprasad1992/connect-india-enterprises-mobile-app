import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController {
  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  String? savedPassword;

  Future<void> loadSavedPassword(VoidCallback onComplete) async {
    final prefs = await SharedPreferences.getInstance();
    savedPassword = prefs.getString('password');
    onComplete();
  }

  void toggleObscureOld(VoidCallback refresh) {
    obscureOld = !obscureOld;
    refresh();
  }

  void toggleObscureNew(VoidCallback refresh) {
    obscureNew = !obscureNew;
    refresh();
  }

  void toggleObscureConfirm(VoidCallback refresh) {
    obscureConfirm = !obscureConfirm;
    refresh();
  }

  Future<void> updatePassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', newPassword);
  }

  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  void clearFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  bool passwordsMatch() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  bool oldPasswordValid() {
    return oldPasswordController.text == savedPassword;
  }

  bool isNewPasswordValid() {
    final value = newPasswordController.text;
    final disallowed = RegExp(r'[.,\/?*%]');
    return value.length >= 6 && !disallowed.hasMatch(value);
  }
}
