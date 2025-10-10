import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/loanController/LoanFormController.dart';
import '/services/serviceType/loanServices/updateLoan.dart' as updateApi;

class ContactDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController yearsOfCityController;
  final TextEditingController alternateNoController;
  final TextEditingController landmarkController;

  final String? dbId;
  final String token;
  final String serviceId;
  final String? loanType;
  final String mode;
  final String activeSteps;
  final Function(String dbId) onCompleted;

  const ContactDetails({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.yearsOfCityController,
    required this.alternateNoController,
    required this.landmarkController,
    required this.dbId,
    required this.token,
    required this.serviceId,
    required this.loanType,
    required this.mode,
    required this.onCompleted,
  });

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  bool _isLoading = false;

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool required = false}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      prefixIcon: Icon(icon, color: Colors.deepPurple, size: 18),
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

  /// 🔹 Submit details
  Future<String?> submitDetails() async {
    if (!widget.formKey.currentState!.validate() || widget.dbId == null) {
      return null;
    }

    setState(() => _isLoading = true);

    try {
      final res = await updateApi.updateLoanService.updateLoanServiceTypeById(
        id: widget.dbId!,
        token: widget.token,
        serviceId: "4",
        serviceSubType: "Personal loans",
        activeSteps: "contactDetails",
        status: "Pending",
        yearsOfCity: widget.yearsOfCityController.text.trim(),
        alternateNo: widget.alternateNoController.text.trim(),
        landmark: widget.landmarkController.text.trim(),
      );
      print("📥 API Response --------------: $res");

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
          // 🔹 Years in Current City
          _buildTextField(
            controller: widget.yearsOfCityController,
            label: "Years in Current City",
            icon: Icons.location_city,
            keyboardType: TextInputType.number,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: AddLoanController.validateYearsInCity,
          ),
          const SizedBox(height: 12),

          // 🔹 Alternate Number
          _buildTextField(
            controller: widget.alternateNoController,
            label: "Alternate Number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: AddLoanController.validatePhone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            prefixText: "+91 ",
          ),
          const SizedBox(height: 12),

          // 🔹 Landmark
          _buildTextField(
            controller: widget.landmarkController,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            label: "Landmark",
            icon: Icons.place,
            keyboardType: TextInputType.text,
            validator: AddLoanController.validateLandmark,
          ),
        ],
      ),
    );
  }

  /// 🔹 Generic TextField Builder
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
      decoration: _inputDecoration(label, icon, required: true).copyWith(prefixText: prefixText),
      validator: validator,
    );
  }
}
