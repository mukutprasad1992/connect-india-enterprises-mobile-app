import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/authServices/changePassApi_service.dart';

class ChangePasswordController {
  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ApiService apiService = ApiService();

  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  /// Loads saved password (optional for UI purposes only)
  String? savedPassword;
  Future<void> loadSavedPassword(VoidCallback onComplete) async {
    final prefs = await SharedPreferences.getInstance();
    savedPassword = prefs.getString('password');
    onComplete();
  }

  /// Toggle password visibility
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

  /// Call API to change password
  Future<bool> updatePasswordFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // token saved at login

    if (token == null || token.isEmpty) {
      return false;
    }

    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;

    final response =
        await apiService.changePassword(token, oldPassword, newPassword);

    if (response != null &&
        (response['statusCode'] == 200 || response['success'] == true)) {
      // Update password locally only if API success
      await prefs.setString('password', newPassword);
      return true;
    } else {
      return false;
    }
  }

  /// Dispose controllers
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  /// Clear input fields
  void clearFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  /// Validation helpers
  bool passwordsMatch() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  bool oldPasswordValid() {
    // Optional: only for UI; backend should do final validation
    return oldPasswordController.text.isNotEmpty;
  }

  bool isNewPasswordValid() {
    final value = newPasswordController.text;
    final disallowed = RegExp(r'[.,\/?*%]');
    return value.length >= 6 && !disallowed.hasMatch(value);
  }
}
