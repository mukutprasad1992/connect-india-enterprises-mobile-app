// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleSignService {
//   static final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'password'],
//   );

//   static Future<GoogleSignInAccount?> signInWithGoogle() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       return account;
//     } catch (error) {
//       print("Google Sign-In Error: $error");
//       return null;
//     }
//   }

//   static Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }
// }
