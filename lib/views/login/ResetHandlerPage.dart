// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'dart:async';

// class ResetHandlerPage extends StatefulWidget {
//   const ResetHandlerPage({super.key});

//   @override
//   State<ResetHandlerPage> createState() => _ResetHandlerPageState();
// }

// class _ResetHandlerPageState extends State<ResetHandlerPage> {
//   StreamSubscription? _sub;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     _handleIncomingLinks();
//   }

//   void _handleIncomingLinks() {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri != null && uri.scheme == 'myapp') {
//         setState(() {
//           token = uri.queryParameters['token'];
//         });

//         // Navigate to reset password form
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResetPasswordPage(token: token ?? ''),
//           ),
//         );
//       }
//     }, onError: (err) {
//       print('Link error: $err');
//     });
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("Waiting for reset link...")),
//     );
//   }
// }

// class ResetPasswordPage extends StatelessWidget {
//   final String token;

//   const ResetPasswordPage({super.key, required this.token});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: Center(child: Text("Reset Token: $token")),
//     );
//   }
// }
