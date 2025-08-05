import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';

class NewVendorPage extends StatefulWidget {
  @override
  _NewVendorPageState createState() => _NewVendorPageState();
}

class _NewVendorPageState extends State<NewVendorPage> {
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _representativeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vendorCodeController = TextEditingController();
  final _addressController = TextEditingController();

  final _businessFocus = FocusNode();
  final _representativeFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _vendorFocus = FocusNode();
  final _addressFocus = FocusNode();

  bool _submitted = false;
  bool _businessTouched = false;
  bool _representativeTouched = false;
  bool _emailTouched = false;
  bool _phoneTouched = false;
  bool _vendorTouched = false;
  bool _addressTouched = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _representativeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vendorCodeController.dispose();
    _addressController.dispose();

    _businessFocus.dispose();
    _representativeFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _vendorFocus.dispose();
    _addressFocus.dispose();

    super.dispose();
  }

  void _cancel() => Navigator.pop(context);

  void _submitVendor() {
    setState(() {
      _submitted = true;
      _businessTouched = true;
      _representativeTouched = true;
      _emailTouched = true;
      _phoneTouched = true;
      _vendorTouched = true;
      _addressTouched = true;
    });

    if (!_formKey.currentState!.validate()) return;

    final newVendor = {
      'ID': DateTime.now().millisecondsSinceEpoch.toString(),
      'Business name': _businessNameController.text,
      'Business representative': _representativeController.text,
      'Email': _emailController.text,
      'Phone': '+91${_phoneController.text}',
      'Vendor code': _vendorCodeController.text,
      'Address': _addressController.text,
      'Create at': DateTime.now().toString(),
      'Status': 'Active',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vendor successfully added!"),
        backgroundColor: Colors.green,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context, newVendor);
    });
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    final hasAsterisk = label.contains('*');
    final parts = hasAsterisk ? label.split('*') : [label];

    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 18),
      label: hasAsterisk
          ? RichText(
              text: TextSpan(
                text: parts[0],
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
            )
          : Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
      isDense: true,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool touched,
    required String? Function(String?) validator,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() {
            if (focusNode == _businessFocus) _businessTouched = true;
            if (focusNode == _representativeFocus) _representativeTouched = true;
            if (focusNode == _emailFocus) _emailTouched = true;
            if (focusNode == _phoneFocus) _phoneTouched = true;
            if (focusNode == _vendorFocus) _vendorTouched = true;
            if (focusNode == _addressFocus) _addressTouched = true;
            _formKey.currentState!.validate();
          });
        }
      },
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: _inputDecoration(label, icon),
        validator: (value) {
          if (!_submitted && !touched) return null;
          return validator(value);
        },
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() {
            _phoneTouched = true;
            _formKey.currentState!.validate();
          });
        }
      },
      child: TextFormField(
        controller: _phoneController,
        focusNode: _phoneFocus,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: _inputDecoration('Phone (+91)*', Icons.phone),
        validator: (value) {
          if (!_submitted && !_phoneTouched) return null;
          if (value == null || value.isEmpty) return 'Phone number is required';
          if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Enter 10-digit number';
          return null;
        },
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _cancel,
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _submitVendor,
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: const Text(
              'Submit',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add New Vendor', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
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
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(
                    label: 'Business Name*',
                    icon: Icons.business,
                    controller: _businessNameController,
                    focusNode: _businessFocus,
                    touched: _businessTouched,
                    
                    //maxLength: 30,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Business Name is required';
                      if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) return 'Only letters allowed';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Business Representative*',
                    icon: Icons.person,
                    controller: _representativeController,
                    focusNode: _representativeFocus,
                    touched: _representativeTouched,
                    //maxLength: 30,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Representative is required';
                      if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) return 'Only letters allowed';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Email*',
                    icon: Icons.email,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    touched: _emailTouched,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Email is required';
                      if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) return 'Enter valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildPhoneField(),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Vendor Code*',
                    icon: Icons.qr_code,
                    controller: _vendorCodeController,
                    focusNode: _vendorFocus,
                    touched: _vendorTouched,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Vendor Code is required' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Address*',
                    icon: Icons.location_on,
                    controller: _addressController,
                    focusNode: _addressFocus,
                    touched: _addressTouched,
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Address is required';
                      if (value.trim().split(' ').length > 50) return 'Max 50 words allowed';
                      return null;
                    },
                  ),
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
