import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/investmentController/InvesrmentformController.dart';
import '/consts/appColors.dart';
import '/services/serviceType/createServiceType.dart';
import '/services/serviceType/updateServiceType.dart' as updateApi;

class BasicDetailsSection extends StatefulWidget {
  final TextEditingController aadharController;
  final TextEditingController panController;
  final GlobalKey<FormState> formKey;
  final String token;
  final String investmentType;
  final String serviceId;
  final String? dbId;
  final String mode;

  /// Callback when step is successfully completed
  final Function(String dbId) onCompleted;

  const BasicDetailsSection({
    super.key,
    required this.aadharController,
    required this.panController,
    required this.formKey,
    required this.token,
    required this.investmentType,
    required this.serviceId,
    required this.mode,
    this.dbId,
    required this.onCompleted,
  });

  @override
  State<BasicDetailsSection> createState() => _BasicDetailsSectionState();
}

class _BasicDetailsSectionState extends State<BasicDetailsSection> {
  bool _isLoading = false;

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool required = false}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 20),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (required) const Text(" *", style: TextStyle(color: Colors.red)),
        ],
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  /// 🔹 Validate & save Basic Details
  Future<void> _saveDetails() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? dbId = widget.dbId;

      if (widget.mode == "add" && dbId == null) {
        // Create service if adding new
        final res = await CreateServiceType.serviceType(
          activeSteps: "basicDetails",
          panNumber: widget.panController.text.trim(),
          aadharNumber: widget.aadharController.text.trim(),
          serviceId: widget.serviceId,
          serviceSubType: widget.investmentType,
          status: "Pending",
          token: widget.token,
        );

        if (res['status'] == true) {
          dbId = res['data']?['id']?.toString();
          if (dbId == null)
            throw Exception("Service ID not returned by backend");
        } else {
          throw Exception(res['message'] ?? "Error creating service");
        }
      }

      // Always update service
      await updateApi.ServiceTypeApi.updateServiceTypeById(
        id: dbId!,
        serviceId: widget.serviceId,
        serviceSubType: widget.investmentType,
        status: "Pending",
        activeSteps: "basicDetails",
        panNumber: widget.panController.text.trim(),
        aadharNumber: widget.aadharController.text.trim(),
        token: widget.token,
      );

      widget.onCompleted(dbId); // send back ID to parent
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ $e"), backgroundColor: Colors.red),
        );
      }
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
          TextFormField(
            controller: widget.aadharController,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: _inputDecoration("Aadhar Number", Icons.credit_card,
                required: true),
            validator: AddInvestmentController.validateAadhar,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.panController,
            textCapitalization: TextCapitalization.characters,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration:
                _inputDecoration("PAN Number", Icons.person, required: true),
            validator: AddInvestmentController.validatePAN,
          ),
          const SizedBox(height: 12),
          
        ],
      ),
    );
  }
}
