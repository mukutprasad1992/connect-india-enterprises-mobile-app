import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/consts/appColors.dart';
import '/services/serviceType/CityApi.dart';
import '/services/serviceType/createServiceType.dart';
import '/services/serviceType/updateServiceType.dart' as updateApi;
import '/models/investmentModel.dart';
import '/models/citymodel.dart';
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
  int get lastStep => 5;
  int get firstStep => widget.mode == "edit" ? 1 : 0;

  String? selectedRelation, occupation, investmentType, selectIDType;
  String? DBId;

  // Files
  String? aadharFile, panFile, bankProofFile, salarySlipFile, itrFile;

  // Cities
  List<City> _cities = [];
  City? _selectedCity;
  bool _loadingCities = false;
  //bool setloadingBasicdetials false;
  bool _isSaving = false;

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

  int _currentStep = 1;
  int _viewStep = 1;
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

  Future<void> fetchCities() async {
    setState(() => _loadingCities = true);
    try {
      _cities =
          await CityApi.fetchCities(token: widget.token, context: context);

      if (widget.mode == "edit" && widget.investment != null) {
        final inv = widget.investment!;

        if (inv.placeOfBirth != null && inv.placeOfBirth is Map) {
          final cityName = inv.placeOfBirth?['city']?.toString() ?? '';
          final stateName = inv.placeOfBirth?['state']?.toString() ?? '';

          if (_cities.isNotEmpty) {
            final match = _cities.where(
              (c) => c.city == cityName && c.state == stateName,
            );

            if (match.isNotEmpty) {
              _selectedCity = match.first;
            } else {
              _selectedCity = null; // did not auto select
            }
          }
        }
      }
    } catch (e) {
      _showError("Error fetching cities: $e");
    } finally {
      setState(() => _loadingCities = false);
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    fetchCities().then((_) {
      _loadInvestmentData();

      // Show dialog only in add mode

      if (widget.mode == "add" && investmentType == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showInvestmentTypeDialog();
        });
      }
    });
  }

  /// Prefill + Auto Step Detection

  void _loadInvestmentData() {
    if (widget.mode != "edit" || widget.investment == null) {
      _currentStep = 1;
      _viewStep = 1;
      return;
    }

    final inv = widget.investment!;
    DBId = inv.id;
    _aadharController.text = inv.aadharNumber ?? '';
    _panController.text = inv.panNumber ?? '';
    _emailController.text = inv.email ?? '';

    // Mobile → UI me bina +91 dikhayenge
    if (inv.mobile != null && inv.mobile!.isNotEmpty) {
      _mobileController.text = inv.mobile!.startsWith('+91')
          ? inv.mobile!.substring(3)
          : inv.mobile!;
    }

    if (inv.nomineeMobile != null && inv.nomineeMobile!.isNotEmpty) {
      _nomineeMobileController.text = inv.nomineeMobile!.startsWith('+91')
          ? inv.nomineeMobile!.substring(3)
          : inv.nomineeMobile!;
    }
    // Occupation + Income
    occupation = inv.occupation;
    _incomeController.text = inv.income ?? '';

    // Nominee ID type
    if (inv.nomineeIdType == "aadharNumber") {
      selectIDType = "Aadhar";
      _nomineeIdController.text = inv.nomineeId ?? '';
    } else if (inv.nomineeIdType == "panNumber") {
      selectIDType = "PAN";
      _nomineeIdController.text = inv.nomineeId ?? '';
    }

    // Nominee Relation
    selectedRelation = inv.nomineeRelation;
    _nomineeRelationController.text = inv.nomineeRelation ?? '';

    // documents

    aadharFile = inv.aadharCardFileKey;
    panFile = inv.panCardFileKey;
    bankProofFile = inv.bankProofFileKey;
    salarySlipFile = inv.salarySlipsFileKey;
    itrFile = inv.itrDocumentsFileKey;
    // Investment Type
    investmentType = inv.investmentType;

    //Step Detection ===== it means we check data fill in which section if data not fill open that section in edit mode

    if (_aadharController.text.isEmpty || _panController.text.isEmpty) {
      _currentStep = 1;
    } else if (_emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _selectedCity == null ||
        occupation == null ||
        _incomeController.text.isEmpty) {
      _currentStep = 2;
    } else if (_nomineeIdController.text.isEmpty ||
        _nomineeMobileController.text.isEmpty ||
        (selectedRelation == null || selectedRelation!.isEmpty)) {
      _currentStep = 3;
    } else if ((aadharFile == null || aadharFile!.isEmpty) ||
        (panFile == null || panFile!.isEmpty) ||
        (bankProofFile == null || bankProofFile!.isEmpty) ||
        (occupation == "JOB" &&
            (salarySlipFile == null || salarySlipFile!.isEmpty)) ||
        (occupation == "BUSINESS" && (itrFile == null || itrFile!.isEmpty))) {
      _currentStep = 4;
    } else {
      _currentStep = 5;
    }
    //debugPrint("Aadhar from API 📤: ${inv.aadharCardFileKey}");

    _viewStep = _currentStep;
  }

  // Show error message
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange[600]),
    );
  }

  // Back button in stepper
  void _onStepCancel() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _viewStep = _currentStep;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<String?> saveSection(
      {required String section, int submitValue = 0}) async {
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
              : '+91 ${_nomineeMobileController.text}',
          nomineeRelation: selectedRelation ?? "",

          // --- City / Place of Birth
          placeOfBirth: _selectedCity != null
              ? {"city": _selectedCity!.city, "state": _selectedCity!.state}
              : null,

          aadharCardFileKey:
              (aadharFile?.isNotEmpty ?? false) ? aadharFile! : "",
          panCardFileKey: (panFile?.isNotEmpty ?? false) ? panFile! : "",
          bankProofFileKey:
              (bankProofFile?.isNotEmpty ?? false) ? bankProofFile! : "",
          salarySlipsFileKey:
              occupation == "JOB" && (salarySlipFile?.isNotEmpty ?? false)
                  ? salarySlipFile!
                  : "Null",
          itrDocumentsFileKey:
              occupation == "BUSINESS" && (itrFile?.isNotEmpty ?? false)
                  ? itrFile!
                  : "Null",
        );
        //debugPrint("Building UI → AadharFile📤: $aadharFile");

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
            case "review":
              message = submitValue == 1
                  ? "Investment Details Submitted Successfully!"
                  : "Review section updated!";
              break;
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
      //debugPrint(" Error updating section [$section]: $e");
      _showError("Failed to save $section: ${e.toString()}");
      return DBId;
    }
  }

  Future<void> _onStepContinue() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final totalSteps = 5;

      // ===== Final Step: Review & Submit =====
      if (_currentStep == 5) {
        if (!isDeclared) {
          _showError("Please confirm declaration");
          return;
        }

        DBId = await saveSection(section: "review", submitValue: 1);

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

      // ===== Other Steps (0 to 4) =====
      switch (_currentStep) {
        case 1:
          if (_basicFormKey.currentState!.validate()) {
            DBId = await saveSection(section: "basicDetails");
          } else
            return;
          break;

        case 2:
          if (_personalFormKey.currentState!.validate()) {
            if (occupation == null || occupation!.isEmpty) {
              _showError("Please select occupation");
              return;
            }
            DBId = await saveSection(section: "personalDetails");
          } else
            return;
          break;

        case 3:
          if (_nomineeFormKey.currentState!.validate()) {
            if (selectIDType == null || selectIDType!.isEmpty) {
              _showError("Please select Nominee ID type");
              return;
            }
            DBId = await saveSection(section: "nomineeDetails");
          } else
            return;
          break;

        case 4:
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
          break;
      }

      // ===== Move to next step only after API success =====
      setState(() {
        _currentStep++;
        _viewStep = _currentStep;
      });
    } finally {
      setState(() => _isSaving = false);
    }
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
            _buildHorizontalStepperAligned(),
            const SizedBox(height: 20),
            _buildStepContent(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onStepCancel,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(70, 36),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: AppColors.background,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(_currentStep == 0 ? "Cancel" : "Back"),
                ),
                //const SizedBox(width: 20),
                ElevatedButton(
                  //onPressed: _onStepContinue,
                  onPressed: _isSaving ? null : _onStepContinue,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(70, 36),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _currentStep == lastStep
                        ? (widget.mode == "add" ? "Submit" : "Update")
                        : "Next",
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

  String getStepTitle(int index) {
    switch (index) {
      case 1:
        return "Basic Details";
      case 2:
        return "Personal Details";
      case 3:
        return "Nominee Details";
      case 4:
        return "Document";
      case 5:
        return "Review";
      default:
        return "";
    }
  }

  Widget _buildHorizontalStepperAligned() {
    const stepCount = 5;
    final iconRadius = 16.0;
    final titleHeight = 20.0;

    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          // Base line
          Positioned(
            top: iconRadius,
            left: iconRadius,
            right: iconRadius,
            child: Container(
              height: 3,
              color: Colors.grey[300],
            ),
          ),
          // Progress line
          Positioned(
            top: iconRadius,
            left: iconRadius,
            width: (_currentStep - 1) /
                (stepCount - 1) *
                (MediaQuery.of(context).size.width - 2 * iconRadius),
            child: Container(
              height: 3,
              color: Colors.green,
            ),
          ),
          // Step icons + titles
          Row(
            children: List.generate(stepCount, (i) {
              int index = i + 1;
              bool isClickable = !(widget.mode == "edit" && index == 1);
              bool isActive = _viewStep == index;
              bool isCompleted = _currentStep > index;
              bool isNextIncomplete = index == _currentStep;
              bool isHovered = _hoveredStep == index;

              return Expanded(
                child: MouseRegion(
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
                    borderRadius: BorderRadius.circular(20),
                    splashColor: (isCompleted || isNextIncomplete)
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: isClickable
                        ? () async {
                            if (index <= _currentStep) {
                              setState(() => _viewStep = index);
                            } else {
                              _showError(
                                  "Please complete previous steps first");
                            }
                          }
                        : () {
                            // if (index == 1 && widget.mode == "edit") {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text(
                            //         "Investment Type section updated successfully",
                            //       ),
                            //       backgroundColor: Colors.green,
                            //     ),
                            //   );
                            // }
                          },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Circle Icon
                        CircleAvatar(
                          radius: iconRadius,
                          backgroundColor: isCompleted
                              ? Colors.green
                              : (isActive ? Colors.orange : Colors.grey[300]),
                          child: (isCompleted && !isActive)
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : Icon(
                                  _getStepIcon(index),
                                  size: 12,
                                  color: isCompleted
                                      ? Colors.white
                                      : (isActive ? Colors.white : Colors.grey),
                                ),
                        ),
                        const SizedBox(height: 6),
                        // Title
                        SizedBox(
                          height: titleHeight,
                          child: Center(
                            child: Text(
                              getStepTitle(index),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  IconData _getStepIcon(int index) {
    switch (index) {
      case 1:
        return Icons.person;
      case 2:
        return Icons.badge;
      case 3:
        return Icons.group;
      case 4:
        return Icons.description;
      case 5:
        return Icons.rate_review;
      default:
        return Icons.circle;
    }
  }
  // dialog box open for select investment type

  Future<void> _showInvestmentTypeDialog() async {
    String? tempSelection = investmentType;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Investment Type"),
          content: DropdownButtonFormField<String>(
            value: tempSelection,
            decoration: const InputDecoration(
              labelText: "Investment Type",
              border: OutlineInputBorder(),
            ),
            items: ["Mutual Funds"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              tempSelection = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tempSelection == null || tempSelection!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please select investment type")),
                  );
                  return;
                }
                setState(() {
                  investmentType = tempSelection;
                  _currentStep = 1; // start from Basic
                  _viewStep = 1;
                });
                Navigator.pop(context);
              },
              child: const Text("Next"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepContent() {
    switch (_viewStep) {
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
          activeSteps: "documents",
          onCompleted: (id) => setState(() => DBId = id),
          onUploaded: (files) async {
            setState(() {
              aadharFile = files["aadhar"];
              panFile = files["pan"];
              bankProofFile = files["bank"];
              salarySlipFile = files["salary"];
              itrFile = files["itr"];
            });
            if (DBId != null) {
              await saveSection(section: "documents");
            }
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

    Future<void> _viewFile(String fileUrl) async {
      final Uri url = Uri.parse(fileUrl);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showError("Could not open file");
      }
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
            const SizedBox(width: 12),
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
                    Icon(icon, size: 18, color: Colors.blueGrey),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
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
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
