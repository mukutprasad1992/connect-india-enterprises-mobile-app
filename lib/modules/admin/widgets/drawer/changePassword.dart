import 'package:flutter/material.dart';
import '/consts/appColors.dart';
import '/controllers/adminController/change_password_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ChangePasswordController _controller = ChangePasswordController();

  @override
  void initState() {
    super.initState();
    _controller.loadSavedPassword(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancel() => Navigator.pop(context);

  Future<void> _handleChangePassword() async {
    if (_controller.formKey.currentState!.validate()) {
      if (!_controller.oldPasswordValid()) {
        _showSnackBar('Old password is incorrect');
        return;
      }

      if (!_controller.passwordsMatch()) {
        _showSnackBar('Passwords do not match');
        return;
      }

      await _controller
          .updatePassword(_controller.newPasswordController.text.trim());

      _showSnackBar('Password changed successfully', isSuccess: true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _controller.clearFields();
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    bool obscure,
    VoidCallback onToggle,
  ) {
    final hasAsterisk = label.contains('*');
    final parts = hasAsterisk ? label.split('*') : [label];

    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 18),
      label: RichText(
        text: TextSpan(
          text: parts[0],
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: hasAsterisk
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ]
              : [],
        ),
      ),
      isDense: true,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey.shade600,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _inputDecoration(label, icon,obscure,onToggle),
      validator: validator,
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _cancel,
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleChangePassword,
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: const Text('Update', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.SubmitButtom,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 600.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > maxWidth ? maxWidth : screenWidth * 0.92;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: formWidth,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6)),
              ],
            ),
            child: Form(
              key: _controller.formKey,
              child: Column(
                children: [
                  _buildPasswordField(
                      label: 'Current Password*',
                      icon: Icons.lock,
                      controller: _controller.oldPasswordController,
                      obscure: _controller.obscureOld,
                      onToggle: () =>
                          _controller.toggleObscureOld(() => setState(() {})),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Current password is required';
                        if (!_controller.oldPasswordValid())
                          return 'Current password is incorrect';
                        return null;
                      }),
                  const SizedBox(height: 18),
                  _buildPasswordField(
                      label: 'New Password*',
                      icon: Icons.lock,
                      controller: _controller.newPasswordController,
                      obscure: _controller.obscureNew,
                      onToggle: () =>
                          _controller.toggleObscureNew(() => setState(() {})),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'New password is required';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        if (RegExp(r'[.,\/?*%]').hasMatch(value)) {
                          return 'Password cannot contain ., / ? * %';
                        }
                        return null;
                      }),
                  const SizedBox(height: 18),
                  _buildPasswordField(
                      label: 'Confirm Password*',
                      icon: Icons.lock,
                      controller: _controller.confirmPasswordController,
                      obscure: _controller.obscureConfirm,
                      onToggle: () => _controller
                          .toggleObscureConfirm(() => setState(() {})),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please confirm password';
                        if (value != _controller.newPasswordController.text)
                          return 'Passwords do not match';
                        return null;
                      }),
                  const SizedBox(height: 30),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '/controllers/adminController/change_password_controller.dart';
// import '/consts/appColors.dart';
// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final ChangePasswordController _controller = ChangePasswordController();

//   @override
//   void initState() {
//     super.initState();
//     _controller.loadSavedPassword(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _handleChangePassword() async {
//     if (_controller.formKey.currentState!.validate()) {
//       if (!_controller.oldPasswordValid()) {
//         _showSnackBar('Old password is incorrect');
//         return;
//       }

//       if (!_controller.passwordsMatch()) {
//         _showSnackBar('New and Confirm Password do not match');
//         return;
//       }

//       await _controller
//           .updatePassword(_controller.newPasswordController.text.trim());

//       _showSnackBar('Password changed successfully', isSuccess: true);
//       await Future.delayed(const Duration(seconds: 2));
//       setState(() {
//         _controller.clearFields();
//       });
//     }
//   }

//   void _showSnackBar(String message, {bool isSuccess = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : null,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text("Change Password",style:TextStyle(color:Colors.white)),
//         backgroundColor: AppColors.background,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _controller.formKey,
//           child: Column(
//             children: [
//               _buildPasswordField(
//                 controller: _controller.oldPasswordController,
//                 label: 'Current Password',
//                 icon: Icons.lock,
//                 obscure: _controller.obscureOld,
//                 toggle: () =>
//                     _controller.toggleObscureOld(() => setState(() {})),
//               ),
//               const SizedBox(height: 16),
//               _buildPasswordField(
//                 controller: _controller.newPasswordController,
//                 label: 'New Password',
//                 icon: Icons.lock,
//                 obscure: _controller.obscureNew,
//                 toggle: () =>
//                     _controller.toggleObscureNew(() => setState(() {})),
//                 validator: (value) {
//                   if (value == null || value.length < 6) {
//                     return 'New password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               _buildPasswordField(
//                 controller: _controller.confirmPasswordController,
//                 label: 'Confirm Password',
//                 icon: Icons.lock,
//                 obscure: _controller.obscureConfirm,
//                 toggle: () =>
//                     _controller.toggleObscureConfirm(() => setState(() {})),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm password';
//                   }
//                   if (value != _controller.newPasswordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () async {
//                   final confirmed = await showDialog<bool>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: const Text('Confirm Password Change'),
//                         content: const Text(
//                             'Are you sure you want to change your password?'),
//                         actions: [
//                           TextButton(
//                             child: const Text('Cancel'),
//                             onPressed: () => Navigator.of(context).pop(false),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:AppColors.background,
//                             ),
//                             child: const Text('Confirm',style:TextStyle(color:Colors.white)),
//                             onPressed: () => Navigator.of(context).pop(true),
//                           ),
//                         ],
//                       );
//                     },
//                   );

//                   if (confirmed == true) {
//                     await _handleChangePassword();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.background,
//                 ),
//                 child: const Text("Change Password",style:TextStyle(color:Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscure,
//     required VoidCallback toggle,
//     String? Function(String?)? validator,
//     IconData? icon,
//   }) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         inputDecorationTheme: const InputDecorationTheme(
//           errorStyle: TextStyle(color: Colors.red), // Set your desired color
//         ),
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: icon != null ? Icon(icon) : null,
//           border: const OutlineInputBorder(),
//           //errorStyle: TextStyle(color: Colors.red),
//           suffixIcon: IconButton(
//             icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
//             onPressed: toggle,
//           ),
//         ),
//         validator: validator ??
//             (value) =>
//                 value == null || value.isEmpty ? 'Please enter $label' : null,
//       ),
//     );
//   }
// }