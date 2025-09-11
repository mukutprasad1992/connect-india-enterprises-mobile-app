import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'image_uploader.dart';
import '/consts/appColors.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String? imagePath;
  String? myProfile;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// Load profile image and user details from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedImagePath = prefs.getString('profile_image');

    setState(() {
      imagePath = storedImagePath;
      myProfile ="${prefs.getString('firstName') ?? "Guest"} ${prefs.getString('lastName') ?? "User"}";
      userEmail = prefs.getString('user_email') ?? "guest@example.com";
    });
  }

  void pickImage(ImageSource source, BuildContext context) {
    ProfileImageUploader.pickImage(
      source: source,
      context: context,
      onImagePicked: (path) {
        setState(() {
          imagePath = path;
        });
      },
    );
  }

  void removeImage(BuildContext context) {
    ProfileImageUploader.removeImage(
      context: context,
      onImageRemoved: () {
        setState(() {
          imagePath = null;
        });
      },
    );
  }

  void showImageOptions() {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take Photo"),
            onTap: () {
              Navigator.pop(sheetContext);
              pickImage(ImageSource.camera, parentContext);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(sheetContext);
              pickImage(ImageSource.gallery, parentContext);
            },
          ),
          if (ProfileImageUploader.isImageValid(imagePath))
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Remove Photo"),
              onTap: () {
                Navigator.pop(sheetContext);
                removeImage(parentContext);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = ProfileImageUploader.isImageValid(imagePath);
    return Container(
      color: AppColors.background,
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Connect India Enterprises',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: showImageOptions,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        hasImage ? FileImage(File(imagePath!)) : null,
                    child: !hasImage
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.edit, size: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              myProfile ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              userEmail ?? "",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
