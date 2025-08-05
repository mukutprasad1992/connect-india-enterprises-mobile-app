import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';
import '/controllers/adminController/myProfileController.dart';

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





// import 'package:flutter/material.dart';
// import '/controllers/adminController/myProfileController.dart';
// import '/consts/appColors.dart';
// class MyProfilePage extends StatefulWidget {
//   const MyProfilePage({super.key});

//   @override
//   State<MyProfilePage> createState() => _MyProfilePageState();
// }

// class _MyProfilePageState extends State<MyProfilePage> {
//   final ProfileController _controller = ProfileController();

//   @override
//   void initState() {
//     super.initState();
//     _controller.loadProfileData(() {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDOB() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _controller.dobController.text =
//             "${picked.day}/${picked.month}/${picked.year}";
//       });
//     }
//   }

//   InputDecoration _inputDecoration(String label, IconData icon) {
//     final hasAsterisk = label.contains('*');
//     final parts = hasAsterisk ? label.split('*') : [label];

//     return InputDecoration(
//       prefixIcon: Icon(icon, color: AppColors.background, size: 18),
//       label: hasAsterisk
//           ? RichText(
//               text: TextSpan(
//                 text: parts[0],
//                 style: const TextStyle(fontSize: 14, color: Colors.black),
//                 children: const [
//                   TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: Colors.red, fontSize: 14),
//                   ),
//                 ],
//               ),
//             )
//           : Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
//       isDense: true,
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }


//   Widget _buildTextField(
//     TextEditingController controller,
//     String labelText, {
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     IconData? icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Focus(
//         onFocusChange: (hasFocus) {
//           if (!hasFocus) {
//             _controller.formKey.currentState?.validate();
//           }
//         },
//         child: TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: validator ??
//               (value) {
//                 if (value == null || value.isEmpty)
//                   return '$labelText is required';
//                 return null;
//               },
//           decoration: InputDecoration(
//             labelText: labelText,
//             prefixIcon: icon != null ? Icon(icon) : null,
//             border: const OutlineInputBorder(),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text("My Profile", style: TextStyle(color: Colors.white)),
//         backgroundColor: AppColors.background ,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _controller.formKey,
//           autovalidateMode: AutovalidateMode.disabled, // Disable global validation
//           child: ListView(
//             children: [
//               _buildTextField(_controller.firstNameController, "First Name", icon: Icons.person),
//               _buildTextField(_controller.lastNameController, "Last Name", icon: Icons.person_outline),
//               _buildTextField(_controller.businessNameController, "Business Name", icon: Icons.business),
//               _buildTextField(_controller.representativeController, "Business Representative", icon: Icons.badge),
//               _buildTextField(
//                 _controller.emailController,
//                 "Email ID",
//                 icon: Icons.email,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Email is required';
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
//                     return 'Enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               _buildTextField(
//                 _controller.mobileController,
//                 "Mobile Number",
//                 icon: Icons.phone,
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Mobile number is required';
//                   if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return 'Enter a valid 10-digit number';
//                   return null;
//                 },
//               ),
//               _buildTextField(_controller.addressController, "Address", icon: Icons.home),
//               _buildTextField(
//                 _controller.pincodeController,
//                 "Pincode",
//                 icon: Icons.pin,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Pincode is required';
//                   if (value.length != 6) return 'Enter a valid 6-digit pincode';
//                   return null;
//                 },
//               ),
//               GestureDetector(
//                 onTap: _selectDOB,
//                 child: AbsorbPointer(
//                   child: _buildTextField(
//                     _controller.dobController,
//                     "Date of Birth (DD/MM/YYYY)",
//                     icon: Icons.calendar_today,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return 'Date of Birth is required';
//                       return null;
//                     },
//                   ),
//                 ),
//               ),
//               _buildTextField(_controller.vendorController, "Vendor Code", icon: Icons.store),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:AppColors.background 
//                 ),
//                 onPressed: () async {
//                   final confirmed = await showDialog<bool>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text(_controller.isProfileEmpty ? 'Confirm Save' : 'Confirm Update'),
//                         content: Text(_controller.isProfileEmpty
//                             ? 'Are you sure you want to save this profile?'
//                             : 'Are you sure you want to update your profile?'),
//                         actions: [
//                           TextButton(
//                             child: const Text('Cancel'),
//                             onPressed: () => Navigator.of(context).pop(false),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.background 
//                             ),
//                             child: const Text('Confirm', style: TextStyle(color: Colors.white)),
//                             onPressed: () => Navigator.of(context).pop(true),
//                           ),
//                         ],
//                       );
//                     },
//                   );

//                   if (confirmed == true) {
//                     if (_controller.formKey.currentState!.validate()) {
//                       final isNew = _controller.isProfileEmpty;
//                       await _controller.saveProfileData();

//                       if (!mounted) return;

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(isNew ? 'Profile saved!' : 'Profile updated!'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );

//                       await Future.delayed(const Duration(seconds: 2));
//                       setState(() {
//                         _controller.isProfileEmpty = false;
//                       });
//                     }
//                   }
//                 },
//                 child: Text(
//                   _controller.isProfileEmpty ? 'Save' : 'Update',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }