import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/services/serviceType/insuranceServices/updateInsurance.dart' as updateApi;
import '/models/citymodel.dart';

class PersonalDetailsSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController incomeController;
  final TextEditingController motherNameController;
  final TextEditingController heightCMController;
  final TextEditingController weightKGController;
  final String? smoker;
  final String? alcohol;
  final String? occupation;
  final List<City> cities;
  final City? selectedCity;
  final bool loadingCities;
  final String? dbId;
  final String token;
  final String serviceId;
  final String? insuranceType;
  final String mode;
  final String activeSteps;
  final Function(String dbId) onCompleted;
  final Function(City?) onCityChanged;
  final Function(String?) onOccupationChanged;
  final Function(String?) onSmokerChanged;
  final Function(String?) onAlcoholChanged;

  const PersonalDetailsSection({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.incomeController,
    required this.motherNameController,
    required this.heightCMController,
    required this.weightKGController,
    required this.occupation,
    required this.smoker,
    required this.alcohol,
    required this.cities,
    required this.loadingCities,
    required this.dbId,
    required this.token,
    required this.serviceId,
    required this.insuranceType,
    required this.mode,
    required this.onCompleted,
    required this.onCityChanged,
    required this.selectedCity,
    required this.onOccupationChanged,
    required this.onSmokerChanged,
    required this.onAlcoholChanged,
  });

  @override
  State<PersonalDetailsSection> createState() => _PersonalDetailsSectionState();
}

class _PersonalDetailsSectionState extends State<PersonalDetailsSection> {
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

  /// Submit personal details
  Future<String?> submitDetails() async {
    if (!widget.formKey.currentState!.validate() || widget.dbId == null) {
      return null;
    }

    setState(() => _isLoading = true);

    try {
      final res = await updateApi.updateInsuranceService.updateInsuranceServiceTypeById(
        id: widget.dbId!,
        token: widget.token,
        serviceId: "3",
        serviceSubType: "Life insurance policies",
        activeSteps: "personalDetails",
        status: "Pending",
        occupation: widget.occupation,
        income: widget.incomeController.text.trim(),
        placeOfBirth: widget.selectedCity != null
            ? {
                "city": widget.selectedCity!.city,
                "state": widget.selectedCity!.state,
              }
            : null,
        motherName: widget.motherNameController.text.trim(),
        heightCM: widget.heightCMController.text.trim(),
        weightKG: widget.weightKGController.text.trim(),
        smoker: widget.smoker,
        alcohol: widget.alcohol,
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
          // Place of Birth
          widget.loadingCities
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<City>(
                  isExpanded: true,
                  value: widget.selectedCity,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  decoration: _inputDecoration(
                    "Place of Birth",
                    Icons.location_city,
                    required: true,
                  ),
                  items: widget.cities
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(
                              "${city.city}, ${city.state}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: widget.onCityChanged,
                  validator: (val) =>
                      val == null ? "place of birth is required" : null,
                ),
          const SizedBox(height: 12),

          // Mother Name
          _buildTextField(
            controller: widget.motherNameController,
            label: "Mother Name",
            icon: Icons.person,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              LengthLimitingTextInputFormatter(50),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "mother's name is required";
              } else if (val.trim().length < 3) {
                return "Mother's name must be at least 3 characters long";
              } else if (val.trim().length > 50) {
                return "Name must not exceed 50 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // Height
          _buildTextField(
            controller: widget.heightCMController,
            label: "Height (CM)",
            icon: Icons.height,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Height is required";
              }
              final height = double.tryParse(val);
              if (height == null) {
                return "Invalid height value";
              }
              if (height < 50 || height > 300) {
                return "Height must be between 50cm and 300cm";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

// Weight
          _buildTextField(
            controller: widget.weightKGController,
            label: "Weight (KG)",
            icon: Icons.monitor_weight,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Weight is required";
              }
              final weight = double.tryParse(val);
              if (weight == null) {
                return "Invalid weight value";
              }
              if (weight < 10 || weight > 500) {
                return "Weight must be between 10kg and 500kg";
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // Smoker
          DropdownButtonFormField<String>(
            value: ["Yes", "No"].contains(widget.smoker) ? widget.smoker : null,
            decoration:
                _inputDecoration("Smoker", Icons.smoking_rooms, required: true),
            items: ["Yes", "No"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: widget.onSmokerChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            validator: (val) =>
                val == null ? "Smoker Status is required" : null,
          ),
          const SizedBox(height: 12),

          // Alcohol
          DropdownButtonFormField<String>(
            value:
                ["Yes", "No"].contains(widget.alcohol) ? widget.alcohol : null,
            decoration:
                _inputDecoration("Alcohol", Icons.local_drink, required: true),
            items: ["Yes", "No"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: widget.onAlcoholChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            validator: (val) =>
                val == null ? "Alcohol consumption Status is required" : null,
          ),
          const SizedBox(height: 12),

          // Occupation
          DropdownButtonFormField<String>(
            value: ["JOB", "BUSINESS"].contains(widget.occupation)
                ? widget.occupation
                : null,
            decoration:
                _inputDecoration("Occupation", Icons.work, required: true),
            items: ["JOB", "BUSINESS"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: widget.onOccupationChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            validator: (val) => val == null ? "Occupation is required" : null,
            hint: const Text("Select Occupation"),
          ),
          const SizedBox(height: 12),

          // Income field
          _buildDropdown(
            controller: widget.incomeController,
            label: widget.occupation == "JOB"
                ? "Annual Income"
                : "Net Gross Profit",
            icon: Icons.money,
            options: _incomeRanges,
            validator: (val) =>
                val == null || val.isEmpty ? "income is required" : null,
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
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _inputDecoration(label, icon, required: true),
      validator: validator,
      inputFormatters: inputFormatters, 
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> options,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      value: options.contains(controller.text) ? controller.text : null,
      decoration: _inputDecoration(label, icon, required: true),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) => setState(() => controller.text = val ?? ""),
      validator: validator,
    );
  }

  List<String> get _incomeRanges => [
        "500000 - 1000000",
        "1000000 - 1500000",
        "1500000 - 2000000",
        "2000000 - 2500000",
        "2500000 - 3000000",
        "3000000 - 3500000",
        "3500000 - 4000000",
        "4000000 - 4500000",
        "4500000 - 5000000",
        "5000000+"
      ];
}
