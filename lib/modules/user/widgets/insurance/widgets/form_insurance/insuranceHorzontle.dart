import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/consts/appColors.dart';
import '/services/cityApi/CityApi.dart';
import '/services/serviceType/insuranceServices/createInsurance.dart';
import '/services/serviceType/insuranceServices/updateInsurance.dart'
    as updateApi;
import '/models/insuranceModel.dart';
import '/models/citymodel.dart';
// Sections
import 'basic_details_section.dart';
import 'personal_details_section.dart';
import 'nominee_details_section.dart';
import 'upload_documents_section.dart';

class StepperFormPage extends StatefulWidget {
  final String mode;
  final String token;
  final InsuranceModel? insurance;
  final String submit;

  StepperFormPage({
    super.key,
    required this.submit,
    required this.mode,
    this.insurance,
    required this.token,
  });

  @override
  State<StepperFormPage> createState() => _StepperFormPageState();
}

class _StepperFormPageState extends State<StepperFormPage> {
  bool isDeclared = false;
  int get lastStep => 5;
  int get firstStep => widget.mode == "edit" ? 1 : 0;

  String? selectedRelation,
      smoker,
      alcohol,
      occupation,
      insuranceType,
      selectIDType;
  String? DBId;
  // Files
  String? aadharFile, panFile, bankProofFile, salarySlipFile, itrFile;
  List<City> _cities = [];
  City? selectedCity;
  bool _loadingCities = false;
  bool isLoading = false;
  final _basicFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();
  final _nomineeFormKey = GlobalKey<FormState>();

  final aadharController = TextEditingController();
  final panController = TextEditingController();

  // Personal Details

  final birthController = TextEditingController();
  final motherNameController = TextEditingController();
  final heightCMController = TextEditingController();
  final weightKGController = TextEditingController();
  final incomeController = TextEditingController();

  // Nominee Details

  final nomineeNameController = TextEditingController();
  final nomineeDOBController = TextEditingController();
  final nomineeRelationController = TextEditingController();

  int currentStep = 1;
  int viewStep = 1;
  int? hoveredStep;

  @override
  void dispose() {
    aadharController.dispose();
    panController.dispose();

    birthController.dispose();
    motherNameController.dispose();
    weightKGController.dispose();
    heightCMController.dispose();
    incomeController.dispose();

    nomineeNameController.dispose();
    nomineeDOBController.dispose();
    nomineeRelationController.dispose();

    super.dispose();
  }

  Future<void> fetchCities() async {
    setState(() => _loadingCities = true);
    try {
      _cities =
          await CityApi.fetchCities(token: widget.token, context: context);

      if (widget.mode == "edit" && widget.insurance != null) {
        final inv = widget.insurance!;

        if (inv.placeOfBirth != null && inv.placeOfBirth is Map) {
          final cityName = inv.placeOfBirth?['city']?.toString() ?? '';
          final stateName = inv.placeOfBirth?['state']?.toString() ?? '';

          if (_cities.isNotEmpty) {
            final match = _cities.where(
              (c) => c.city == cityName && c.state == stateName,
            );

            if (match.isNotEmpty) {
              selectedCity = match.first;
            } else {
              selectedCity = null;
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
      _loadInsuranceData();
    });
  }

  /// Prefill + Auto Step Detection

  void _loadInsuranceData() {
    if (widget.mode != "edit" || widget.insurance == null) {
      currentStep = 1;
      viewStep = 1;
      return;
    }

    final inv = widget.insurance!;
    DBId = inv.id;
    aadharController.text = inv.aadharNumber ?? '';
    panController.text = inv.panNumber ?? '';

    // personal Details

    motherNameController.text = inv.motherName ?? '';
    weightKGController.text = inv.weightKG ?? '';
    heightCMController.text = inv.heightCM ?? '';
    smoker = inv.smoker ?? '';
    alcohol = inv.alcohol ?? '';

    occupation = inv.occupation;
    incomeController.text = inv.income ?? '';

    // Nominee Relation

    nomineeNameController.text = inv.nomineeName ?? '';
    nomineeDOBController.text = inv.nomineeDOB ?? '';
    selectedRelation = inv.nomineeRelation;
    nomineeRelationController.text = inv.nomineeRelation ?? '';

    // documents

    aadharFile = inv.aadharCardFileKey;
    panFile = inv.panCardFileKey;
    bankProofFile = inv.bankProofFileKey;
    salarySlipFile = inv.salarySlipsFileKey;
    itrFile = inv.itrDocumentsFileKey;
    // Investment Type
    insuranceType = inv.insuranceType;

    //Step Detection ===== it means we check data fill in which section if data not fill open that section in edit mode

    if (aadharController.text.isEmpty || panController.text.isEmpty) {
      currentStep = 1;
    } else if (motherNameController.text.isEmpty ||
        weightKGController.text.isEmpty ||
        heightCMController.text.isEmpty ||
        smoker == null ||
        alcohol == null ||
        selectedCity == null ||
        occupation == null ||
        incomeController.text.isEmpty) {
      currentStep = 2;
    } else if (nomineeNameController.text.isEmpty ||
        nomineeDOBController.text.isEmpty ||
        (selectedRelation == null || selectedRelation!.isEmpty)) {
      currentStep = 3;
    } else if ((aadharFile == null || aadharFile!.isEmpty) ||
        (panFile == null || panFile!.isEmpty) ||
        (bankProofFile == null || bankProofFile!.isEmpty) ||
        (occupation == "JOB" &&
            (salarySlipFile == null || salarySlipFile!.isEmpty)) ||
        (occupation == "BUSINESS" && (itrFile == null || itrFile!.isEmpty))) {
      currentStep = 4;
    } else {
      currentStep = 5;
    }
    //debugPrint("Aadhar from API 📤: ${inv.aadharCardFileKey}");

    viewStep = currentStep;
  }

  // Show error message
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange[600]),
    );
  }

  // Back button in stepper
  void _onStepCancel() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
        viewStep = currentStep;
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
        final res = await CreateInsuranceService.createInsurancebyserviceType(
          token: widget.token,
          serviceId: "3",
          serviceSubType: "Life insurance policies",
          activeSteps: section,
          status: "Pending",
          aadharNumber: aadharController.text,
          panNumber: panController.text,
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
        final res = await updateApi.updateInsuranceService
            .updateInsuranceServiceTypeById(
          id: DBId!,
          token: widget.token,
          serviceId: "3",
          serviceSubType: insuranceType ?? "Life insurance policies",
          activeSteps: section,
          status: "Pending",
          submit: submitValue,

          // --- Personal Details

          placeOfBirth: selectedCity != null
              ? {"city": selectedCity!.city, "state": selectedCity!.state}
              : null,

          occupation: occupation,
          income: incomeController.text,
          motherName: motherNameController.text,
          weightKG: weightKGController.text,
          heightCM: heightCMController.text,
          smoker: smoker,
          alcohol: alcohol,

          // --- Nominee Details

          nomineeName: nomineeNameController.text.isNotEmpty
              ? nomineeNameController.text
              : null,
          nomineeDOB: nomineeDOBController.text.isNotEmpty
              ? nomineeDOBController.text
              : null,
          nomineeRelation: selectedRelation ?? "",

          // --- Documents

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
              if (aadharFile != null &&
                  panFile != null &&
                  bankProofFile != null &&
                  salarySlipFile != null &&
                  itrFile != null) {
                message = "All documents uploaded successfully!";
              }
              break;
            case "review":
              message = submitValue == 1
                  ? "Updated all section"
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
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final totalSteps = 5;

      // ===== Final Step: Review & Submit =====
      if (currentStep == 5) {
        if (!isDeclared) {
          _showError("Please confirm declaration");
          return;
        }
        DBId = await saveSection(section: "review", submitValue: 1);
        try {
          final res = await updateApi.updateInsuranceService
              .updateInsuranceServiceTypeById(
            id: DBId!,
            token: widget.token,
            serviceId: "3",
            serviceSubType: insuranceType ?? "Life insurance policies",
            status: "Pending",
            activeSteps: "review",
            submit: 1,
          );

          if (res['status'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.mode == "add"
                    ? "Insurance added successfully!"
                    : "Insurance updated successfully!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else {
            throw Exception(res['message'] ?? "Unknown error from server");
          }
        } catch (e) {
          _showError(" Final Submit Failed: ${e.toString()}");
        }
        return;
      }

      // ===== Other Steps (1 to 4) =====
      switch (currentStep) {
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
            } else if (smoker == null || smoker!.isEmpty) {
              _showError("Please select smoker");
              return;
            } else if (alcohol == null || alcohol!.isEmpty) {
              _showError("Please select alcohol");
              return;
            }
            DBId = await saveSection(section: "personalDetails");
          } else
            return;
          break;

        case 3:
          if (_nomineeFormKey.currentState!.validate()) {
            if (selectedRelation == null || selectedRelation!.isEmpty) {
              _showError("Please select selectedRelation ");
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
      //  Move to next step only after API success =====

      setState(() {
        if (currentStep < totalSteps) {
          currentStep++;
          viewStep = currentStep;
        }
      });
    } catch (e) {
      // Agar backend error aaya toh wahi step me ruko
      _showError("Step $currentStep failed: ${e.toString()}");
      return;
    } finally {
      setState(() => isLoading = false);
    }
  }

  // =================== UI & Sections (UNCHANGED) ===================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == "add" ? "Add Insurance" : "Edit Insurance",
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
            Column(
              children: [
                _buildHorizontalStepperAligned(),
                const SizedBox(height: 20),
                _buildStepContent(),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentStep > 1 && currentStep < lastStep)
                          ElevatedButton(
                            onPressed: _onStepCancel,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(70, 36),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              backgroundColor: AppColors.background,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 14),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text("Back"),
                          )
                        else
                          const SizedBox(width: 70),
                        ElevatedButton(
                          onPressed: isLoading ? null : _onStepContinue,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(70, 36),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  currentStep < lastStep
                                      ? "Next"
                                      : (widget.mode == "add"
                                          ? "Submit"
                                          : "Update"),
                                ),
                        ),
                      ],
                    ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.mode == "add"
                                  ? "Saving your data, please wait..."
                                  : "Updating your data, please wait...",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =================== Stepper ===================

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
            width: (currentStep - 1) /
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
              bool isClickable;
              if (widget.mode == "add") {
                isClickable = index <= currentStep;
              } else {
                if (index <= currentStep) {
                  isClickable = true;
                } else {
                  isClickable = false;
                }
              }

              bool isActive = viewStep == index;
              bool isCompleted = currentStep > index;
              bool isNextIncomplete = index == currentStep;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: isClickable
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: isClickable
                      ? () {
                          setState(() => viewStep = index);
                        }
                      : () {
                          _showError("Please complete previous steps first");
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

  // dialog box open for select Insurance type

  Widget _buildStepContent() {
    switch (viewStep) {
      case 1:
        return BasicDetailsSection(
          formKey: _basicFormKey,
          aadharController: aadharController,
          panController: panController,
          token: widget.token,
          serviceId: "3",
          insuranceType: insuranceType ?? '',
          mode: widget.mode,
          dbId: DBId,
          onCompleted: (id) => setState(() => DBId = id),
          activeSteps: "basicDetails",
        );

      case 2:
        return PersonalDetailsSection(
          formKey: _personalFormKey,
          motherNameController: motherNameController,
          weightKGController: weightKGController,
          heightCMController: heightCMController,
          smoker: smoker,
          alcohol: alcohol,
          incomeController: incomeController,
          occupation: occupation,
          cities: _cities,
          selectedCity: selectedCity,
          loadingCities: _loadingCities,
          dbId: DBId,
          token: widget.token,
          serviceId: "3",
          insuranceType: insuranceType ?? '',
          mode: widget.mode,
          activeSteps: "personalDetails",
          onSmokerChanged: (val) => setState(() => smoker = val),
          onAlcoholChanged: (val) => setState(() => alcohol = val),
          onCityChanged: (city) => setState(() => selectedCity = city),
          onOccupationChanged: (val) => setState(() => occupation = val),
          onCompleted: (id) => setState(() => DBId = id),
        );
      case 3:
        return NomineeDetailsSection(
          formKey: _nomineeFormKey,
          nomineeNameController: nomineeNameController,
          nomineeDOBController: nomineeDOBController,
          nomineeRelationController: nomineeRelationController,
          selectedRelation: selectedRelation,
          onRelationChanged: (val) => setState(() => selectedRelation = val),
          DBId: DBId,
          serviceId: 3,
          mode: widget.mode,
          token: widget.token,
          insuranceType: insuranceType ?? '',
          income: incomeController.text.trim(),
          occupation: occupation,
          placeOfBirth: selectedCity == null
              ? null
              : {"city": selectedCity!.city, "state": selectedCity!.state},
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
          serviceId: "3",
          insuranceType: insuranceType ?? '',
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
            title: "Insurance Details",
            icon: Icons.account_balance_wallet_rounded,
            children: [
              _buildInfoRow("Insurance Type", insuranceType),
              _buildInfoRow("Occupation", occupation),
              if (occupation == "JOB")
                _buildInfoRow("Annual Income", incomeController.text),
            ],
          ),
          // Personal Details
          _buildSection(
            title: "Personal Details",
            icon: Icons.person_rounded,
            children: [
              _buildInfoRow("MotherName", motherNameController.text),
              _buildInfoRow("Weoght", weightKGController.text),
              _buildInfoRow("Height", heightCMController.text),
              _buildInfoRow("Smoker", smoker),
              _buildInfoRow("Alcohol", alcohol),
              _buildInfoRow(
                "Place of Birth",
                selectedCity != null
                    ? "${selectedCity!.city}, ${selectedCity!.state}"
                    : "Not Provided",
              ),
            ],
          ),
          // Nominee Details
          _buildSection(
            title: "Nominee Details",
            icon: Icons.people_rounded,
            children: [
              _buildInfoRow("Nominee Name", nomineeNameController.text),
              _buildInfoRow("Nominee DOB", nomineeDOBController.text),
              _buildInfoRow("Nominee Relation",
                  selectedRelation ?? nomineeRelationController.text),
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
