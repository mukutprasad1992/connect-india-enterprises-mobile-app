import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/investmentController/InvesrmentformController.dart';
import '/consts/appColors.dart';
import '/services/serviceType/updateServiceType.dart' as updateApi;

class NomineeDetailsSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomineeIdController;
  final TextEditingController nomineeMobileController;
  final TextEditingController nomineeRelationController;

  final String? selectedRelation;
  final String? selectIDType;
  final bool isOtherSelected;
  final ValueChanged<String?> onIDTypeChanged;
  final ValueChanged<String?> onRelationChanged;

  final String? DBId;
  final int serviceId;
  final String mode;
  final String token;
  final String? investmentType;

  // Other details from previous steps (used in API payload)
  final String? email;
  final String? mobile;
  final String? income;
  final String? occupation;
  final Map<String, String>? placeOfBirth;

  // 🔹 Callback when step is successfully completed
  final Function(String dbId) onCompleted;

  const NomineeDetailsSection({
    super.key,
    required this.formKey,
    required this.nomineeIdController,
    required this.nomineeMobileController,
    required this.nomineeRelationController,
    required this.selectedRelation,
    required this.selectIDType,
    required this.isOtherSelected,
    required this.onIDTypeChanged,
    required this.onRelationChanged,
    required this.DBId,
    required this.serviceId,
    required this.mode,
    required this.token,
    required this.investmentType,
    required this.email,
    required this.mobile,
    required this.income,
    required this.occupation,
    required this.placeOfBirth,
    required this.onCompleted,
  });

  @override
  State<NomineeDetailsSection> createState() => _NomineeDetailsSectionState();
}

class _NomineeDetailsSectionState extends State<NomineeDetailsSection> {
  bool _isLoading = false;

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool required = false, String? prefixText}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 20),
      prefixText: prefixText,
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

  /// 🔹 Submit Nominee details
  Future<String?> submitDetails() async {
    if (!widget.formKey.currentState!.validate()) return null;
    if (widget.DBId == null) return null;

    setState(() => _isLoading = true);

    try {
      final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
        id: widget.DBId!,
        token: widget.token,
        serviceId: widget.serviceId.toString(),
        serviceSubType: widget.investmentType,
        activeSteps: "nomineeDetails",
        status: "Pending",
        nomineeIdType: widget.selectIDType,
        nomineeId: widget.nomineeIdController.text.trim(),
        nomineeMobile: widget.nomineeMobileController.text.trim(),
        nomineeRelation: widget.isOtherSelected
            ? widget.nomineeRelationController.text.trim()
            : widget.selectedRelation,
      );

      if (res['status'] == true) {
        final data = res['data'];
        final dbId = data?['_id']?.toString() ?? data?['id']?.toString();

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
          // Select ID Type
          DropdownButtonFormField<String>(
            value: widget.selectIDType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: _inputDecoration("Select Nominee ID Type", Icons.badge,
                required: true),
            items: ["Aadhar", "PAN"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              setState(() {
                widget.onIDTypeChanged(val);
                widget.nomineeIdController.clear();
              });
            },
            validator: (val) {
              if (val == null || val.isEmpty) return "Please select ID Type";
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Nominee ID input
          TextFormField(
            controller: widget.nomineeIdController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.selectIDType == "Aadhar"
                ? TextInputType.number
                : TextInputType.text,
            decoration: _inputDecoration(
                "Enter Nominee ${widget.selectIDType ?? "ID"}", Icons.person,
                required: true),
            inputFormatters: widget.selectIDType == "Aadhar"
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ]
                : null,
            validator: (value) => AddInvestmentController.validateNomineeId(
              value,
              idType: widget.selectIDType,
            ),
          ),

          const SizedBox(height: 12),

          // Nominee Mobile
          TextFormField(
            controller: widget.nomineeMobileController,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration:
                _inputDecoration("nominee Mobile Number", Icons.phone, required: true)
                    .copyWith(
              prefixText: "+91 ",
            ),
            validator: AddInvestmentController.validatePhone,
          ),
          const SizedBox(height: 12),

          // Relation Dropdown
          DropdownButtonFormField<String>(
            value: widget.selectedRelation,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: _inputDecoration("Relation with Nominee", Icons.group,
                required: true),
            items: ["Uncle", "Mother", "Father", "Brother", "Sister", "Other"]
                .map((relation) =>
                    DropdownMenuItem(value: relation, child: Text(relation)))
                .toList(),
            onChanged: widget.onRelationChanged,
            validator: (_) => AddInvestmentController.validateRelation(
                widget.isOtherSelected
                    ? widget.nomineeRelationController.text
                    : widget.selectedRelation),
          ),
          const SizedBox(height: 12),

          // Other Relation input
          if (widget.isOtherSelected)
            TextFormField(
              controller: widget.nomineeRelationController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _inputDecoration("Enter Relation", Icons.group,
                  required: true),
              validator: (value) =>
                  AddInvestmentController.validateRelation(value),
            ),
        ],
      ),
    );
  }
}
