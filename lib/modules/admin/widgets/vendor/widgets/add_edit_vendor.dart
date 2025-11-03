import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';
import '/controllers/adminController/vendor/vendor_Validator.dart';
import '/services/admin_module_service_Api/vendor/createvendor.dart';
import '/services/admin_module_service_Api/vendor/updateVendor.dart';


class NewVendorPage extends StatefulWidget {
  final String mode;
  final String? dbId;
  final String token;
  final Map<String, dynamic> vendor;
  final Function(String dbId) onCompleted;

  const NewVendorPage({
    Key? key,
    required this.token,
    required this.mode,
    required this.vendor,
    this.dbId,
    required this.onCompleted,
  }) : super(key: key);

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

  bool _isLoading = false;
  String? dbId;

  @override
  void initState() {
    super.initState();
    if (widget.mode == "edit" && widget.vendor.isNotEmpty) {
      _prefillVendorData();
    }
  }

  //  FIXED: All values converted to String safely
  void _prefillVendorData() {
    try {
      final ven = widget.vendor;

      //print("🟩 Prefilling vendor data: $ven");

      // ven.forEach((k, v) {
      //   print("  $k => ${v.runtimeType} : $v");
      // });

      dbId = widget.dbId ?? ven["id"]?.toString() ?? ven["_id"]?.toString() ?? "";

      _businessNameController.text = ven["businessName"]?.toString() ?? '';
      _representativeController.text = ven["businessRepresentative"]?.toString() ?? '';
      _emailController.text = ven["email"]?.toString() ?? '';
      _phoneController.text = ven["mobileNo"]?.toString() ?? '';
      _vendorCodeController.text = ven["vendorCode"]?.toString() ?? '';
      _addressController.text = ven["address"]?.toString() ?? '';

      //print(" Prefill success: ${_businessNameController.text}");
    } catch (e, s) {
      //print(" Prefill error caught: $e");
      //print(s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Prefill error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  void _cancel() => Navigator.pop(context);

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  /// All fields converted to string before submission
  
  Future<void> _submitVendor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        "businessName": _businessNameController.text.trim(),
        "businessRepresentative": _representativeController.text.trim(),
        "email": _emailController.text.trim(),
        "mobileNo": _phoneController.text.trim(),
        "vendorCode": _vendorCodeController.text.trim(),
        "address": _addressController.text.trim(),
        "status": "Enable",
      };

      print("🟦 Submitting vendor data:");
      data.forEach((k, v) => print("  $k => ${v.runtimeType} : $v"));
      print("🟩 dbId = $dbId (${dbId.runtimeType})");

      Map<String, dynamic> result;

      if (widget.mode == "add") {
        result = await CreateVendor.createVendor(
          email: data["email"]!,
          mobileNo: data["mobileNo"]!,
          roleId: 2,
          businessName: data["businessName"],
          businessRepresentative: data["businessRepresentative"],
          vendorCode: data["vendorCode"],
          address: data["address"],
          status: "Enable",
        );

        if (result["status"] == true) {
          dbId = result["result"]?["id"]?.toString();
          if (dbId == null)
            throw Exception("Cannot get DBId from create response");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Vendor successfully added!"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception(result["message"] ?? "Failed to create vendor");
        }
      } else {
        if (dbId == null) throw Exception("Missing vendor ID for update");

        result = await UpdateVendor.updateVendorById(
          id: dbId!,
          email: data["email"]!,
          mobileNo: data["mobileNo"]!,
          businessName: data["businessName"],
          businessRepresentative: data["businessRepresentative"],
          vendorCode: data["vendorCode"],
          address: data["address"],
          status: data["status"]!,
          token: widget.token,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vendor successfully updated!"),
            backgroundColor: Colors.blue,
          ),
        );
      }

      /// ✅ FIXED: Always convert dbId to string before passing
      widget.onCompleted(dbId!.toString());

      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context, dbId);
      });
    } catch (e, s) {
      print("❌ Submit error: $e");
      print(s);
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool required = false, String? prefixText}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      prefixIcon: Icon(icon, color: Colors.deepPurple, size: 18),
      prefixText: prefixText,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          if (required)
            const Text(" *", style: TextStyle(color: Colors.red, fontSize: 13)),
        ],
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      decoration:_inputDecoration(label, icon, required: true, prefixText: prefixText),
      validator: validator,
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _cancel,
            icon: const Icon(Icons.cancel, color: Colors.white),
            label: const Text(
              'Cancel',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _submitVendor,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline, color: Colors.white),
            label: Text(
              _isLoading
                  ? "Processing..."
                  : widget.mode == "add"
                      ? "Submit"
                      : "Update",
              style: const TextStyle(
                  color: Color.fromARGB(255, 31, 19, 19), fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.mode == "add" ? Colors.indigo : Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        title: Text(
          widget.mode == "add" ? 'Add New Vendor' : 'Edit Vendor',
          style: const TextStyle(color: Colors.white),
        ),
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
                  _buildTextField(
                    label: 'Business Name',
                    icon: Icons.business,
                    controller: _businessNameController,
                    validator: VendorController.validateBuisnessName,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Business Representative',
                    icon: Icons.person,
                    controller: _representativeController,
                    validator: VendorController.validateRepresentative,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: VendorController.validateEmail,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Phone',
                    icon: Icons.phone,
                    controller: _phoneController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.phone,
                    validator: VendorController.validatePhone,
                    prefixText: '+91 ',
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Vendor Code',
                    icon: Icons.qr_code,
                    controller: _vendorCodeController,
                    validator: VendorController.validateVendorCode,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Address',
                    icon: Icons.location_on,
                    controller: _addressController,
                    validator: VendorController.validateAddress,
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
