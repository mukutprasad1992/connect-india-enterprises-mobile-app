import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';
import '/controllers/myProfileController.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ProfileController _controller = ProfileController();
  bool _submitted = false;
  final Map<String, bool> _fieldTouched = {};

  @override
  void initState() {
    super.initState();
    _controller.loadProfileData(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _controller.dobController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _cancel() => Navigator.pop(context);

  InputDecoration _inputDecoration(String label, IconData icon) {
    final hasAsterisk = label.contains('*');
    final parts = hasAsterisk ? label.split('*') : [label];

    return InputDecoration(
      prefixIcon: Icon(icon, color:Colors.deepPurple,size: 18),
      
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
          : Text(label,style: const TextStyle(fontSize: 14, color: Colors.black)),
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
    required TextEditingController controller,
    required String keyName,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() => _fieldTouched[keyName] = true);
        }
      },
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: _inputDecoration(label, icon),
        validator: (value) {
          final touched = _fieldTouched[keyName] ?? _submitted;

          if (!touched) return null;
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }

          switch (keyName) {
            case 'firstName':
            case 'lastName':
            case 'businessName':
            case 'representative':
              if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
                return 'Only letters allowed';
              }
              break;
            case 'email':
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Enter valid email';
              }
              break;
            case 'mobile':
              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return 'Enter valid 10-digit number';
              }
              break;
            case 'address':
              if (!RegExp(r'^[A-Za-z0-9\s,.-]+$').hasMatch(value)) {
                return 'Only alphanumeric characters allowed';
              }
              break;
            case 'pincode':
              if (!RegExp(r'^\d{6,8}$').hasMatch(value)) {
                return 'Pincode must be 6–8 digits';
              }
              break;
            case 'vendor':
              if (!RegExp(r'^[A-Za-z0-9]{1,10}$').hasMatch(value)) {
                return 'Max 10 alphanumeric characters';
              }
              break;
            case 'dob':
              if (value.trim().isEmpty) {
                return 'Please select date of birth';
              }
              break;
          }

          return null;
        },
        style: const TextStyle(fontSize: 14),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              _submitted = true;
              setState(() {});
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(_controller.isProfileEmpty
                      ? 'Confirm Save'
                      : 'Confirm Update'),
                  content: Text(_controller.isProfileEmpty
                      ? 'Are you sure you want to save this profile?'
                      : 'Are you sure you want to update your profile?'),
                  actions: [
                    TextButton(
                      onPressed: _cancel,
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.SubmitButtom,
                      ),
                      child: const Text('Confirm',style:TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );

              if (confirmed == true &&
                  _controller.formKey.currentState!.validate()) {
                final isNew = _controller.isProfileEmpty;
                await _controller.saveProfileData();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        isNew ? 'Profile saved!' : 'Profile updated!'),
                    backgroundColor: Colors.green,
                  ),
                );

                setState(() {
                  _controller.isProfileEmpty = false;
                });
              }
            },
            child: Text(
              _controller.isProfileEmpty ? 'Save' : 'Update',
              style: const TextStyle(color: Colors.white),
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
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
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
              key: _controller.formKey,
              child: Column(
                children: [
                  _buildField(
                    label: 'First Name*',
                    controller: _controller.firstNameController,
                    keyName: 'firstName',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Last Name*',
                    controller: _controller.lastNameController,
                    keyName: 'lastName',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Business Name*',
                    controller: _controller.businessNameController,
                    keyName: 'businessName',
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Representative Name*',
                    controller: _controller.representativeController,
                    keyName: 'representative',
                    icon: Icons.people,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Email*',
                    controller: _controller.emailController,
                    keyName: 'email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Mobile*',
                    controller: _controller.mobileController,
                    keyName: 'mobile',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Address*',
                    controller: _controller.addressController,
                    keyName: 'address',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Pincode*',
                    controller: _controller.pincodeController,
                    keyName: 'pincode',
                    icon: Icons.pin,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'DOB*',
                    controller: _controller.dobController,
                    keyName: 'dob',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: _selectDOB,
                  ),
                  const SizedBox(height: 18),
                  _buildField(
                    label: 'Vendor Code*',
                    controller: _controller.vendorController,
                    keyName: 'vendor',
                    icon: Icons.code,
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




