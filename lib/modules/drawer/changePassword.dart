import 'package:flutter/material.dart';
import '/consts/appColors.dart';
import '/controllers/change_password_controller.dart';

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
      if (!_controller.passwordsMatch()) {
        _showSnackBar('Passwords do not match');
        return;
      }

      bool success = await _controller.updatePasswordFromApi();

      if (success) {
        _showSnackBar('Password changed successfully', isSuccess: true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            _controller.clearFields();
          });
        }
      } else {
        _showSnackBar('Failed to change password');
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
      decoration: _inputDecoration(label, icon, obscure, onToggle),
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
                        if (value == null || value.isEmpty){
                          return 'Current password is required';
                        }
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
