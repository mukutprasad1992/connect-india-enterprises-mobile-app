import 'package:flutter/material.dart';
import '/consts/appColors.dart';
class EditPage extends StatefulWidget {
  final Map<String, dynamic> vendor;

  const EditPage({super.key, required this.vendor});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _representativeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vendorCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.vendor['Business name'] ?? '';
    _representativeController.text = widget.vendor['Business representative'] ?? '';
    _emailController.text = widget.vendor['Email'] ?? '';
    _phoneController.text = widget.vendor['Phone'] ?? '';
    _vendorCodeController.text = widget.vendor['Vendor code'] ?? '';
    _addressController.text = widget.vendor['Address'] ?? '';
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
        'Business name': _businessNameController.text,
        'Business representative': _representativeController.text,
        'Email': _emailController.text,
        'Phone': _phoneController.text,
        'Vendor code': _vendorCodeController.text,
        'Address': _addressController.text,
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
      prefixIcon: Icon(icon, color: Colors.blue.shade700),
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                    decoration: _inputDecoration('Business Name', Icons.business),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _representativeController,
                    decoration: _inputDecoration('Representative', Icons.person),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email', Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value!.isEmpty || !value.contains('@') ? 'Enter valid email' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('Phone', Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _vendorCodeController,
                    decoration: _inputDecoration('Vendor Code', Icons.code),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration('Address', Icons.location_on),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _cancelEdit,
                          icon: const Icon(Icons.cancel,color: Colors.white),
                          label: const Text('Cancel',style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.background,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _updateVendor,
                          icon: const Icon(Icons.save,color:Colors.white),
                          label: const Text('Update',style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
