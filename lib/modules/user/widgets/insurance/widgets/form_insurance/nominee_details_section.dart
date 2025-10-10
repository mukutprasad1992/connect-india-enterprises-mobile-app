import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '/services/serviceType/insuranceServices/updateInsurance.dart' as updateApi;

class NomineeDetailsSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomineeNameController;
  final TextEditingController nomineeDOBController;
  final TextEditingController nomineeRelationController;

  final String? selectedRelation;
  final ValueChanged<String?> onRelationChanged;

  final String? DBId;
  final int serviceId;
  final String mode;
  final String token;
  final String? insuranceType;

  final String activeSteps;
  //final String? email;
  final String? income;
  final String? occupation;
  final Map<String, String>? placeOfBirth;

  final Function(String dbId) onCompleted;

  const NomineeDetailsSection({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.nomineeNameController,
    required this.nomineeDOBController,
    required this.nomineeRelationController,
    required this.selectedRelation,
    required this.onRelationChanged,
    required this.DBId,
    required this.serviceId,
    required this.mode,
    required this.token,
    required this.insuranceType,
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
      prefixIcon: Icon(icon, color: Colors.deepPurple, size: 18),
      prefixText: prefixText,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
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

  Future<String?> submitDetails() async {
    if (!widget.formKey.currentState!.validate()) return null;
    if (widget.DBId == null) return null;

    setState(() => _isLoading = true);

    try {
      final res = await updateApi.updateInsuranceService.updateInsuranceServiceTypeById(
        id: widget.DBId!,
        token: widget.token,
        serviceId: "3",
        serviceSubType: "Life insurance policies",
        activeSteps: "nomineeDetails",
        status: "Pending",
        nomineeName: widget.nomineeNameController.text.trim(),
        nomineeDOB: widget.nomineeDOBController.text.trim(),
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
          TextFormField(
            controller: widget.nomineeNameController,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              LengthLimitingTextInputFormatter(50),
            ],
            decoration: _inputDecoration(
              "Nominee Name", 
              Icons.person,
              required: true,
            ),           
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Nominee Nmae is required"; 
              } else if (val.trim().length < 3) {
                return "Name must be at least 3 characters long";
              } else if (val.trim().length > 50) {
                return "Name must not exceed 50 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.nomineeDOBController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            readOnly: true, // prevent typing, pick from date picker
            decoration: _inputDecoration("Nominee DOB", Icons.calendar_today,
                required: true),
            validator: (val) {
              if (val == null || val.isEmpty) return "Nominee DOB is required";
              return null;
            },
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate:
                    DateTime.now().subtract(const Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                widget.nomineeDOBController.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              }
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: [
              "Father",
              "Mother",
              "Brother",
              "Sister",
              "Wife",
              "Husband",
              "Son",
              "Daughter",
              "Uncle",
              "Aunt",
              "Other"
            ].contains(widget.selectedRelation)
                ? widget.selectedRelation
                : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: _inputDecoration(
              "Relation with Nominee",
              Icons.group,
              required: true,
            ),
            items: [
              "Father",
              "Mother",
              "Brother",
              "Sister",
              "Wife",
              "Husband",
              "Son",
              "Daughter",
              "Uncle",
              "Aunt",
              "Other"
            ]
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
