import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/investmentController/InvesrmentformController.dart';
// import '/consts/appColors.dart';
import '/services/user_module_service_Api/investmentServices/createServiceType.dart';
import '/services/user_module_service_Api/investmentServices/updateServiceType.dart' as updateApi;

class BasicDetailsSection extends StatefulWidget {
  final TextEditingController aadharController;
  final TextEditingController panController;
  final GlobalKey<FormState> formKey;
  final String token;
  final String investmentType;
  final String serviceId;
  final String activeSteps;
  final String? dbId;
  final String mode;
  final Function(String dbId) onCompleted;

  const BasicDetailsSection({
    super.key,
    required this.activeSteps,
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
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10, 
        horizontal: 12, 
      ),
      prefixIcon: Icon(icon, color:Colors.deepPurple, size: 18),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [         
          Text(
          label,
          style: const TextStyle(fontSize: 13), 
          ),
          if (required) const Text(" *", style: TextStyle(color: Colors.red, fontSize: 13)),
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
  Map<String, dynamic> serviceType() {
    return {
      "activeSteps": "basicDetails",
      "panNumber": widget.panController.text.trim(),
      "aadharNumber": widget.aadharController.text.trim(),
      "serviceId": "1", 
      "serviceSubType": widget.investmentType, 
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
        final res = await CreateServiceType.serviceType(
          activeSteps: "basicDetails",
          panNumber: widget.panController.text.trim(),
          aadharNumber: widget.aadharController.text.trim(),
          serviceId: "1", 
          serviceSubType: "mutualFund",
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
        await updateApi.ServiceTypeApi.updateServiceTypeById(
          id: dbId,
          token: widget.token,
          activeSteps: "basicDetails",
          panNumber: widget.panController.text.trim(),
          aadharNumber: widget.aadharController.text.trim(),
          serviceId: "1", 
          serviceSubType: "Mutual Funds", 
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
          TextFormField(
            controller: widget.aadharController,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: _inputDecoration("Aadhar Number", Icons.credit_card,required: true),
            validator: AddInvestmentController.validateAadhar,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.panController,
            style: const TextStyle(fontSize: 14),
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
