import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/consts/appColors.dart';
import '/modules/user/widgets/investment/widgets/investment_models/Investment_model.dart';
import '/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';
import '/services/serviceType/CityApi.dart';
//import '/services/serviceType/updateServiceType.dart' as updateApi;

// Sections
import 'basic_details_section.dart';
import 'personal_details_section.dart';
import 'nominee_details_section.dart';
import 'upload_documents_section.dart';
import 'review_section.dart';

class InvestmentFormPage extends StatefulWidget {
  final String mode;
  final String token;
  final InvestmentModel? investment;
  final String isDetailsConfirmed;

  InvestmentFormPage({
    super.key,
    required this.isDetailsConfirmed,
    required this.mode,
    this.investment,
    required this.token,
  });

  @override
  State<InvestmentFormPage> createState() => _InvestmentFormPageState();
}

class _InvestmentFormPageState extends State<InvestmentFormPage> {
  final GlobalKey<ReviewSectionState> _reviewSectionKey =
      GlobalKey<ReviewSectionState>();

  //int _currentStep = 0;
  bool isDeclared = false;
  bool isOtherSelected = false;

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
  final _annualIncomeController = TextEditingController();
  final _netGrossProfitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCities();
    _loadInvestmentData();
    if (widget.mode == "edit" && widget.investment != null) {
      DBId = widget.investment!.id;
    }
  }

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
    _annualIncomeController.dispose();
    _netGrossProfitController.dispose();
    super.dispose();
  }

  // ---------------- API Helpers for fetchCities  ----------------

  void fetchCities() async {
    setState(() => _loadingCities = true);

    try {
      // Use modified CityApi with context for safe token handling
      _cities = await CityApi.fetchCities(
        token: widget.token,
        context: context, // required for AuthController redirect
      );
    } catch (e) {
      _showError("Error fetching cities: $e");
    } finally {
      setState(() => _loadingCities = false);
    }
  }
  //---------------- end api fetchCities --------------------

  void _loadInvestmentData() {
    if (widget.mode != "edit" || widget.investment == null) return;

    final inv = widget.investment!;
    _aadharController.text = inv.aadharNumber;
    _panController.text = inv.panNumber;
    _emailController.text = inv.email;
    _mobileController.text = inv.mobile;

    if (inv.placeOfBirth['id'] != null) {
      final cityId = inv.placeOfBirth['id'].toString();
      _selectedCity = _cities.firstWhere(
        (c) => c.id == cityId,
        orElse: () => City(id: cityId, city: '', state: ''),
      );
    }

    occupation = inv.occupation;
    _annualIncomeController.text = inv.income;
    _netGrossProfitController.text = inv.income;

    if (inv.nomineeIdType == "aadharNumber") {
      selectIDType = "Aadhar";
      _nomineeIdController.text = inv.nomineeId ?? '';
    } else if (inv.nomineeIdType == "panNumber") {
      selectIDType = "PAN";
      _nomineeIdController.text = inv.nomineeId ?? '';
    }

    _nomineeMobileController.text = inv.nomineeMobile ?? '';
    _nomineeRelationController.text = inv.nomineeRelation ?? '';

    // Files
    aadharFile = inv.aadhaarCardFileKey;
    panFile = inv.panCardFileKey;
    bankProofFile = inv.bankProofFileKey;
    salarySlipFile = inv.salarySlipsFileKey;
    itrFile = inv.itrDocumentsFileKey;

    investmentType = inv.investmentType;
  }

  Future<void> _viewFile(String fileUrl) async {
    final Uri url = Uri.parse(fileUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _showError(" Could not open file");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange[600]),
    );
  }

  // ---------------- Stepper Navigation ----------------

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

  Future<void> _onStepContinue() async {
    switch (_currentStep) {
      case 0:
        if (investmentType == null) {
          _showError("Please select investment type");
          return;
        }
        setState(() {
          _currentStep++;
          _viewStep = _currentStep; // 👈 add this
        });
        break;

      case 1: // Basic Details
        if (_basicFormKey.currentState!.validate()) {
          setState(() {
            _currentStep++;
            _viewStep = _currentStep; // 👈 add this
          });
        } else {
          _showError("Please complete Basic Details");
        }
        break;

      case 2: // Personal Details
        if (_personalFormKey.currentState!.validate()) {
          if (occupation == null) {
            _showError("Please select occupation");
            return;
          }
          setState(() {
            _currentStep++;
            _viewStep = _currentStep;
          });
        } else {
          _showError("Please complete Personal Details");
        }
        break;

      case 3: // Nominee Details
        if (_nomineeFormKey.currentState!.validate()) {
          if (selectIDType == null) {
            _showError("Please select Nominee ID type");
            return;
          }
          setState(() {
            _currentStep++;
            _viewStep = _currentStep;
          });
        } else {
          _showError("Please complete Nominee Details");
        }
        break;

      case 4: // Upload Documents
        if ((aadharFile ?? '').isEmpty ||
            (panFile ?? '').isEmpty ||
            (bankProofFile ?? '').isEmpty) {
          _showError("Please upload mandatory documents");
          return;
        }

        if (occupation == "JOB" && salarySlipFile == null) {
          _showError("Please upload Salary Slip");
          return;
        }
        if (occupation == "BUSINESS" && itrFile == null) {
          _showError("Please upload ITR Document");
          return;
        }

        setState(() {
          _currentStep++;
          _viewStep = _currentStep;
        });
        break;

      case 5:
        if (!isDeclared) {
          _showError("Please confirm declaration");
          return;
        }

        final reviewState = _reviewSectionKey.currentState;
        if (reviewState != null) {
          final dbId = await reviewState.submitDetails();
          if (dbId != null) {
            Navigator.pop(context, true);
          }
        }
        break;
    }
  }

  // ----------------  stepper UI  code ----------------

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == "add" ? "Add Investment" : "Edit Investment",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Vertical Progress Bar
            _buildVerticalProgressBar(),
            const SizedBox(height: 20),

            // 🔹 Step Content
            _buildStepContent(),
            const SizedBox(height: 30),

            // 🔹 Navigation Buttons
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
                  child: Text(_currentStep == 5
                      ? (widget.mode == "add" ? "Submit" : "Update")
                      : "Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
  // view section when user click on completed section

  Widget buildStepContent() {
    switch (_viewStep) {
      case 0:
        return Text("Step 1: Investment Type");
      case 1:
        return Text("Step 2: Basic Details");
      case 2:
        return Text("Step 3: Personal Details");
      case 3:
        return Text("Step 4: Nominee Details");
      case 4:
        return Text("Step 5: Documents");
      case 5:
        return Text("Step 6: Review ");
      default:
        return Text("Unknown Step");
    }
  }
  // stepper code active step completed and color changes

  int _currentStep = 0;
  int _viewStep = 0;
  int? _hoveredStep;

  Widget _buildVerticalProgressBar() {
    return Column(
      children: List.generate(6, (index) {
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
                // ignore: deprecated_member_use
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            onTap: (isCompleted || isNextIncomplete)
                ? () {
                    setState(() {
                      _viewStep = index;
                    });
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isHovered && isCompleted
                    // ignore: deprecated_member_use
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
                  Row(
                    children: [
                      if (isActive)
                        Icon(Icons.arrow_forward,
                            color: Colors.brown, size: 16),
                      if (isActive) SizedBox(width: 4),
                      Text(
                        _getStepTitle(index),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:isActive ? FontWeight.bold : FontWeight.normal,
                          color: (isActive && isNextIncomplete)
                          ? Colors.orange 
                          : isActive
                              ? Colors.green
                              : (isCompleted
                                  ? Colors.green
                                  : (isNextIncomplete
                                      ? Colors.orange 
                                      : Colors.black87)),
                        ),
                      ),
                    ],
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
        return DropdownButtonFormField<String>(
          initialValue: (["Mutual Funds", "Stocks"].contains(investmentType))
              ? investmentType
              : null,
          decoration: const InputDecoration(labelText: "Investment Type"),
          items: ["Mutual Funds", "Stocks"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => investmentType = val),
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
        );

      case 2:
        return PersonalDetailsSection(
          formKey: _personalFormKey,
          emailController: _emailController,
          mobileController: _mobileController,
          annualIncomeController: _annualIncomeController,
          netGrossProfitController: _netGrossProfitController,
          occupation: occupation,
          cities: _cities,
          selectedCity: _selectedCity,
          loadingCities: _loadingCities,
          dbId: DBId,
          token: widget.token,
          serviceId: "1",
          investmentType: investmentType,
          mode: widget.mode,
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
          isOtherSelected: isOtherSelected,
          onIDTypeChanged: (val) => setState(() => selectIDType = val),
          onRelationChanged: (val) {
            setState(() {
              selectedRelation = val;
              isOtherSelected = val == "Other";
            });
          },
          DBId: DBId,
          serviceId: 1,
          mode: widget.mode,
          token: widget.token,
          investmentType: investmentType,
          email: _emailController.text.trim(),
          mobile: "+91${_mobileController.text.trim()}",
          income: _annualIncomeController.text.trim(),
          occupation: occupation,
          placeOfBirth: _selectedCity == null
              ? null
              : {
                  "city": _selectedCity!.city,
                  "state": _selectedCity!.state,
                },
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
        return ReviewSection(
          key: _reviewSectionKey,
          dbId: DBId,
          isDetailsConfirmed: "1",
          token: widget.token,
          onCompleted: (id) => setState(() => DBId = id),
          mode: widget.mode,
          investmentType: investmentType,
          occupation: occupation,
          annualIncomeController: _annualIncomeController,
          netGrossProfitController: _netGrossProfitController,
          aadharController: _aadharController,
          panController: _panController,
          emailController: _emailController,
          mobileController: _mobileController,
          placeOfBirth: _selectedCity == null
              ? null
              : {
                  "city": _selectedCity!.city,
                  "state": _selectedCity!.state,
                },
          nomineeIdType: selectIDType?.toLowerCase(),
          nomineeIdController: _nomineeIdController,
          nomineeMobileController: _nomineeMobileController,
          nomineeRelation: selectedRelation,
          nomineeRelationController: _nomineeRelationController,
          aadharFile: aadharFile,
          panFile: panFile,
          bankProofFile: bankProofFile,
          salarySlipFile: salarySlipFile,
          itrFile: itrFile,
          selectedCity: _selectedCity != null
              ? "${_selectedCity!.city}, ${_selectedCity!.state}"
              : null,
          isDeclared: isDeclared,
          onDeclareChanged: (val) => setState(() => isDeclared = val ?? false),
          onViewFile: _viewFile,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
