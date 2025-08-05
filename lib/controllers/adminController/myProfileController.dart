import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final representativeController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final dobController = TextEditingController();
  final vendorController = TextEditingController();

  bool isProfileEmpty = true;

  /// Clear previous profile data, keep email and mobile only
  Future<void> clearOldUserProfileData({
    required String email,
    required String mobile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved profile data

    await prefs.setString('email', email);
    await prefs.setString('mobile', mobile);

    emailController.text = email;
    mobileController.text = mobile;

    // Clear other fields
    resetProfileFields();

    isProfileEmpty = true;
  }

  /// Reset all controllers (doesn't save)
  void resetProfileFields() {
    firstNameController.clear();
    lastNameController.clear();
    businessNameController.clear();
    representativeController.clear();
    addressController.clear();
    pincodeController.clear();
    dobController.clear();
    vendorController.clear();
  }

  /// Load profile from SharedPreferences
  Future<void> loadProfileData(VoidCallback onComplete) async {
    final prefs = await SharedPreferences.getInstance();

    emailController.text = prefs.getString('email') ?? '';
    mobileController.text = prefs.getString('mobile') ?? '';
    firstNameController.text = prefs.getString('firstName') ?? '';
    lastNameController.text = prefs.getString('lastName') ?? '';
    businessNameController.text = prefs.getString('businessName') ?? '';
    representativeController.text = prefs.getString('representative') ?? '';
    addressController.text = prefs.getString('address') ?? '';
    pincodeController.text = prefs.getString('pincode') ?? '';
    dobController.text = prefs.getString('dob') ?? '';
    vendorController.text = prefs.getString('vendor') ?? '';

    isProfileEmpty = [
      firstNameController,
      lastNameController,
      businessNameController,
      representativeController,
      addressController,
      pincodeController,
      dobController,
      vendorController,
    ].every((c) => c.text.isEmpty);

    onComplete();
  }

  /// Save profile to SharedPreferences
  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
    await prefs.setString('businessName', businessNameController.text);
    await prefs.setString('representative', representativeController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('mobile', mobileController.text);
    await prefs.setString('address', addressController.text);
    await prefs.setString('pincode', pincodeController.text);
    await prefs.setString('dob', dobController.text);
    await prefs.setString('vendor', vendorController.text);
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    businessNameController.dispose();
    representativeController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    dobController.dispose();
    vendorController.dispose();
  }
}
