import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';
import '/services/vendor_module_service_Api/Vendor_customer/createCustomer.dart';
import '/services/vendor_module_service_Api/Vendor_customer/update_customer.dart';
import 'package:myapp/controllers/vendorController/customer_validator.dart';

class NewVendorCustomerPage extends StatefulWidget {
  
  final String mode;
  final Map<String, dynamic> vendorCustomerModel;
  final String? vendorId;
  final Function(String) onCompleted;

  const NewVendorCustomerPage({
    super.key,
    required this.mode,
    required this.vendorCustomerModel,
    required this.onCompleted,
    this.vendorId,
  });

  @override
  State<NewVendorCustomerPage> createState() => _NewVendorCustomerPageState();
}

class _NewVendorCustomerPageState extends State<NewVendorCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pincode = TextEditingController();
  final _address = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == "edit") {
      _populateFields(widget.vendorCustomerModel);
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    _name.text = data['name'] ?? '';
    _email.text = data['email'] ?? '';
    _phone.text = data['phone'] ?? '';
    _pincode.text = data['pincode'] ?? '';
    _address.text = data['address'] ?? '';
  }

  void _cancel() => Navigator.pop(context);

  Future<void> _SubmitCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.mode == "add") {
        final response = await VendorCreateCustomer.createVendorCustomer(
          name: _name.text,
          email: _email.text,
          phone: _phone.text,
          pincode: _pincode.text,
          address: _address.text,
        );

        if (response["status"] == true || response["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Customer created successfully!"),
              backgroundColor: Colors.green,
            ),
            
          );
          widget.onCompleted(response["id"]?.toString() ?? '');
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response["message"] ?? "Failed to create"),
              backgroundColor: Colors.red,
            ),

          );
        }
      } else if (widget.mode == "edit") {
        final id = widget.vendorCustomerModel['id'] ??
            widget.vendorCustomerModel['_id'];
        final response = await UpdateVendorCustomer.updateVendorCustomerById(
          id: id.toString(),
          email: _email.text,
          name: _name.text,
          phone: _phone.text,
          pincode: _pincode.text,
          address: _address.text,
          
        );

        if (response["status"] == true || response["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Customer updated successfully!"),
              backgroundColor: Colors.green,
            ), 
          );
          
          widget.onCompleted(id.toString());
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response["message"] ?? "Failed to update"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),

      );
    } finally {
      setState(() => _isLoading = false);
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
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration:
          _inputDecoration(label, icon, required: true, prefixText: prefixText),
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
            onPressed: _isLoading ? null : _SubmitCustomer,
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
                  : widget.mode == "add"? "Submit": "Update",
                  
              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
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
    final isEdit = widget.mode == "edit";

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEdit ? "Edit Customer" : "Add New Customer",
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
                      controller: _name,
                      label: "Customer Name",
                      icon: Icons.person,
                      keyboardType: TextInputType.name,
                      validator: Vendor_CustomerController.validateName,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _email,
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: Vendor_CustomerController.validateEmail,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _phone,
                      label: "Phone Number",
                      prefixText: '+91 ',
                      icon: Icons.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: TextInputType.phone,
                      validator: Vendor_CustomerController.validatePhone,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _pincode,
                      label: "Pincode",
                      icon: Icons.location_on,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      //keyboardType: TextInputType.pincode,
                      validator: Vendor_CustomerController.validatePincode,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _address,
                      label: "Address",
                      icon: Icons.home,
                      //keyboardType: TextInputType.adress,
                      validator: Vendor_CustomerController.validateAddress,
                    ),
                    const SizedBox(height: 30),
                    _buildButtons(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
