import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/consts/appColors.dart';
import '../../../../../../services/user_module_service_Api/loanServices/createLoan.dart';
import '../../../../../../services/user_module_service_Api/loanServices/updateLoan.dart' as updateApi;
import '/models/loanModel.dart';
// Sections
import 'personalDetails.dart';
import 'contactDetails.dart';
import 'employmentDetails.dart';
import 'referenceDetails.dart';
import 'documents.dart';

class StepperFormPage extends StatefulWidget {
  final String mode;
  final String token;
  final LoanModel? loan;
  final String submit;
  final Function()? onAnySectionSaved;

  StepperFormPage({
    super.key,
    required this.submit,
    required this.mode,
    this.loan,
    required this.token,
    this.onAnySectionSaved,
  });

  @override
  State<StepperFormPage> createState() => _StepperFormPageState();
}

class _StepperFormPageState extends State<StepperFormPage> {
  bool isDeclared = false;
  int get lastStep => 6;
  Set<int> completedSteps = {};
  int get firstStep => widget.mode == "edit" ? 1 : 0;
  String? DBId;
  String? aadharFile,
      panFile,
      bankProofFile,
      salarySlipFile,
      photoFile,
      loanType;
  bool isLoading = false;

  // Form Keys

  final _personalFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  final _employmentFormKey = GlobalKey<FormState>();
  final _referenceFormKey = GlobalKey<FormState>();

  // Controllers of All Section

  // Personal Controller

  final _aadharController = TextEditingController();
  final _panController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  final _currentAddressController = TextEditingController();

  // Contact Controller

  final yearsOfCityController = TextEditingController();
  final alternateNoController = TextEditingController();
  final landmarkController = TextEditingController();

  // Employment Controller

  final designationController = TextEditingController();
  final companyExpController = TextEditingController();
  final totalWorkExpController = TextEditingController();
  final officeAddressController = TextEditingController();
  final officeMobileController = TextEditingController();

  // Reference Controller

  final ref1NameController = TextEditingController();
  final ref1MobileController = TextEditingController();
  final ref1AddressController = TextEditingController();
  final ref2NameController = TextEditingController();
  final ref2MobileController = TextEditingController();
  final ref2AddressController = TextEditingController();

  int _currentStep = 1;
  int _viewStep = 1;

  @override
  void dispose() {
    _aadharController.dispose();
    _panController.dispose();
    _motherNameController.dispose();
    _maritalStatusController.dispose();
    _currentAddressController.dispose();

    yearsOfCityController.dispose();
    alternateNoController.dispose();
    landmarkController.dispose();

    designationController.dispose();
    companyExpController.dispose();
    totalWorkExpController.dispose();
    officeAddressController.dispose();
    officeMobileController.dispose();

    ref1NameController.dispose();
    ref1MobileController.dispose();
    ref1AddressController.dispose();
    ref2NameController.dispose();
    ref2MobileController.dispose();
    ref2AddressController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == "edit" && widget.loan != null) {
      loadLoanData();
    }
  }

  // Prefill + Auto Step Detection

  void loadLoanData() {
    final inv = widget.loan!;
    DBId = inv.id;

    // Personal
    _aadharController.text = inv.aadharNumber ?? '';
    _panController.text = inv.panNumber ?? '';
    _motherNameController.text = inv.motherName ?? '';
    _maritalStatusController.text = inv.maritalStatus ?? '';
    _currentAddressController.text = inv.currentAddress ?? '';

    // Contact
    yearsOfCityController.text = inv.yearsOfCity?.toString() ?? '';
    landmarkController.text = inv.landmark ?? '';
    alternateNoController.text = inv.alternateNo ?? '';
    if (inv.alternateNo != null && inv.alternateNo!.isNotEmpty) {
      alternateNoController.text = inv.alternateNo!.startsWith('+91')
          ? inv.alternateNo!.substring(3)
          : inv.alternateNo!;
    }

    // Employment
    designationController.text = inv.designation ?? '';
    companyExpController.text = inv.companyExp?.toString() ?? '';
    totalWorkExpController.text = inv.totalWorkExp?.toString() ?? '';
    officeAddressController.text = inv.officeAddress ?? '';
    officeMobileController.text = inv.officeMobile ?? '';
    if (inv.officeMobile != null && inv.officeMobile!.isNotEmpty) {
      officeMobileController.text = inv.officeMobile!.startsWith('+91')
          ? inv.officeMobile!.substring(3)
          : inv.officeMobile!;
    }

    // Reference
    ref1NameController.text = inv.ref1Name ?? '';
    ref1AddressController.text = inv.ref1Address ?? '';
    ref1MobileController.text = inv.ref1Mobile ?? '';
    ref2NameController.text = inv.ref2Name ?? '';
    ref2AddressController.text = inv.ref2Address ?? '';
    ref2MobileController.text = inv.ref2Mobile ?? '';

    // Documents
    aadharFile = inv.aadharCardFileKey;
    panFile = inv.panCardFileKey;
    bankProofFile = inv.bankStatementFileKey;
    salarySlipFile = inv.salarySlipsFileKey;
    photoFile = inv.photoFileKey;
    loanType = inv.loanType;

    // Step detection
    void detectStep() {
      if (_aadharController.text.isEmpty ||
          _panController.text.isEmpty ||
          _motherNameController.text.isEmpty ||
          _maritalStatusController.text.isEmpty ||
          _currentAddressController.text.isEmpty) {
        _currentStep = 1;
        //completedSteps.add(1);
      } else if (yearsOfCityController.text.isEmpty ||
          landmarkController.text.isEmpty ||
          alternateNoController.text.isEmpty) {
        _currentStep = 2;
        completedSteps.add(1);
      } else if (designationController.text.isEmpty ||
          companyExpController.text.isEmpty ||
          totalWorkExpController.text.isEmpty ||
          officeAddressController.text.isEmpty ||
          officeMobileController.text.isEmpty) {
        _currentStep = 3;
        completedSteps.addAll({1, 2});
      } else if (ref1NameController.text.isEmpty ||
          ref1AddressController.text.isEmpty ||
          ref1MobileController.text.isEmpty ||
          ref2NameController.text.isEmpty ||
          ref2AddressController.text.isEmpty ||
          ref2MobileController.text.isEmpty) {
        _currentStep = 4;
        completedSteps.addAll({1, 2, 3});
      } else if ((aadharFile == null || aadharFile!.isEmpty) ||
          (panFile == null || panFile!.isEmpty) ||
          (bankProofFile == null || bankProofFile!.isEmpty) ||
          (salarySlipFile == null || salarySlipFile!.isEmpty) ||
          (photoFile == null || photoFile!.isEmpty)) {
        _currentStep = 5;
        completedSteps.addAll({1, 2, 3, 4});
      } else {
        _currentStep = 6;
        completedSteps.addAll({1, 2, 3, 4, 5});
      }
      _viewStep = _currentStep;
    }

    detectStep();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange[600]),
    );
  }

  // Back button in stepper
  void _onStepCancel() {
    if (_currentStep > firstStep) {
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
      // --- personal Details (Create Mode)

      if (DBId == null && section == "personalDetails") {
        final res = await CreateLoanService.createLoanByserviceType(
          token: widget.token,
          serviceId: "4",
          serviceSubType: "Personal loans",
          activeSteps: section,
          status: "Pending",
          aadharNumber: _aadharController.text,
          panNumber: _panController.text,
          motherName: _motherNameController.text,
          maritalStatus: _maritalStatusController.text,
          currentAddress: _currentAddressController.text,
        );

        if (res['status'] == true) {
          widget.onAnySectionSaved?.call();
          DBId = res['data']?['_id']?.toString() ?? res['data']?['id']?.toString();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Personal Details created successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          }
          
        } else {
          _showError(res['message'] ?? "Create API failed");
          return null;
        }
        return DBId;
      } else if (DBId == null) {
        _showError(
            "Missing record ID. Please complete Personal Details first.");
        return null;
      } else if (DBId != null) {
        final res = await updateApi.updateLoanService.updateLoanServiceTypeById(
          id: DBId!,
          token: widget.token,
          serviceId: "4",
          serviceSubType: loanType ?? "Personal loans",
          activeSteps: section,
          status: "Pending",
          submit: submitValue,

          // --- personal Details

          aadharNumber: _aadharController.text,
          panNumber: _panController.text,
          motherName: _motherNameController.text,
          maritalStatus: _maritalStatusController.text,
          currentAddress: _currentAddressController.text,

          //Contact  Details

          yearsOfCity: yearsOfCityController.text,
          alternateNo: (alternateNoController.text ).startsWith('+91')
              ? alternateNoController.text
              : '+91${alternateNoController.text}',

          landmark: landmarkController.text,

          // employment Details

          designation: designationController.text,
          companyExp: companyExpController.text,
          totalWorkExp: totalWorkExpController.text,
          officeAddress: officeAddressController.text,
          officeMobile: (officeMobileController.text).startsWith('+91')
              ? officeMobileController.text
              : '+91${officeMobileController.text}',

          // referenceDetails

          ref1Name: ref1NameController.text,
          ref1Address: ref1AddressController.text,
          ref1Mobile: (ref1MobileController.text).startsWith('+91')
              ? ref1MobileController.text
              : '+91${ref1MobileController.text}',

          ref2Name: ref2NameController.text,
          ref2Address: ref2AddressController.text,
          ref2Mobile: (ref2MobileController.text).startsWith('+91')
              ? ref2MobileController.text
              : '+91${ref2MobileController.text}',

          // documents

          aadharCardFileKey:
              (aadharFile?.isNotEmpty ?? false) ? aadharFile! : "",
          panCardFileKey: (panFile?.isNotEmpty ?? false) ? panFile! : "",
          photoFileKey: (photoFile?.isNotEmpty ?? false) ? photoFile! : "",

          bankStatementFileKey:
              (bankProofFile?.isNotEmpty ?? false) ? bankProofFile! : "",
          salarySlipsFileKey:
              (salarySlipFile?.isNotEmpty ?? false) ? salarySlipFile! : "",
        );


        if (res['status'] == true) {
          widget.onAnySectionSaved?.call();
          String message = "";
          switch (section) {
            case "personalDetails":
              message = "Personal Details updated successfully!";
              break;
            case "contactDetails":
            //  if (widget.mode == "edit")
            //       ? message = "Contact Details update successfully!";
              message = "Contact Details saved successfully!";
              break;
            case "employmentDetails":
              message = "Employment Details saved successfully!";
              break;
            case "referenceDetails":
              message = "Reference Details  saved successfully!";
              break;
            case "documents":
              if (aadharFile != null &&
                  panFile != null &&
                  bankProofFile != null &&
                  salarySlipFile != null &&
                  photoFile != null) {
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
      _showError("Failed to save $section: ${e.toString()}");
      return DBId;
    }
  }

  Future<void> _onStepContinue() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final totalSteps = 6;

      // ===== Final Step: Review & Submit =====

      if (_currentStep == 6) {
        if (!isDeclared) {
          _showError("Please confirm declaration");
          return;
        }
        DBId = await saveSection(section: "review", submitValue: 1);
        try {
          final res =
              await updateApi.updateLoanService.updateLoanServiceTypeById(
            id: DBId!,
            token: widget.token,
            serviceId: "4",
            serviceSubType: loanType ?? "Personal loans",
            status: "Pending",
            activeSteps: "review",
            submit: 1,
          );

          if (res['status'] == true) {
            widget.onAnySectionSaved?.call();
            completedSteps.add(_currentStep);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.mode == "add"
                    ? "Loan added successfully!"
                    : "Loan updated successfully!"),
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
      switch (_currentStep) {
        case 1:
          if (_personalFormKey.currentState!.validate()) {
            DBId = await saveSection(section: "personalDetails");
            completedSteps.add(_currentStep);
          } else
            return;
          break;

        case 2:
          if (_contactFormKey.currentState!.validate()) {
            DBId = await saveSection(section: "contactDetails");
            completedSteps.add(_currentStep);
          } else
            return;
          break;

        case 3:
          if (_employmentFormKey.currentState!.validate()) {
            DBId = await saveSection(section: "employmentDetails");
            completedSteps.add(_currentStep);
          } else
            return;
          break;
        case 4:
          if (_referenceFormKey.currentState!.validate()) {
            DBId = await saveSection(section: "referenceDetails");
            completedSteps.add(_currentStep);
          } else
            return;
          break;

        case 5:
          if ((aadharFile ?? '').isEmpty ||
              (panFile ?? '').isEmpty ||
              (bankProofFile ?? '').isEmpty ||
              (salarySlipFile ?? '').isEmpty ||
              (photoFile ?? '').isEmpty) {
            _showError("Please upload mandatory documents");
            return;
          }

          DBId = await saveSection(section: "documents");
          completedSteps.add(_currentStep);
          break;
      }
      // ===== Move to next step only after API success =====

      setState(() {
        if (_currentStep < totalSteps) {
          _currentStep++;
          _viewStep = _currentStep;
        }
      });
    } catch (e) {
      _showError("Step $_currentStep failed: ${e.toString()}");
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
          widget.mode == "add" ? "Add Loan" : "Edit Loan",
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
                        if (_currentStep > 1 && _currentStep <= lastStep)
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
                                  _currentStep == lastStep
                                      ? (widget.mode == "add"
                                          ? "Submit"
                                          : "Update")
                                      : "Next",
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
    const stepCount = 6;
    final iconRadius = 12.0;
    final titleHeight = 16.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final totalLineWidth = screenWidth - 4 * iconRadius;

    // ✅ Progress width based on completed steps
    final progressWidth = completedSteps.isEmpty
        ? 0.0
        : (completedSteps.length - 1) /
            (stepCount - 1) *
            (totalLineWidth - 2 * iconRadius);

    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          // Base line (gray)
          Positioned(
            top: iconRadius,
            left: 2 * iconRadius,
            width: totalLineWidth - 2 * iconRadius,
            child: Container(
              height: 2,
              color: Colors.grey[300],
            ),
          ),

          // ✅ Green progress line
          Positioned(
            top: iconRadius,
            left: 2 * iconRadius,
            width: progressWidth,
            child: Container(
              height: 2,
              color: Colors.green,
            ),
          ),

          // ✅ Step icons + titles
          Row(
            children: List.generate(stepCount, (i) {
              int index = i + 1;

              // ✅ New core logic (same visuals)
              bool isCompleted = completedSteps.contains(index);
              bool isActive = _viewStep == index;

              // find first incomplete step
              int firstIncomplete = completedSteps.isEmpty
                  ? 1
                  : (completedSteps.length < stepCount
                      ? completedSteps.length + 1
                      : stepCount);

              // ✅ allow click till one step ahead of completed
              bool isClickable = index <= firstIncomplete;

              // highlight first incomplete step with blue
              bool isNextIncomplete = index == firstIncomplete && !isCompleted;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: isClickable
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (isClickable) {
                      setState(() {
                        _viewStep = index;
                        _currentStep = index;
                      });
                    } else {
                      _showError("Please complete previous steps first");
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Step Circle
                      CircleAvatar(
                        radius: iconRadius,
                        backgroundColor: isCompleted
                            ? Colors.green
                            : (isActive
                                ? Colors.orange
                                : (isNextIncomplete
                                    ? Colors.blue
                                    : Colors.grey[300])),
                        child: (isCompleted && !isActive)
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 12)
                            : Icon(
                                _getStepIcon(index),
                                size: 10,
                                color: isCompleted
                                    ? Colors.white
                                    : (isActive || isNextIncomplete
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                      ),
                      const SizedBox(height: 4),

                      // ✅ Step Title
                      SizedBox(
                        height: titleHeight,
                        child: Center(
                          child: Text(
                            getStepTitle(index),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isActive
                                  ? Colors.orange
                                  : (isCompleted
                                      ? Colors.green
                                      : (isNextIncomplete
                                          ? Colors.blue
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
        return "Personal";
      case 2:
        return "Contact";
      case 3:
        return "Employment";
      case 4:
        return "Reference";
      case 5:
        return "Documents";
      case 6:
        return "Review";
      default:
        return "";
    }
  }

  Widget _buildStepContent() {
    switch (_viewStep) {
      case 1:
        return Personaldetails(
          formKey: _personalFormKey,
          aadharController: _aadharController,
          panController: _panController,
          motherNameController: _motherNameController,
          maritalStatusController: _maritalStatusController,
          currentAddressController: _currentAddressController,
          token: widget.token,
          serviceId: "4",
          loanType: loanType ?? '',
          mode: widget.mode,
          dbId: DBId,
          onCompleted: (id) => setState(() => DBId = id),
          activeSteps: "personalDetails",
        );

      case 2:
        return ContactDetails(
          formKey: _contactFormKey,
          yearsOfCityController: yearsOfCityController,
          alternateNoController: alternateNoController,
          landmarkController: landmarkController,
          token: widget.token,
          serviceId: "4",
          loanType: loanType ?? '',
          mode: widget.mode,
          dbId: DBId,
          activeSteps: "contactDetails",
          onCompleted: (id) => setState(() => DBId = id),
        );
      case 3:
        return Employmentdetails(
          formKey: _employmentFormKey,
          designationController: designationController,
          companyExpController: companyExpController,
          totalWorkExpController: totalWorkExpController,
          officeAddressController: officeAddressController,
          officeMobileController: officeMobileController,
          DBId: DBId,
          serviceId: 4,
          mode: widget.mode,
          token: widget.token,
          loanType: loanType ?? '',
          activeSteps: "employmentDetails",
          onCompleted: (id) => setState(() => DBId = id),
        );

      case 4:
        return ReferenceDetails(
          formKey: _referenceFormKey,
          ref1NameController: ref1NameController,
          ref1MobileController: ref1MobileController,
          ref1AddressController: ref1AddressController,
          ref2NameController: ref2NameController,
          ref2MobileController: ref2MobileController,
          ref2AddressController: ref2AddressController,
          DBId: DBId,
          serviceId: 4,
          mode: widget.mode,
          token: widget.token,
          loanType: loanType ?? '',
          activeSteps: "referenceDetails",
          onCompleted: (id) => setState(() => DBId = id),
        );

      case 5:
        return DocumentSection(
          existingFiles: {
            "aadhar": aadharFile,
            "pan": panFile,
            "bank": bankProofFile,
            "salary": salarySlipFile,
            "photo": photoFile,
          },
          DBId: DBId,
          token: widget.token,
          mode: widget.mode,
          serviceId: "4",
          loanType: loanType ?? '',
          activeSteps: "documents",
          onCompleted: (id) => setState(() => DBId = id),
          onUploaded: (files) async {
            setState(() {
              aadharFile = files["aadhar"];
              panFile = files["pan"];
              bankProofFile = files["bank"];
              salarySlipFile = files["salary"];
              photoFile = files["photo"];
            });
            if (DBId != null) {
              await saveSection(section: "documents");
            }
          },
        );
      case 6:
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
                onPressed: () => _viewFile(fileUrl),
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
            title: "Loan Details",
            icon: Icons.account_balance_wallet_rounded,
            children: [
              _buildInfoRow("Loan Type", loanType),
            ],
          ),
          _buildSection(
            title: "Personal Details",
            icon: Icons.person_rounded,
            children: [
              _buildInfoRow("Aadhar", _aadharController.text),
              _buildInfoRow("PAN", _panController.text),
              _buildInfoRow("Mother Name", _motherNameController.text),
              _buildInfoRow("Marital Status", _maritalStatusController.text),
              _buildInfoRow("Current Address", _currentAddressController.text),
            ],
          ),
          // contact Details
          _buildSection(
            title: "Contact Details",
            icon: Icons.person_rounded,
            children: [
              _buildInfoRow("Year Of City", yearsOfCityController.text),
              _buildInfoRow("Alternate Number", alternateNoController.text),
              _buildInfoRow("Land Mark", landmarkController.text),
            ],
          ),
          // Employment Details
          _buildSection(
              title: "Employment Details",
              icon: Icons.people_rounded,
              children: [
                _buildInfoRow("Designation", designationController.text),
                _buildInfoRow("Company Experiance", companyExpController.text),
                _buildInfoRow(
                    "Total Work Experiance", totalWorkExpController.text),
                _buildInfoRow("Office Address", officeAddressController.text),
                _buildInfoRow(
                    "Office Mobile Number", officeMobileController.text),
              ]),

          // reference Details

          _buildSection(
            title: "Reference Details",
            icon: Icons.people_rounded,
            children: [
              _buildInfoRow("Reference 1 Name", ref1NameController.text),
              _buildInfoRow("Reference 1 Mobile", ref1MobileController.text),
              _buildInfoRow("Reference 1 Address", ref1AddressController.text),
              _buildInfoRow("Reference 2 Name", ref2NameController.text),
              _buildInfoRow("Reference 2 Mobile", ref2MobileController.text),
              _buildInfoRow("Reference 2 Address", ref2AddressController.text),
            ],
          ),
          // Documents
          _buildSection(
            title: "Documents",
            icon: Icons.folder_rounded,
            children: [
              _buildDocumentRow("Aadhar", aadharFile),
              _buildDocumentRow("PAN", panFile),
              _buildDocumentRow("Bank Statement", bankProofFile),
              _buildDocumentRow("Salary Slip", salarySlipFile),
              _buildDocumentRow("Photo", photoFile),
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
