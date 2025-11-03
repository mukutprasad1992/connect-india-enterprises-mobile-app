import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/investmentController/InvesrmentformController.dart';
import '../../../../../../services/user_module_service_Api/investmentServices/updateServiceType.dart' as updateApi;

class NomineeDetailsSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomineeIdController;
  final TextEditingController nomineeMobileController;
  final TextEditingController nomineeRelationController;

  final String? selectedRelation;
  final String? selectIDType;
  final ValueChanged<String?> onIDTypeChanged;
  final ValueChanged<String?> onRelationChanged;

  final String? DBId;
  final int serviceId;
  final String mode;
  final String token;
  final String? investmentType;

  final String activeSteps;
  final String? email;
  final String? income;
  final String? occupation;
  final Map<String, String>? placeOfBirth;

  final Function(String dbId) onCompleted;

  const NomineeDetailsSection({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.nomineeIdController,
    required this.nomineeMobileController,
    required this.nomineeRelationController,
    required this.selectedRelation,
    required this.selectIDType,
    required this.onIDTypeChanged,
    required this.onRelationChanged,
    required this.DBId,
    required this.serviceId,
    required this.mode,
    required this.token,
    required this.investmentType,
    required this.email,
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
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10, 
        horizontal: 12, 
      ),
      prefixIcon: Icon(icon, color:Colors.deepPurple, size: 18),
      prefixText: prefixText,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
          label,
          style: const TextStyle(fontSize: 13), 
          ),
          if (required) const Text(" *", style: TextStyle(color: Colors.red,fontSize: 13)),
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
      final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
        id: widget.DBId!,
        token: widget.token,
        serviceId: "1",
        serviceSubType: "Mutual Funds",
        activeSteps: "nomineeDetails",
        status: "Pending",
        nomineeIdType: widget.selectIDType,
        nomineeId: widget.nomineeIdController.text.trim(),
        nomineeMobile: widget.nomineeMobileController.text.trim(),
        nomineeRelation: widget.nomineeRelationController.text.trim(),
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
          SnackBar(content: Text(" ${e.toString()}")),
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
          // 🔹 ID Type Dropdown
          DropdownButtonFormField<String>(
            value: ["Aadhar", "PAN"].contains(widget.selectIDType)
                ? widget.selectIDType
                : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14,color: Colors.black),
            decoration: _inputDecoration(
                "Select Nominee ID Type", Icons.badge,
                required: true),
            items: ["Aadhar", "PAN"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              widget.onIDTypeChanged(val);
              widget.nomineeIdController.clear(); 
            },
            validator: (val) {
              if (val == null || val.isEmpty) return "Please select ID Type";
              return null;
            },
            hint: const Text("Select ID Type"),
          ),
          const SizedBox(height: 12),

          // 🔹 ID Input
          TextFormField(
            controller: widget.nomineeIdController,
            style: const TextStyle(fontSize: 14),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.characters,
            keyboardType: widget.selectIDType == "PAN"
                ? TextInputType.text
                : TextInputType.number,
            decoration: _inputDecoration("Enter Nominee ${widget.selectIDType ?? "ID"}", Icons.person,required: true),
            inputFormatters: widget.selectIDType == "PAN"
                ? [
                    //FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
            validator: (value) {
              return AddInvestmentController.validateNomineeId(
                value,
                idType: widget.selectIDType,
              );
            },
          ),
          const SizedBox(height: 12),

          // 🔹 Mobile
          TextFormField(
            controller: widget.nomineeMobileController,
            style: const TextStyle(fontSize: 14,color: Colors.black),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: _inputDecoration("Nominee Mobile Number", Icons.phone,
                    required: true)
                .copyWith(prefixText: "+91 "),
            validator: AddInvestmentController.validatePhone,
            onSaved: (value) {
              if (value != null && value.length == 10) {
                widget.nomineeMobileController.text = '+91 $value';
              }
            },
          ),
          const SizedBox(height: 12),

          // 🔹 Relation Dropdown
          DropdownButtonFormField<String>(
            value: ["Uncle", "Mother", "Father", "Brother", "Sister"]
                    .contains(widget.selectedRelation)
                ? widget.selectedRelation
                : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14,color:Colors.black),
            decoration: _inputDecoration(
              "Relation with Nominee",
              Icons.group,
              required: true,
            ),
            items: ["Uncle", "Mother", "Father", "Brother", "Sister"]
                .map((relation) =>
                    DropdownMenuItem(value: relation, child: Text(relation)))
                .toList(),
            onChanged: (val) {
              widget.onRelationChanged(val);
              widget.nomineeRelationController.text = val ?? '';
            },
            validator: (val) {
              if (val == null || val.isEmpty) return "Please select relation";
              return null;
            },
            hint: const Text("Select Relation"),
          ),
        ],
      ),
    );
  }
}
