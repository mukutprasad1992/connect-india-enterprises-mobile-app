// import 'package:flutter/material.dart';
// import '/controllers/loginController.dart';
// import '/views/signup/signup_page.dart';
// import 'forgotPassword.dart';

// import '/consts/appColors.dart';
// import '/consts/app_text_styles.dart';
// import '/consts/appIconSize.dart';

// //import '/services/google_sign_service.dart';
// //import '/services/facebook_sign_service.dart';


// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final LoginController controller = LoginController();
//   bool obscurePassword = true;
//   bool rememberMe = true;
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 27),
//         child: ListView(
//           children: [
//             const SizedBox(height: 80),
//             const Text("Hi, Welcome Back! 👋", style: AppTextStyles.heading),
//             const SizedBox(height: 10),
//             const Text("Hello again, you’ve been missed!",
//                 style: AppTextStyles.subHeading),
//             const SizedBox(height: 32),

//             /// FORM
//             Form(
//               key: controller.formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildLabel("Email"),
//                   TextFormField(
//                     decoration: _inputDecoration("Enter your email"),
//                     validator: controller.validateEmail,
//                     onSaved: (v) => controller.email = v!,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildLabel("Password"),
//                   TextFormField(
//                     obscureText: obscurePassword,
//                     decoration: _inputDecoration("Enter your password").copyWith(
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () =>
//                             setState(() => obscurePassword = !obscurePassword),
//                       ),
//                     ),
//                     validator: controller.validatePassword,
//                     onSaved: (v) => controller.password = v!,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 12),
//             _buildOptionsRow(),
//             const SizedBox(height: 20),

//             /// 🔐 Login Button
//             SizedBox(
//               height: AppSizes.inputHeight,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () =>
//                     controller.trySubmit(() => setState(() {}), context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(AppSizes.radius),
//                   ),
//                 ),
//                 child: const Text("Login", style: AppTextStyles.button),
//               ),
//             ),

//             if (controller.errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Text(controller.errorMessage,
//                     style: AppTextStyles.error),
//               ),

//             const SizedBox(height: 24),
//             _buildDivider("Or with"),
//             const SizedBox(height: 24),

//             /// 🔵 Google Sign-In
//             SizedBox(
//               height: AppSizes.inputHeight,
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: () async {
//                   //final user = await GoogleSignService.signInWithGoogle();
//                   // if (user != null) {
//                   //   ScaffoldMessenger.of(context).showSnackBar(
//                   //     SnackBar(content: Text('Welcome ${user.displayName}!')),
//                   //   );
//                   //   // TODO: Handle backend login / navigation
//                   // }
//                 },
//                 icon: Image.asset('assets/images/G-logo.png',
//                     height: 18, width: 18),
//                 label: const Text(
//                   "Sign in with Google",
//                   style: AppTextStyles.hint,
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(AppSizes.radius)),
//                   side: const BorderSide(color: AppColors.borderGrey),
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// 🔵 Facebook Login
//             SizedBox(
//               height: AppSizes.inputHeight,
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: () async {
//                   //final userData = await FacebookSignService.signInWithFacebook();
//                   // if (userData != null) {
//                   //   ScaffoldMessenger.of(context).showSnackBar(
//                   //     SnackBar(content: Text('Welcome ${userData['name']}!')),
//                   //   );
//                   //   // TODO: Handle backend
//                   // }
//                 },
//                 icon: Image.asset('assets/images/facebook.png',
//                     height: 26, width: 26),
//                 label: const Text(
//                   "Sign in with Facebook",
//                   style: AppTextStyles.hint,
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(AppSizes.radius)),
//                   side: const BorderSide(color: AppColors.borderGrey),
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             /// Signup link
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don’t have an account? ",
//                     style: AppTextStyles.subHeading),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => const SignupPage()),
//                     );
//                   },
//                   child: const Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String label) {
//     return RichText(
//       text: TextSpan(
//         text: label,
//         style: AppTextStyles.label,
//         children: const [
//           TextSpan(text: ' *', style: TextStyle(color: AppColors.accent)),
//         ],
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: AppTextStyles.hint,
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppSizes.radius),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppSizes.radius),
//         borderSide: const BorderSide(color: AppColors.borderGrey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppSizes.radius),
//         borderSide: const BorderSide(color: AppColors.primary),
//       ),
//     );
//   }

//   Widget _buildDivider(String text) {
//     return Row(
//       children: [
//         const Expanded(child: Divider(color: AppColors.dividerGrey)),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Text(text, style: AppTextStyles.subHeading),
//         ),
//         const Expanded(child: Divider(color: AppColors.dividerGrey)),
//       ],
//     );
//   }

//   Widget _buildOptionsRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Checkbox(
//               value: rememberMe,
//               onChanged: (value) => setState(() => rememberMe = value ?? true),
//             ),
//             const Text("Remember Me", style: AppTextStyles.hint),
//           ],
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ForgetPasswordPage()),
//             );
//           },
//           child: const Text("Forgot Password?",
//               style: TextStyle(
//                   color: AppColors.accent,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600)),
//         ),
//       ],
//     );
//   }
// }

// old code


import 'package:flutter/material.dart';
import '/controllers/loginController.dart';
import '/views/signup/signup_page.dart';
import 'forgotPassword.dart';
//import '/services/googleSignService.dart';
//import '/services/facebookSignService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = LoginController();
  bool obscurePassword = true;
  bool rememberMe = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            const Text(
              "Hi, Welcome Back! 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Hello again, you’ve been missed!",
              style: TextStyle(fontSize: 14, color: Color(0xFF999EA1)),
            ),
            const SizedBox(height: 32),

            /// 👇 Login Form
            Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Email',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.deepPurple,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: _inputDecoration("Enter your email"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: controller.validateEmail,
                    onSaved: (value) => controller.email = value!,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      text: 'Password',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.deepPurple,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    obscureText: obscurePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _inputDecoration("Enter your password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                    validator: controller.validatePassword,
                    onSaved: (value) => controller.password = value!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionsRow(),
            const SizedBox(height: 20),

            /// 🔐 Login Button
            SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    controller.trySubmit(() => setState(() {}), context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ✅ Error message
            if (controller.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  controller.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            const SizedBox(height: 24),

            /// ➖ Divider
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or with", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            /// 🔵 Google Sign-In Button
            SizedBox(
              height: 42,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/images/G-logo.png', height: 18, width: 18),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  side: const BorderSide(color: Colors.grey),
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or with", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            /// 🔵 Facebook Sign-In Button
            SizedBox(
              height: 42,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/images/facebook.png', height: 30, width: 30),
                label: const Text(
                  "Sign in with Facebook",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  side: const BorderSide(color: Colors.grey),
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don’t have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        fontFamily: 'Manrope',
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) =>
                  setState(() => rememberMe = value ?? true),
            ),
            const Text(
              "Remember Me",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgetPasswordPage()),
            );
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}


