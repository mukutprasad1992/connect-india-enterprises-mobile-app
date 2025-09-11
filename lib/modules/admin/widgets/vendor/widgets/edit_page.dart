import 'package:flutter/material.dart';
import '/consts/appColors.dart';
import 'package:flutter/services.dart';

class EditPage extends StatefulWidget {
  final Map<String, dynamic> vendor;

  const EditPage({super.key, required this.vendor});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _representativeController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vendorCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.vendor['businessName'] ?? '';
    _representativeController.text =
        widget.vendor['businessRepresentative'] ?? '';
    _emailController.text = widget.vendor['email'] ?? '';
    _phoneController.text = widget.vendor['mobileNo'] ?? '';
    _vendorCodeController.text = widget.vendor['vendorCode'] ?? '';
    _addressController.text = widget.vendor['address'] ?? '';
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _representativeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vendorCodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateVendor() {
    if (_formKey.currentState!.validate()) {
      final updatedVendor = {
        ...widget.vendor,
        'businessName': _businessNameController.text,
        'businessRepresentative': _representativeController.text,
        'email': _emailController.text,
        'mobileNo': _phoneController.text,
        'vendorCode': _vendorCodeController.text,
        'address': _addressController.text,
        'Updated at': DateTime.now().toString(),
      };

      Navigator.pop(context, updatedVendor);
    }
  }

  void _cancelEdit() {
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 18),
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14),
      isDense: true,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
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
        title: const Text('Edit Vendor', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 4,
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
                  TextFormField(
                    controller: _businessNameController,
                    decoration:
                        _inputDecoration('Business Name', Icons.business),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Business name is required'
                        : null,
                    //maxLength: 40,
                    style: const TextStyle(fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _representativeController,
                    decoration:
                        _inputDecoration('Representative', Icons.person),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Representative name is required'
                        : null,
                      //maxLength: 30,
                    style: const TextStyle(fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email', Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    enabled: false, // lock any field
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('Phone', Icons.phone),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                      LengthLimitingTextInputFormatter(10),   // Max 10 digits
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone is required';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Enter 10-digit phone number';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _vendorCodeController,
                    decoration: _inputDecoration('Vendor Code', Icons.code),
                    enabled: false, // lock or unchanged  any field
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration('Address', Icons.location_on),
                    maxLines: 1,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Address is required'
                        : null,
                      //maxLength: 50,
                    style: const TextStyle(fontSize: 14),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 130,
                        child: OutlinedButton.icon(
                          onPressed: _cancelEdit,
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
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
                      SizedBox(
                        height: 50,
                        width: 130,
                        child: ElevatedButton.icon(
                          onPressed: _updateVendor,
                          icon: const Icon(Icons.update_rounded,
                              color: Colors.white),
                          label: const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
