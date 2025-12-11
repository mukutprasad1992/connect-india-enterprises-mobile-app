// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:myapp/views/drawer/image_uploader.dart';
// import 'package:flutter/material.dart';

// class HeaderDrawerController extends GetxController {
//   final box = GetStorage();

//   RxString imagePath = "".obs;
//   RxString myProfile = "Guest User".obs;
//   RxString userEmail = "guest@example.com".obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadUserData();
//   }

//   /// Load stored data
//   void loadUserData() {
//     imagePath.value = box.read('profile_image') ?? "";

//     final firstName = box.read('firstName') ?? "Guest";
//     final lastName = box.read('lastName') ?? "User";

//     myProfile.value = "$firstName $lastName";
//     userEmail.value = box.read('user_email') ?? "guest@example.com";
//   }

//   /// Pick image (fixed signature)
//   void pickImage(ImageSource source) {
//     ProfileImageUploader.pickImage(
//       source: source,
//       onImagePicked: (path) {
//         imagePath.value = path;
//         box.write('profile_image', path);
//       },
//     );
//   }

//   void removeImage() {
//     ProfileImageUploader.removeImage(
//       onImageRemoved: () {
//         imagePath.value = "";
//         box.remove('profile_image');
//       },
//     );
//   }

//   bool get hasImage =>
//       imagePath.value.isNotEmpty && File(imagePath.value).existsSync();
// }
