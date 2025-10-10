import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/loanController/LoanFormController.dart';
import '/services/serviceType/loanServices/updateLoan.dart' as updateApi;

class Employmentdetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController designationController;
  final TextEditingController companyExpController;
  final TextEditingController totalWorkExpController;
  final TextEditingController officeAddressController;
  final TextEditingController officeMobileController;

  final String? DBId;
  final int serviceId;
  final String mode;
  final String token;
  final String? loanType;
  final String activeSteps;

  final Function(String dbId) onCompleted;

  const Employmentdetails({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.designationController,
    required this.companyExpController,
    required this.totalWorkExpController,
    required this.officeAddressController,
    required this.officeMobileController,
    required this.DBId,
    required this.serviceId,
    required this.mode,
    required this.token,
    required this.loanType,
    required this.onCompleted,
  });

  @override
  State<Employmentdetails> createState() => _EmploymentdetailsState();
}

class _EmploymentdetailsState extends State<Employmentdetails> {
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
            const Text(
              " *",
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
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
        activeSteps: "employmentDetails",
        status: "Pending",
        designation: widget.designationController.text.trim(),
        companyExp: widget.companyExpController.text.trim(),
        totalWorkExp: widget.totalWorkExpController.text.trim(),
        officeAddress: widget.officeAddressController.text.trim(),
        officeMobile: widget.officeMobileController.text.trim(),
      );

      if (res['status'] == true) {
        final dbId = res['data']?['_id']?.toString() ?? res['data']?['id']?.toString();
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
          // 🔹 Designation
          _buildTextField(
            controller: widget.designationController,
            label: "Designation",
            icon: Icons.work_outline,
            validator: AddLoanController.validateDesignation,
          ),
          const SizedBox(height: 12),

          // 🔹 Company Experience
          _buildTextField(
            controller: widget.companyExpController,
            label: "Company Experience (in years)",
            icon: Icons.timer_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: AddLoanController.validateCompanyExp,
          ),
          const SizedBox(height: 12),

          // 🔹 Total Work Experience
          _buildTextField(
            controller: widget.totalWorkExpController,
            label: "Total Work Experience (in years)",
            icon: Icons.timeline_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: AddLoanController.validateTotalWorkExp,
          ),
          const SizedBox(height: 12),

          // 🔹 Office Address
          _buildTextField(
            controller: widget.officeAddressController,
            label: "Office Address",
            icon: Icons.location_on_outlined,
            keyboardType: TextInputType.multiline,
            validator: AddLoanController.validateOfficeAddress,
          ),
          const SizedBox(height: 12),

          // 🔹 Office Mobile
          _buildTextField(
            controller: widget.officeMobileController,
            label: "Office Mobile",
            icon: Icons.phone,
            keyboardType: TextInputType.number,
            prefixText: "+91 ",
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: AddLoanController.validatemobile,
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
