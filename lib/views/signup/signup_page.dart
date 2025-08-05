// import 'package:flutter/material.dart';
// import '/views/login/login_page.dart';
// import '/controllers/adminController/signupController.dart';
// import 'package:flutter/services.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final SignupController controller = SignupController();

//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     bool obscure = false,
//     required FormFieldValidator<String> validator,
//     required FormFieldSetter<String> onSaved,
//     Widget? suffixIcon,
//     TextInputType keyboardType = TextInputType.text,
//     ValueChanged<String>? onChanged,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return TextFormField(
//       obscureText: obscure,
//       keyboardType: keyboardType,
//       validator: validator,
//       onSaved: onSaved,
//       onChanged: onChanged,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       inputFormatters: inputFormatters,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Color(0xFF5D1F1F)),
//         floatingLabelStyle: const TextStyle(color: Color(0xFF5D1F1F)),
//         prefixIcon: Icon(icon, color: Colors.brown),
//         suffixIcon: suffixIcon,
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: Colors.brown, width: 2),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(color: Colors.brown),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final maxWidth = screenWidth > 500 ? 450 : screenWidth * 0.9;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       Image.asset('assets/images/logo.png', height: 40),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'CONNECT INDIA',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Text(
//                         'ENTERPRISES',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 151, 24, 14),
//                           fontSize: 15,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black13,
//                           blurRadius: 13,
//                           offset: Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Form(
//                       key: controller.formKey,
//                       child: Column(
//                         children: [
//                           _buildTextField(
//                             label: 'Email Address',
//                             icon: Icons.email,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Enter email';
//                               }
//                               if (!controller.emailRegExp.hasMatch(value)) {
//                                 return 'Enter a valid email';
//                               }
//                               return null;
//                             },
//                             onSaved: (val) => controller.email = val!,
//                           ),
//                           const SizedBox(height: 16),
//                           _buildTextField(
//                             label: 'Phone Number',
//                             icon: Icons.phone,
//                             keyboardType: TextInputType.phone,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Enter number';
//                               }
//                               if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                                 return 'Enter valid 10-digit number';
//                               }
//                               return null;
//                             },
//                             onSaved: (val) => controller.phone = val!,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(10),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           _buildTextField(
//                             label: 'Password',
//                             icon: Icons.lock,
//                             obscure: controller.obscurePassword,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 controller.obscurePassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.brown,
//                               ),
//                               onPressed: () =>
//                                   controller.togglePasswordVisibility(() => setState(() {})),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Enter password';
//                               }
//                               if (!controller.passwordRegExp.hasMatch(value)) {
//                                 return 'Use A-Z, a-z, 0-9 & special character';
//                               }
//                               return null;
//                             },
//                             onSaved: (val) => controller.password = val!,
//                             onChanged: (val) => controller.enteredPassword = val,
//                           ),
//                           const SizedBox(height: 16),
//                           _buildTextField(
//                             label: 'Confirm Password',
//                             icon: Icons.lock_outline,
//                             obscure: controller.obscureConfirm,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 controller.obscureConfirm
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.brown,
//                               ),
//                               onPressed: () =>
//                                   controller.toggleConfirmVisibility(() => setState(() {})),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Confirm your password';
//                               }
//                               if (value != controller.enteredPassword) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                             onSaved: (val) => controller.confirmPassword = val!,
//                           ),
//                           const SizedBox(height: 24),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF5D1F1F),
//                                 padding: const EdgeInsets.symmetric(vertical: 14,horizontal:10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                               onPressed: () =>
//                                   controller.submitForm(context, () => setState(() {})),
//                               child: const Text(
//                                 'Sign Up',
//                                 style: TextStyle(fontSize: 16, color: Colors.white),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const LoginPage()),
//                               );
//                             },
//                             child: Text.rich(
//                               TextSpan(
//                                 text: "Already have an account? ",
//                                 style: const TextStyle(
//                                   color: Colors.black47,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 children: const [
//                                   TextSpan(
//                                     text: "Login here",
//                                     style: TextStyle(
//                                         color: Colors.brown,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/adminController/signupController.dart';
import '/views/login/login_page.dart';
//import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController controller = SignupController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenWidth * 0.1),
                Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Connect, manage, and grow with Connect India Enterprises!",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                // Email
                RichText(
                  text: TextSpan(
                    text: 'Email',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.deepPurple,
                    ),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 4),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!controller.emailRegExp.hasMatch(v))
                      return 'Enter valid email';
                    return null;
                  },
                  onSaved: (v) => controller.email = v!.trim(),
                ),
                const SizedBox(height: 15),

                // Phone Number
                RichText(
                  text: TextSpan(
                    text: 'Phone Number',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.deepPurple,
                    ),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                //const SizedBox(height: 4),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("+91",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Text("|", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    hintText: "Enter your phone number",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Phone number is required';
                    if (!RegExp(r'^\d{10}$').hasMatch(v))
                      return 'Enter valid 10-digit number';
                    return null;
                  },
                  onSaved: (v) => controller.phone = v!,
                ),
                const SizedBox(height: 15),

                // Password
                RichText(
                  text: TextSpan(
                    text: 'Password',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.deepPurple,
                    ),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 4),
                TextFormField(
                  obscureText: controller.obscurePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => controller
                          .togglePasswordVisibility(() => setState(() {})),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (!controller.passwordRegExp.hasMatch(v))
                      return 'Use A-Z, a-z, 0-9 & special character';
                    return null;
                  },
                  onChanged: (v) => controller.enteredPassword = v,
                  onSaved: (v) => controller.password = v!,
                ),
                const SizedBox(height: 15),

                // Confirm Password
                RichText(
                  text: TextSpan(
                    text: 'Confirm Password',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.deepPurple,
                    ),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 4),
                TextFormField(
                  obscureText: controller.obscureConfirm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Re-enter your password",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => controller
                          .toggleConfirmVisibility(() => setState(() {})),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Confirm password is required';
                    if (v != controller.enteredPassword)
                      return 'Passwords do not match';
                    return null;
                  },
                  onSaved: (v) => controller.confirmPassword = v!,
                ),

                const SizedBox(height: 40),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 41,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.submitForm(context, () => setState(() {})),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:
                          Text("Or With", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 24),

                // Google Button
                Center(
                  child: SizedBox(
                    width: 320,
                    child: OutlinedButton(
                      onPressed: () {
                        // controller.handleGoogleSignIn(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 16),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/G-logo.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text("Sign in with Google",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Login Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
