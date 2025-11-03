import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/investmentController/InvesrmentformController.dart';
//import '/consts/appColors.dart';
import '../../../../../../services/user_module_service_Api/investmentServices/updateServiceType.dart' as updateApi;
import '/models/citymodel.dart';
//import '/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';

class PersonalDetailsSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController incomeController;
  final String? occupation;
  final List<City> cities;
  final City? selectedCity;
  final bool loadingCities;
  final String? dbId;
  final String token;
  final String serviceId;
  final String? investmentType;
  final String mode;
  final String activeSteps;
  final Function(String dbId) onCompleted;
  final Function(City?) onCityChanged;
  final Function(String?) onOccupationChanged;

  const PersonalDetailsSection({
    super.key,
    required this.activeSteps,
    required this.formKey,
    required this.emailController,
    required this.mobileController,
    required this.incomeController,
    required this.occupation,
    required this.cities,
    required this.selectedCity,
    required this.loadingCities,
    required this.dbId,
    required this.token,
    required this.serviceId,
    required this.investmentType,
    required this.mode,
    required this.onCompleted,
    required this.onCityChanged,
    required this.onOccupationChanged,
  });

  @override
  State<PersonalDetailsSection> createState() => _PersonalDetailsSectionState();
}

class _PersonalDetailsSectionState extends State<PersonalDetailsSection> {
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
          if (required) const Text(" *", style: TextStyle(color: Colors.red,fontSize:13)),
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
      final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
        id: widget.dbId!,
        token: widget.token,
        serviceId: "1",
        serviceSubType: "Mutual Funds",
        activeSteps: "personalDetails",
        status: "Pending",
        email: widget.emailController.text.trim(),
        mobile: widget.mobileController.text.trim(),
        occupation: widget.occupation,
        income: widget.incomeController.text.trim(),
        placeOfBirth: widget.selectedCity != null
            ? {
                "city": widget.selectedCity!.city,
                "state": widget.selectedCity!.state,
              }
            : null,
      );

      //print("📥 API Response: $res");

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
          _buildTextField(
            controller: widget.emailController,
            
            label: "Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: AddInvestmentController.validateEmail,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: widget.mobileController,
            style: const TextStyle(fontSize: 14),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration:_inputDecoration("Mobile Number", Icons.phone, required: true).copyWith(prefixText: "+91 "),
            validator: AddInvestmentController.validatePhone,
            onSaved: (value) {
              if (value != null && value.length == 10) {
                widget.mobileController.text = '$value';
              }
            },
          ),
          const SizedBox(height: 12),

          widget.loadingCities
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<City>(
                  isExpanded: true,
                  value: widget.selectedCity,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(fontSize: 14,color: Colors.black),
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
                  validator: (val) => val == null ? "Please select city" : null,
                ),
          const SizedBox(height: 12),

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
            style: const TextStyle(fontSize: 14,color: Colors.black),
            validator: (val) => val == null ? "Please select occupation" : null,
            hint: const Text("Select Occupation"),
          ),

          const SizedBox(height: 12),

          // Income field for both JOB and BUSINESS
          _buildDropdown(
            controller: widget.incomeController,
            
            label: widget.occupation == "JOB"
                ? "Annual Income"
                : "Net Gross Profit",
            icon: Icons.money,
            options: _incomeRanges,
            validator: (val) =>
                val == null || val.isEmpty ? "Please select income" : null,
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
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _inputDecoration(label, icon, required: true),
      validator: validator,
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
      style: const TextStyle(fontSize: 14,color: Colors.black),
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
        "2000000 - 3000000",
        "3000000 - 4000000",
        "4000000 - 5000000",
        "5000000+"
      ];
}
