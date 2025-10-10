// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class FacebookSignService {
//   static Future<Map<String, dynamic>?> signInWithFacebook() async {
//     try {
//       final LoginResult result = await FacebookAuth.instance.login();

//       if (result.status == LoginStatus.success) {
//         final userData = await FacebookAuth.instance.getUserData();
//         return userData;
//       } else {
//         print("Facebook login failed: ${result.message}");
//         return null;
//       }
//     } catch (error) {
//       print("Facebook Sign-In Error: $error");
//       return null;
//     }
//   }

//   static Future<void> signOut() async {
//     await FacebookAuth.instance.logOut();
//   }
// }
