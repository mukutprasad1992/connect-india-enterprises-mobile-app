import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/loanController/LoanFormController.dart';
import '/services/serviceType/loanServices/createLoan.dart';
import '/services/serviceType/loanServices/updateLoan.dart' as updateApi;

class Personaldetails extends StatefulWidget {
  final TextEditingController aadharController;
  final TextEditingController panController;
  final TextEditingController motherNameController;
  final TextEditingController maritalStatusController;
  final TextEditingController currentAddressController;

  final GlobalKey<FormState> formKey;
  final String token;
  final String loanType;
  final String serviceId;
  final String activeSteps;
  final String? dbId;
  final String mode;
  final Function(String dbId) onCompleted;

  const Personaldetails({
    super.key,
    required this.activeSteps,
    required this.aadharController,
    required this.panController,
    required this.motherNameController,
    required this.maritalStatusController,
    required this.currentAddressController,
    required this.formKey,
    required this.token,
    required this.loanType,
    required this.serviceId,
    required this.mode,
    this.dbId,
    required this.onCompleted,
  });

  @override
  State<Personaldetails> createState() => _PersonaldetailsState();
}

class _PersonaldetailsState extends State<Personaldetails> {
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

  Map<String, dynamic> createLoanByserviceType() {
    return {
      "activeSteps": "personalDetails",
      "panNumber": widget.panController.text.trim(),
      "aadharNumber": widget.aadharController.text.trim(),
      "motherName": widget.motherNameController.text.trim(),
      "maritalStatus": widget.maritalStatusController.text.trim(),
      "currentAddress": widget.currentAddressController.text.trim(),
      "serviceId": "4",
      "serviceSubType": widget.loanType,
      "status": "Pending",
    };
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("⚠️ $msg"), backgroundColor: Colors.orangeAccent),
    );
  }

  /// 🔹 Validate & Save Basic Details
  Future<void> saveDetails({bool validate = true}) async {
    if (validate && !widget.formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      String? dbId = widget.dbId;
      if (widget.mode == "add" && dbId == null) {
        final res = await CreateLoanService.createLoanByserviceType(
          activeSteps: "personalDetails",
          panNumber: widget.panController.text.trim(),
          aadharNumber: widget.aadharController.text.trim(),
          motherName: widget.motherNameController.text.trim(),
          maritalStatus: widget.maritalStatusController.text.trim(),
          currentAddress: widget.currentAddressController.text.trim(),
          serviceId: "4",
          serviceSubType: "Personal loans",
          status: "Pending",
          token: widget.token,
        );

        if (res['status'] == true) {
          dbId =
              res['data']?['_id']?.toString() ?? res['data']?['id']?.toString();
          if (dbId == null) {
            if (mounted) _showError("Service created but DB ID missing");
            return;
          }
        } else {
          throw Exception(res['message'] ?? "Error creating service");
        }
      }

      if (dbId != null) {
        await updateApi.updateLoanService.updateLoanServiceTypeById(
          id: dbId,
          token: widget.token,
          activeSteps: "personalDetails",
          panNumber: widget.panController.text.trim(),
          aadharNumber: widget.aadharController.text.trim(),
          motherName: widget.motherNameController.text.trim(),
          maritalStatus: widget.maritalStatusController.text.trim(),
          currentAddress: widget.currentAddressController.text.trim(),
          serviceId: "4",
          serviceSubType: "Personal loans",
          status: "Pending",
        );

        widget.onCompleted(dbId);
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
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
          // Aadhaar Field
          TextFormField(
            controller: widget.aadharController,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: _inputDecoration("Aadhar Number", Icons.credit_card,
                required: true),
            validator: AddLoanController.validateAadhar,
          ),
          const SizedBox(height: 12),

          // PAN Field
          TextFormField(
            controller: widget.panController,
            style: const TextStyle(fontSize: 14),
            textCapitalization: TextCapitalization.characters,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration:
                _inputDecoration("PAN Number", Icons.person, required: true),
            validator: AddLoanController.validatePAN,
          ),
          const SizedBox(height: 12),

          // 🔹 Mother’s Name Field
          TextFormField(
            controller: widget.motherNameController,
            style: const TextStyle(fontSize: 14),
            textCapitalization: TextCapitalization.words,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration:
                _inputDecoration("Mother’s Name", Icons.female, required: true),
            validator: AddLoanController.validateMotherName,
          ),
          const SizedBox(height: 12),

          // 🔹 Marital Status Field
          DropdownButtonFormField<String>(
            value: widget.maritalStatusController.text.isNotEmpty
                ? widget.maritalStatusController.text
                : null,
            decoration: _inputDecoration("Marital Status", Icons.favorite,required: true),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            items: const [
              DropdownMenuItem(value: "Single", child: Text("Single")),
              DropdownMenuItem(value: "Married", child: Text("Married")),
              DropdownMenuItem(value: "Divorced", child: Text("Divorced")),
              DropdownMenuItem(value: "Widowed", child: Text("Widowed")),
              DropdownMenuItem(value: "Separated", child: Text("Separated")),
            ],
            onChanged: (value) {
              widget.maritalStatusController.text = value ?? '';
            },
            validator: AddLoanController.validateMaritalStatus,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 12),

          // 🔹 Current Address Field
          TextFormField(
            controller: widget.currentAddressController,
            style: const TextStyle(fontSize: 14),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: 1,
            decoration:
                _inputDecoration("Current Address", Icons.home, required: true),
            validator: AddLoanController.validateCurrentAddress,
          ),
        ],
      ),
    );
  }
}
