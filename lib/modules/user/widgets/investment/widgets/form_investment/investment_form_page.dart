import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/consts/appColors.dart';
import '/modules/user/widgets/investment/widgets/investment_models/Investment_model.dart';
import '/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';
import '/services/serviceType/CityApi.dart';
import '/services/serviceType/createServiceType.dart';
import '/services/serviceType/updateServiceType.dart' as updateApi;

// Sections
import 'basic_details_section.dart';
import 'personal_details_section.dart';
import 'nominee_details_section.dart';
import 'upload_documents_section.dart';

class InvestmentFormPage extends StatefulWidget {
  final String mode;
  final String token;
  final InvestmentModel? investment;
  final String submit;

  InvestmentFormPage({
    super.key,
    required this.submit,
    required this.mode,
    this.investment,
    required this.token,
  });

  @override
  State<InvestmentFormPage> createState() => _InvestmentFormPageState();
}

class _InvestmentFormPageState extends State<InvestmentFormPage> {
  bool isDeclared = false;
  int get lastStep => widget.mode == "edit" ? 4 : 5;
  int get firstStep => widget.mode == "edit" ? 1 : 0;

  String? selectedRelation, occupation, investmentType, selectIDType;
  String? DBId;

  // Files
  String? aadharFile, panFile, bankProofFile, salarySlipFile, itrFile;

  // Cities
  List<City> _cities = [];
  City? _selectedCity;
  bool _loadingCities = false;

  // Form Keys
  final _basicFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();
  final _nomineeFormKey = GlobalKey<FormState>();

  // Controllers
  final _aadharController = TextEditingController();
  final _panController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _birthController = TextEditingController();
  final _nomineeIdController = TextEditingController();
  final _nomineeMobileController = TextEditingController();
  final _nomineeRelationController = TextEditingController();
  final _incomeController = TextEditingController();

  int _currentStep = 0;
  int _viewStep = 0;
  int? _hoveredStep;

  @override
  void dispose() {
    _aadharController.dispose();
    _panController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _birthController.dispose();
    _nomineeIdController.dispose();
    _nomineeMobileController.dispose();
    _nomineeRelationController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void fetchCities() async {
    setState(() => _loadingCities = true);
    try {
      _cities =
          await CityApi.fetchCities(token: widget.token, context: context);
    } catch (e) {
      _showError("Error fetching cities: $e");
    } finally {
      setState(() => _loadingCities = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCities();
    _loadInvestmentData();
  }

  /// Prefill + Auto Step Detection
  void _loadInvestmentData() {
    if (widget.mode != "edit" || widget.investment == null) {
      _currentStep = 0; // add mode → Investment Type से start
      _viewStep = 0;
      return;
    }

    final inv = widget.investment!;
    DBId = inv.id;

    // ===== Prefill controllers =====
    _aadharController.text = inv.aadharNumber ?? '';
    _panController.text = inv.panNumber ?? '';
    _emailController.text = inv.email ?? '';
    _mobileController.text = inv.mobile != null && inv.mobile!.isNotEmpty
        ? (inv.mobile!.startsWith('+91') ? inv.mobile! : '+91${inv.mobile!}')
        : '';

    _nomineeMobileController.text = (() {
      final mobile = inv.nomineeMobile;
      if (mobile == null || mobile.isEmpty) return '';
      return mobile.startsWith('+91') ? mobile : '+91$mobile';
    })();

    if (inv.placeOfBirth != null && inv.placeOfBirth['id'] != null) {
      final cityId = inv.placeOfBirth['id'].toString();
      _selectedCity = _cities.firstWhere(
        (c) => c.id == cityId,
        orElse: () => City(id: cityId, city: '', state: ''),
      );
    }

    occupation = inv.occupation;
    _incomeController.text = (occupation == "JOB" || occupation == "BUSINESS")
        ? inv.income ?? ''
        : '';

    if (inv.nomineeIdType == "aadharNumber") {
      selectIDType = "Aadhar";
      _nomineeIdController.text = inv.nomineeId ?? '';
    } else if (inv.nomineeIdType == "panNumber") {
      selectIDType = "PAN";
      _nomineeIdController.text = inv.nomineeId ?? '';
    }

    _nomineeRelationController.text = inv.nomineeRelation ?? '';

    aadharFile = inv.aadhaarCardFileKey;
    panFile = inv.panCardFileKey;
    bankProofFile = inv.bankProofFileKey;
    salarySlipFile = inv.salarySlipsFileKey;
    itrFile = inv.itrDocumentsFileKey;

    investmentType = inv.investmentType;

    // ===== Step Detection =====
    if (_aadharController.text.isEmpty || _panController.text.isEmpty) {
      _currentStep = 1; // Basic Details
    } else if (_emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _selectedCity == null ||
        occupation == null ||
        (occupation == "JOB" && _incomeController.text.isEmpty) ||
        (occupation == "BUSINESS" && _incomeController.text.isEmpty)) {
      _currentStep = 2; // Personal Details
    } else if (_nomineeIdController.text.isEmpty ||
        _nomineeMobileController.text.isEmpty ||
        _nomineeRelationController.text.isEmpty) {
      _currentStep = 3; // Nominee
    } else if ((aadharFile == null || aadharFile!.isEmpty) ||
        (panFile == null || panFile!.isEmpty) ||
        (bankProofFile == null || bankProofFile!.isEmpty)) {
      _currentStep = 4; // Documents
    } else {
      _currentStep = 5; // Review
    }

    _viewStep = _currentStep;
  }

  Future<void> _viewFile(String fileUrl) async {
    final Uri url = Uri.parse(fileUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _showError("Could not open file");
    }
  }

  /// Show error message
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange[600]),
    );
  }

  /// Back button in stepper
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _viewStep = _currentStep;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<String?> saveSection({required String section}) async {
    try {
      // --- Basic Details (Create Mode)
      if (DBId == null && section == "basicDetails") {
        final res = await CreateServiceType.serviceType(
          token: widget.token,
          serviceId: "1",
          serviceSubType: "Mutual Funds",
          activeSteps: section,
          status: "Pending",
          aadharNumber: _aadharController.text,
          panNumber: _panController.text,
        );

        if (res['status'] == true) {
          DBId =
              res['data']?['_id']?.toString() ?? res['data']?['id']?.toString();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Basic Details created successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
        return DBId;
      } else if (DBId != null) {
        final int submitValue = section == "review" ? 1 : 0;

        final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
          id: DBId!,
          token: widget.token,
          serviceId: "1",
          serviceSubType: investmentType ?? "Mutual Funds",
          activeSteps: section,
          status: "Pending",
          submit: submitValue,

          // --- Personal Details
          occupation: occupation,
          income: _incomeController.text,
          aadharNumber: _aadharController.text,
          panNumber: _panController.text,
          email: _emailController.text,
          mobile: _mobileController.text.startsWith('+91')
              ? _mobileController.text
              : '+91${_mobileController.text}',

          // --- Nominee Details
          nomineeIdType: selectIDType?.toLowerCase() == "aadhar"
              ? "aadharNumber"
              : selectIDType?.toLowerCase() == "pan"
                  ? "panNumber"
                  : null,
          nomineeId: _nomineeIdController.text.isNotEmpty
              ? _nomineeIdController.text
              : null,
          nomineeMobile: _nomineeMobileController.text.startsWith('+91')
              ? _nomineeMobileController.text
              : '+91${_nomineeMobileController.text}',
          nomineeRelation: selectedRelation ?? "",

          // --- City / Place of Birth
          placeOfBirth: _selectedCity != null
              ? {"city": _selectedCity!.city, "state": _selectedCity!.state}
              : null,

          // --- Documents
          aadhaarCardFileKey:
              (aadharFile?.isNotEmpty ?? false) ? aadharFile! : "",
          panCardFileKey: (panFile?.isNotEmpty ?? false) ? panFile! : "",
          bankProofFileKey:
              (bankProofFile?.isNotEmpty ?? false) ? bankProofFile! : "",
          salarySlipsFileKey:
              (occupation == "JOB" && (salarySlipFile?.isNotEmpty ?? false))
                  ? salarySlipFile!
                  : "",
          itrDocumentsFileKey:
              (occupation == "BUSINESS" && (itrFile?.isNotEmpty ?? false))
                  ? itrFile!
                  : "",
        );

        if (res['status'] == true) {
          String message = "";
          switch (section) {
            case "personalDetails":
              message = "Personal Details saved successfully!";
              break;
            case "nomineeDetails":
              message = "Nominee Details saved successfully!";
              break;
            case "documents":
              message = "Documents uploaded successfully!";
              break;
            // case "review":
            //   message = "Review completed successfully!";
            //   break;
          }

          if (mounted && message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );
          }
        }
        return DBId;
      } else {
        return DBId;
      }
    } catch (e) {
      _showError("Failed to save $section: ${e.toString()}");
      return DBId;
    }
  }

  Future<void> _onStepContinue() async {
    final totalSteps = widget.mode == "edit" ? 5 : 6;

    // --- Last Step: Review / Declaration
    if (_currentStep >= totalSteps - 1) {
      if (!isDeclared) {
        _showError("Please confirm declaration");
        return;
      }

      DBId = await saveSection(section: "review");

      try {
        final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
          id: DBId!,
          token: widget.token,
          serviceId: "1",
          serviceSubType: investmentType ?? "Mutual Funds",
          status: "Pending",
          activeSteps: "review",
          submit: 1,
        );

        if (res['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.mode == "add"
                  ? "Investment added successfully!"
                  : "Investment updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception(res['message'] ?? "Unknown error from server");
        }
      } catch (e) {
        _showError("⚠️ Final Submit Failed: ${e.toString()}");
      }
      return;
    }

    switch (_currentStep) {
      case 0:
        if (widget.mode == "edit") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Investment Type section updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _currentStep++;
            _viewStep = _currentStep;
          });
          return;
        }
        if (investmentType == null || investmentType!.isEmpty) {
          _showError("Please select investment type");
          return;
        }
        DBId = await saveSection(section: "investmentType");
        break;

      case 1:
        if (_basicFormKey.currentState!.validate()) {
          DBId = await saveSection(section: "basicDetails");
        } else {
          return;
        }
        break;

      case 2:
        if (_personalFormKey.currentState!.validate()) {
          if (occupation == null || occupation!.isEmpty) {
            _showError("Please select occupation");
            return;
          }
          DBId = await saveSection(section: "personalDetails");
        } else {
          return;
        }
        break;

      case 3:
        if (_nomineeFormKey.currentState!.validate()) {
          if (selectIDType == null || selectIDType!.isEmpty) {
            _showError("Please select Nominee ID type");
            return;
          }
          DBId = await saveSection(section: "nomineeDetails");
        } else {
          return;
        }
        break;

      case 4:
        if (widget.mode == "add") {
          if ((aadharFile ?? '').isEmpty ||
              (panFile ?? '').isEmpty ||
              (bankProofFile ?? '').isEmpty) {
            _showError("Please upload mandatory documents");
            return;
          }
          if (occupation == "JOB" && (salarySlipFile ?? '').isEmpty) {
            _showError("Please upload Salary Slip");
            return;
          }
          if (occupation == "BUSINESS" && (itrFile ?? '').isEmpty) {
            _showError("Please upload ITR Document");
            return;
          }
          DBId = await saveSection(section: "documents");
        }
        break;
    }
    setState(() {
      _currentStep++;
      _viewStep = _currentStep;
    });
  }

  // =================== UI & Sections (UNCHANGED) ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == "add" ? "Add Investment" : "Edit Investment",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVerticalProgressBar(),
            const SizedBox(height: 20),
            _buildStepContent(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onStepCancel,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(90, 40),
                    backgroundColor: AppColors.background,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentStep == 0 ? "Cancel" : "Back"),
                ),
                ElevatedButton(
                  onPressed: _onStepContinue,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(90, 40),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _currentStep == lastStep ? "Update" : "Next",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =================== Stepper ===================
  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return "Investment Type";
      case 1:
        return "Basic Details";
      case 2:
        return "Personal Details";
      case 3:
        return "Nominee Details";
      case 4:
        return "Documents";
      case 5:
        return "Review";
      default:
        return "";
    }
  }

  Widget _buildVerticalProgressBar() {
    return Column(
      children: List.generate(6, (index) {
        // --- Investment Type step is non-clickable in edit mode
        bool isClickable = !(widget.mode == "edit" && index == 0);

        bool isActive = index == _viewStep;
        bool isCompleted = index < _currentStep;
        bool isNextIncomplete = index == _currentStep;
        bool isHovered = _hoveredStep == index;

        return MouseRegion(
          onEnter: (_) {
            setState(() {
              if (isCompleted) _hoveredStep = index;
            });
          },
          onExit: (_) {
            setState(() {
              if (_hoveredStep == index) _hoveredStep = null;
            });
          },
          child: InkWell(
            splashColor: (isCompleted || isNextIncomplete)
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            onTap: isClickable
                ? () async {
                    // Jump to clicked step only if previous steps are completed
                    if (index <= _currentStep) {
                      setState(() => _viewStep = index);
                    } else {
                      _showError("Please complete previous steps first");
                    }
                  }
                : () {
                    if (index == 0 && widget.mode == "edit") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Investment Type section updated successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isHovered && isCompleted
                    ? Colors.blue.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: isCompleted
                            ? Colors.green
                            : (isActive ? Colors.orange : Colors.grey[300]),
                        child: (isCompleted && !isActive)
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color:
                                      isActive ? Colors.white : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      if (index != 5)
                        Container(
                          width: 4,
                          height: 40,
                          color: isCompleted ? Colors.green : Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        if (isActive)
                          const Icon(Icons.arrow_forward,
                              color: Colors.blue, size: 16),
                        if (isActive) const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _getStepTitle(index),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? Colors.orange
                                  : (isCompleted
                                      ? Colors.green
                                      : (isNextIncomplete
                                          ? Colors.orange
                                          : Colors.black87)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_viewStep) {
      case 0:
        if (widget.mode == "edit") {
          return Text(
            investmentType ?? "Not Provided",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          );
        }
        return DropdownButtonFormField<String>(
          value: (["Mutual Funds"].contains(investmentType))
              ? investmentType
              : null,
          decoration: const InputDecoration(labelText: "Investment Type"),
          items: ["Mutual Funds"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() {
              investmentType = val;
            });
          },
        );
      case 1:
        return BasicDetailsSection(
          formKey: _basicFormKey,
          aadharController: _aadharController,
          panController: _panController,
          token: widget.token,
          serviceId: "1",
          investmentType: investmentType ?? '',
          mode: widget.mode,
          dbId: DBId,
          onCompleted: (id) => setState(() => DBId = id),
          activeSteps: "basicDetails",
        );
      case 2:
        return PersonalDetailsSection(
          formKey: _personalFormKey,
          emailController: _emailController,
          mobileController: _mobileController,
          incomeController: _incomeController,
          occupation: occupation,
          cities: _cities,
          selectedCity: _selectedCity,
          loadingCities: _loadingCities,
          dbId: DBId,
          token: widget.token,
          serviceId: "1",
          investmentType: investmentType ?? '',
          mode: widget.mode,
          activeSteps: "personalDetails",
          onCityChanged: (city) => setState(() => _selectedCity = city),
          onOccupationChanged: (val) => setState(() => occupation = val),
          onCompleted: (id) => setState(() => DBId = id),
        );
      case 3:
        return NomineeDetailsSection(
          formKey: _nomineeFormKey,
          nomineeIdController: _nomineeIdController,
          nomineeMobileController: _nomineeMobileController,
          nomineeRelationController: _nomineeRelationController,
          selectedRelation: selectedRelation,
          selectIDType: selectIDType,
          onIDTypeChanged: (val) => setState(() => selectIDType = val),
          onRelationChanged: (val) => setState(() => selectedRelation = val),
          DBId: DBId,
          serviceId: 1,
          mode: widget.mode,
          token: widget.token,
          investmentType: investmentType ?? '',
          email: _emailController.text.trim(),
          income: _incomeController.text.trim(),
          occupation: occupation,
          placeOfBirth: _selectedCity == null
              ? null
              : {"city": _selectedCity!.city, "state": _selectedCity!.state},
          activeSteps: "nomineeDetails",
          onCompleted: (id) => setState(() => DBId = id),
        );

      case 4:
        return UploadDocumentSection(
          occupation: occupation,
          existingFiles: {
            "aadhar": aadharFile,
            "pan": panFile,
            "bank": bankProofFile,
            "salary": salarySlipFile,
            "itr": itrFile,
          },
          DBId: DBId,
          token: widget.token,
          mode: widget.mode,
          serviceId: "1",
          investmentType: investmentType ?? '',
          activeSteps: "Documents",
          onCompleted: (id) => setState(() => DBId = id),
          onUploaded: (files) {
            setState(() {
              aadharFile = files["aadhar"];
              panFile = files["pan"];
              bankProofFile = files["bank"];
              salarySlipFile = files["salary"];
              itrFile = files["itr"];
            });
          },
        );

      case 5:
        return _buildReviewSection();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildReviewSection() {
    Widget _buildInfoRow(String label, String? value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                (value != null && value.isNotEmpty) ? value : "Not Provided",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDocumentRow(String name, String? fileUrl) {
      bool isUploaded = fileUrl != null && fileUrl.isNotEmpty;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded ? Colors.green : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Text(
              isUploaded ? "Uploaded" : "Not Uploaded",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isUploaded ? Colors.green : Colors.red,
              ),
            ),
            if (isUploaded) const SizedBox(width: 12),
            if (isUploaded)
              TextButton(
                onPressed: () => _viewFile(fileUrl!),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "View",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
          ],
        ),
      );
    }

    Widget _buildSection({
      required String title,
      required List<Widget> children,
      IconData? icon,
    }) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Icon(icon, size: 22, color: Colors.blueGrey),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: "Investment Details",
            icon: Icons.account_balance_wallet_rounded,
            children: [
              _buildInfoRow("Investment Type", investmentType),
              _buildInfoRow("Occupation", occupation),
              if (occupation == "JOB")
                _buildInfoRow("Annual Income", _incomeController.text),
            ],
          ),
          // Personal Details
          _buildSection(
            title: "Personal Details",
            icon: Icons.person_rounded,
            children: [
              _buildInfoRow("Aadhar", _aadharController.text),
              _buildInfoRow("PAN", _panController.text),
              _buildInfoRow("Email", _emailController.text),
              _buildInfoRow("Mobile", _mobileController.text),
              _buildInfoRow(
                "Place of Birth",
                _selectedCity != null
                    ? "${_selectedCity!.city}, ${_selectedCity!.state}"
                    : "Not Provided",
              ),
            ],
          ),
          // Nominee Details
          _buildSection(
            title: "Nominee Details",
            icon: Icons.people_rounded,
            children: [
              _buildInfoRow("Nominee ID", _nomineeIdController.text),
              _buildInfoRow("Nominee Mobile", _nomineeMobileController.text),
              _buildInfoRow("Nominee Relation",
                  selectedRelation ?? _nomineeRelationController.text),
            ],
          ),
          // Documents
          _buildSection(
            title: "Documents",
            icon: Icons.folder_rounded,
            children: [
              _buildDocumentRow("Aadhar", aadharFile),
              _buildDocumentRow("PAN", panFile),
              _buildDocumentRow("Bank Proof", bankProofFile),
              if (occupation == "JOB")
                _buildDocumentRow("Salary Slip", salarySlipFile),
              if (occupation == "BUSINESS")
                _buildDocumentRow("ITR Document", itrFile),
            ],
          ),
          const SizedBox(height: 16),
          // Declaration Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isDeclared,
                onChanged: (val) => setState(() => isDeclared = val ?? false),
              ),
              const Expanded(
                child: Text(
                  "I hereby declare that the information provided above is correct.",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
