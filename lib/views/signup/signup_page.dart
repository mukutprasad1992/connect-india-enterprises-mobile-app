import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/signupController.dart';
import '/views/login/login_page.dart';
//import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController controller = SignupController();
  bool _isLoading = false;

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
                  decoration: _inputDecoration("Enter your email"),
                  // hintText: "Enter your email",
                  // isDense: true,
                  // contentPadding:
                  //     EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(6),
                  //   borderSide: BorderSide(color: Colors.grey.shade400),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(6),
                  //   borderSide: const BorderSide(color: Colors.deepPurple),
                  // ),
                  // errorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(6),
                  //   borderSide: const BorderSide(color: Colors.deepPurple),
                  // ),
                  // focusedErrorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(6),
                  //   borderSide: const BorderSide(color: Colors.deepPurple),
                  // ),
                  //),
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
                  // style: const TextStyle(
                  //   fontFamily: 'Manrope',
                  //   fontWeight: FontWeight.w600,
                  //   fontSize: 13,
                  // ),
                  decoration:
                      _inputDecoration("Enter your phone number").copyWith(
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
                    // hintText: "Enter your phone number",
                    // isDense: true,
                    // contentPadding: const EdgeInsets.symmetric(
                    //     horizontal: 13, vertical: 10),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: BorderSide(color: Colors.grey.shade400),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
                    // errorBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
                    // focusedErrorBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
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
                  // style: const TextStyle(
                  //     fontFamily: 'Manrope',
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 13),
                  decoration: _inputDecoration("Enter your password").copyWith(
                    // hintText: "Enter your password",
                    // isDense: true,
                    // contentPadding: const EdgeInsets.symmetric(
                    //     horizontal: 13, vertical: 10),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: BorderSide(color: Colors.grey.shade400),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
                    // errorBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
                    // focusedErrorBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
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
                  // style: const TextStyle(
                  //   fontFamily: 'Manrope',
                  //   fontWeight: FontWeight.w600,
                  //   fontSize: 13
                  // ),
                  decoration:
                      _inputDecoration("Re-enter your password").copyWith(
                    // hintText: "Re-enter your password",
                    // isDense: true,
                    // contentPadding: const EdgeInsets.symmetric(
                    //     horizontal: 13, vertical: 10),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: BorderSide(color: Colors.grey.shade400),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
                    // errorBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
                    // focusedErrorBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(6),
                    //   borderSide: const BorderSide(color: Colors.deepPurple),
                    // ),
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
                  //onChanged: (v) => controller.enteredPassword = v,
                ),

                const SizedBox(height: 40),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 41,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);

                            await controller.submitForm(
                                context, () => setState(() {}));

                            setState(() => _isLoading = false);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),

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
                const SizedBox(height: 20),

                // facebook Button
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/images/facebook.png',
                        height: 30, width: 30),
                    label: const Text(
                      "Sign in with facebook",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      side: const BorderSide(color: Colors.grey),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

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
    );
  }
}
