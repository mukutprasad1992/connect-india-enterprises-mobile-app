// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class GoogleSignInService {
//   static final _googleSignIn = GoogleSignIn();

//   static Future<void> signInWithGoogle() async {
//     try {
//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return; 

//       final email = googleUser.email;
//       final name = googleUser.displayName;
//       final photoUrl = googleUser.photoUrl;

//       final response = await http.post(
//         Uri.parse('https://your-backend-api.com/google-login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'name': name,
//           'profile_picture': photoUrl,
//           'login_type': 'google',
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         print('Login success: ${data['message']}');
//       } else {
//         print('Server error: ${response.body}');
//       }
//     } catch (e) {
//       print("Google Sign-In error: $e");
//     }
//   }
// }
