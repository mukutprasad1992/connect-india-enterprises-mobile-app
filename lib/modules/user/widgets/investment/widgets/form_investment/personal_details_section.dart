import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/controllers/usercontroller/investmentController/InvesrmentformController.dart';
import '/consts/appColors.dart';
import '/services/serviceType/updateServiceType.dart' as updateApi;
import '/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';

class PersonalDetailsSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController annualIncomeController;
  final TextEditingController netGrossProfitController;

  final String? occupation;
  final List<City> cities;
  final City? selectedCity;
  final bool loadingCities;

  final String? dbId;
  final String token;
  final String serviceId;
  final String? investmentType;
  final String mode;

  final Function(String dbId) onCompleted;
  final Function(City?) onCityChanged;
  final Function(String?) onOccupationChanged;

  const PersonalDetailsSection({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.mobileController,
    required this.annualIncomeController,
    required this.netGrossProfitController,
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

  /// 🔹 Submit personal details to backend
  Future<String?> submitDetails() async {
    if (!widget.formKey.currentState!.validate() || widget.dbId == null) {
      return null;
    }

    setState(() => _isLoading = true);

    try {
      final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
        id: widget.dbId!,
        token: widget.token,
        serviceId: widget.serviceId,
        serviceSubType: widget.investmentType,
        activeSteps: "personalDetails",
        status: "Pending",
        email: widget.emailController.text.trim(),
        mobile: "+91${widget.mobileController.text.trim()}",
        income: widget.annualIncomeController.text.trim(),
        netGrossProfit: widget.netGrossProfitController.text.trim(),
        occupation: widget.occupation,
        placeOfBirth: widget.selectedCity == null
            ? {}
            : {
                "city": widget.selectedCity!.city,
                "state": widget.selectedCity!.state,
              },
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
          _buildTextField(
            controller: widget.emailController,
            label: "Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: AddInvestmentController.validateEmail,
          ),
          const SizedBox(height: 12),

          /// Mobile Number
          TextFormField(
            controller: widget.mobileController,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration:
                _inputDecoration("Mobile Number", Icons.phone, required: true)
                    .copyWith(prefixText: "+91 "),
            validator: AddInvestmentController.validatePhone,
          ),
          const SizedBox(height: 12),

          /// Place of Birth
          widget.loadingCities
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<City>(
                  isExpanded: true,
                  value: widget.selectedCity,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      val == null ? "Please select city" : null,
                ),
          const SizedBox(height: 12),

          /// Occupation
          DropdownButtonFormField<String>(
            value: widget.occupation,
            decoration:
                _inputDecoration("Occupation", Icons.work, required: true),
            items: ["JOB", "BUSINESS"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: widget.onOccupationChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) => val == null ? "Please select occupation" : null,
          ),
          const SizedBox(height: 12),

          /// Income/Profit based on Occupation
          if (widget.occupation == "JOB")
            _buildDropdown(
              controller: widget.annualIncomeController,
              label: "Annual Income",
              icon: Icons.money,
              options: _incomeRanges,
              validator: (val) => val == null || val.isEmpty
                  ? "Please select annual income"
                  : null,
            )
          else if (widget.occupation == "BUSINESS")
            _buildDropdown(
              controller: widget.netGrossProfitController,
              label: "Net Gross Profit",
              icon: Icons.bar_chart,
              options: _incomeRanges,
              validator: (val) => val == null || val.isEmpty
                  ? "Please select net gross profit "
                  : null,
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
      value: controller.text.isNotEmpty ? controller.text : null,
      decoration: _inputDecoration(label, icon, required: true),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) => controller.text = val ?? "",
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
