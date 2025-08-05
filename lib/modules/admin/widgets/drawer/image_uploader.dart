import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageUploader {
  /// Pick image from camera/gallery and store path
  static Future<void> pickImage({
    required ImageSource source,
    required BuildContext context,
    required void Function(String path) onImagePicked,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);

    if (pickedFile != null) {
      final path = pickedFile.path;
      final prefs = await SharedPreferences.getInstance();
      final alreadySaved = prefs.getString('profile_image') != null;

      await prefs.setString('profile_image', path);
      onImagePicked(path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              alreadySaved
                  ? 'Profile image updated successfully'
                  : 'Profile image uploaded successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  /// Remove image from SharedPreferences
  static Future<void> removeImage({
    required BuildContext context,
    required VoidCallback onImageRemoved,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
    onImageRemoved();

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile image removed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Check if image path exists and is valid
  static bool isImageValid(String? path) {
    if (path == null) return false;
    return File(path).existsSync();
  }
}
