import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/loanController/LoanFormController.dart';
import '../../../../../../services/user_module_service_Api/loanServices/updateLoan.dart' as updateApi;

class ReferenceDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ref1NameController;
  final TextEditingController ref1MobileController;
  final TextEditingController ref1AddressController;
  final TextEditingController ref2NameController;
  final TextEditingController ref2MobileController;
  final TextEditingController ref2AddressController;

  final String? DBId;
  final int serviceId;
  final String mode;
  final String token;
  final String? loanType;
  final String activeSteps;
  final Function(String dbId) onCompleted;

  const ReferenceDetails({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.ref1NameController,
    required this.ref1MobileController,
    required this.ref1AddressController,
    required this.ref2NameController,
    required this.ref2MobileController,
    required this.ref2AddressController,
    required this.DBId,
    required this.serviceId,
    required this.mode,
    required this.token,
    required this.loanType,
    required this.onCompleted,
  });

  @override
  State<ReferenceDetails> createState() => _ReferenceDetailsState();
}

class _ReferenceDetailsState extends State<ReferenceDetails> {
  bool _isLoading = false;

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
            const Text(" *",
                style: TextStyle(color: Colors.red, fontSize: 13)),
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

  Future<String?> submitDetails() async {
    if (!widget.formKey.currentState!.validate()) return null;
    if (widget.DBId == null) return null;

    setState(() => _isLoading = true);

    try {
      final res = await updateApi.updateLoanService.updateLoanServiceTypeById(
        id: widget.DBId!,
        token: widget.token,
        serviceId: widget.serviceId.toString(),
        serviceSubType: widget.loanType ?? "Personal loans",
        activeSteps: "referenceDetails",
        status: "Pending",
        ref1Name: widget.ref1NameController.text.trim(),
        ref1Mobile: widget.ref1MobileController.text.trim(),
        ref1Address: widget.ref1AddressController.text.trim(),
        ref2Name: widget.ref2NameController.text.trim(),
        ref2Mobile: widget.ref2MobileController.text.trim(),
        ref2Address: widget.ref2AddressController.text.trim(),
      );

      if (res['status'] == true) {
        final dbId =
            res['data']?['_id']?.toString() ?? res['data']?['id']?.toString();
        if (dbId == null || dbId.isEmpty) {
          throw Exception("Backend did not return DBId");
        }
        widget.onCompleted(dbId);
        return dbId;
      } else {
        throw Exception(res['message'] ?? "Unknown error");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${e.toString()}")),
        );
      }
      return null;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // 🔹 Reference 1 Name
          _buildTextField(
            controller: widget.ref1NameController,
            label: "Reference 1 Name",
            icon: Icons.person_outline,
            validator: AddLoanController.validateMotherName, // Reuse name validator
          ),
          const SizedBox(height: 12),

          // 🔹 Reference 1 Mobile
          _buildTextField(
            controller: widget.ref1MobileController,
            label: "Reference 1 Mobile",
            icon: Icons.phone,
            keyboardType: TextInputType.number,
            prefixText: "+91 ",
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: AddLoanController.validatePhone,
          ),
          const SizedBox(height: 12),

          // 🔹 Reference 1 Address
          _buildTextField(
            controller: widget.ref1AddressController,
            label: "Reference 1 Address",
            icon: Icons.home_outlined,
            validator: AddLoanController.validateCurrentAddress,
          ),
          const SizedBox(height: 20),

          // 🔹 Reference 2 Name
          _buildTextField(
            controller: widget.ref2NameController,
            label: "Reference 2 Name",
            icon: Icons.person_outline,
            validator: AddLoanController.validateMotherName,
          ),
          const SizedBox(height: 12),

          // 🔹 Reference 2 Mobile
          _buildTextField(
            controller: widget.ref2MobileController,
            label: "Reference 2 Mobile",
            icon: Icons.phone,
            keyboardType: TextInputType.number,
            prefixText: "+91 ",
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: AddLoanController.validatePhone,
          ),
          const SizedBox(height: 12),

          // 🔹 Reference 2 Address
          _buildTextField(
            controller: widget.ref2AddressController,
            label: "Reference 2 Address",
            icon: Icons.home_outlined,
            validator: AddLoanController.validateCurrentAddress,
          ),
        ],
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
      decoration:
          _inputDecoration(label, icon, required: true, prefixText: prefixText),
      validator: validator,
    );
  }
}
