// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '/consts/appColors.dart';
// import '/modules/user/widgets/investment/widgets/investment_models/Investment_model.dart';
// import '/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';
// import '/services/serviceType/CityApi.dart';
// import '/services/serviceType/createServiceType.dart';
// import '/services/serviceType/updateServiceType.dart' as updateApi;

// import 'basic_details_section.dart';
// import 'personal_details_section.dart';
// import 'nominee_details_section.dart';
// import 'upload_documents_section.dart';
// import 'review_section.dart';

// class InvestmentFormPage extends StatefulWidget {
//   final String mode;
//   final String token;
//   final InvestmentModel? investment;
//   final String isDetailsConfirmed;

//   const InvestmentFormPage({
//     super.key,
//     required this.isDetailsConfirmed,
//     required this.mode,
//     this.investment,
//     required this.token,
//   });

//   @override
//   _InvestmentFormPageState createState() => _InvestmentFormPageState();
// }

// class _InvestmentFormPageState extends State<InvestmentFormPage> {
//   int _currentStep = 0;
//   bool isDeclared = false;
//   bool isOtherSelected = false;
//   bool _isLoading = false;

//   String? selectedRelation, occupation, investmentType, selectIDType;
//   String? serviceId = "1";
//   String? DBId;
//   String isDetailsConfirmed = "1";

//   String? aadharFile, panFile, bankProofFile, salarySlipFile, itrFile;

//   List<City> _cities = [];
//   City? _selectedCity;
//   bool _loadingCities = false;

//   final _basicFormKey = GlobalKey<FormState>();
//   final _personalFormKey = GlobalKey<FormState>();
//   final _nomineeFormKey = GlobalKey<FormState>();

//   final _aadharController = TextEditingController();
//   final _panController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _birthController = TextEditingController();
//   //final _nomineeIdController = TextEditingController();
//   final _nomineeadharController = TextEditingController();
//   final _nomineepanController = TextEditingController();
  
//   final _nomineeMobileController = TextEditingController();
//   final _nomineeRelationController = TextEditingController();
//   final _annualIncomeController = TextEditingController();
//   final _netGrossProfitController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchCities();
//     _loadInvestmentData();
//     if (widget.mode == "edit" && widget.investment != null) {
//       DBId = widget.investment!.id;
//     }
//   }

//   void _fetchCities() async {
//     setState(() => _loadingCities = true);
//     try {
//       _cities = await CityApi.fetchCities();
//     } catch (e) {
//       _showError("Error fetching cities: $e");
//     } finally {
//       setState(() => _loadingCities = false);
//     }
//   }

//   void _loadInvestmentData() {
//     if (widget.mode == "edit" && widget.investment != null) {
//       final inv = widget.investment!;
//       _aadharController.text = inv.aadharNumber;
//       _panController.text = inv.panNumber;
//       _emailController.text = inv.email;
//       _mobileController.text = inv.mobile;
//       if (inv.placeOfBirth.isNotEmpty) {
//         _birthController.text =
//             "${inv.placeOfBirth['city'] ?? ''}, ${inv.placeOfBirth['state'] ?? ''}";
//       } else {
//         _birthController.clear();
//       }
//       occupation = inv.occupation;
//       _annualIncomeController.text = inv.income;
//       _netGrossProfitController.text = inv.income;
//       _nomineeIdController.text = inv.nomineeId;
//       _nomineeadharController.text=inv.nomineeadhar;
//       _nomineepanController.text=inv.nomineepanController;
//       _nomineeMobileController.text = inv.nomineeMobile;
//       _nomineeRelationController.text = inv.nomineeRelation;

//       aadharFile = inv.aadhaarCardFileKey;
//       panFile = inv.panCardFileKey;
//       bankProofFile = inv.bankProofFileKey;
//       salarySlipFile = inv.salarySlipsFileKey;
//       itrFile = inv.itrDocumentsFileKey;
//       investmentType = inv.investmentType;
//     }
//   }

//   @override
//   void dispose() {
//     _aadharController.dispose();
//     _panController.dispose();
//     _emailController.dispose();
//     _mobileController.dispose();
//     _birthController.dispose();
//    // _nomineeIdController.dispose();
//     _nomineepanController.dispose();
//     _nomineeadharController.dispose();
//     _nomineeMobileController.dispose();
//     _nomineeRelationController.dispose();
//     _annualIncomeController.dispose();
//     _netGrossProfitController.dispose();
//     super.dispose();
//   }

//   Future<void> _viewFile(String fileUrl) async {
//     final Uri url = Uri.parse(fileUrl);
//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       _showError(" Could not open file");
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: Colors.red),
//     );
//   }

//   InputDecoration _inputDecoration(String label, IconData icon,
//       {bool required = false, String? prefixText}) {
//     return InputDecoration(
//       prefixIcon: Icon(icon, color: AppColors.background, size: 20),
//       prefixText: prefixText,
//       label: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(label),
//           if (required) const Text(" *", style: TextStyle(color: Colors.red)),
//         ],
//       ),
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }

//   void _onStepCancel() {
//     if (_currentStep > 0) {
//       setState(() => _currentStep--);
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   Future<void> _onStepContinue() async {
//     switch (_currentStep) {
//       case 0: // Investment Type
//         if (investmentType != null) {
//           setState(() => _currentStep++);
//         } else {
//           _showError("Please select investment type");
//         }
//         break;

//       case 1:
//         if (_basicFormKey.currentState!.validate()) {
//           try {
//             if (DBId == null && widget.mode == "add") {
//               final res = await CreateServiceType.serviceType(
//                 stepStatus: "basicDetails",
//                 panNumber: _panController.text.trim(),
//                 aadharNumber: _aadharController.text.trim(),
//                 serviceId: "1",
//                 serviceSubType: investmentType ?? "",
//                 status: "Pending",
//                 token: widget.token,
//               );

//               if (res['status'] == true) {
//                 DBId = res['data']?['id']?.toString();
//                 if (DBId == null) {
//                   throw Exception("Service ID not returned by backend");
//                 }
//               } else {
//                 throw Exception(
//                     res['message'] ?? "Unknown error creating service type");
//               }
//             }

//             await updateApi.ServiceTypeApi.updateServiceTypeById(
//               id: DBId!,
//               serviceId: "1",
//               serviceSubType: investmentType ?? "",
//               status: "Pending",
//               stepStatus: "basicDetails",
//               token: widget.token,
//             );

//             setState(() => _currentStep++);
//           } catch (e) {
//             _showError("Error in Basic Details: $e");
//           }
//         }
//         break;

//       case 2:
//         if (_personalFormKey.currentState!.validate()) {
//           if (occupation == null) {
//             _showError("Please select occupation");
//             return;
//           }
//           try {
//             await updateApi.ServiceTypeApi.updateServiceTypeById(
//               id: DBId!,
//               serviceId: "1",
//               serviceSubType: investmentType ?? "",
//               email: _emailController.text,
//               income: occupation == "JOB"
//                   ? _annualIncomeController.text
//                   : _netGrossProfitController.text,
//               mobile: _mobileController.text,
//               occupation: occupation ?? "",
//               placeOfBirth: _selectedCity == null
//                   ? {}
//                   : {
//                       "city": _selectedCity!.city,
//                       "state": _selectedCity!.state,
//                     },
//               status: "Pending",
//               stepStatus: "personalDetails",
//               token: widget.token,
//             );
//             setState(() => _currentStep++);
//           } catch (e) {
//             _showError("Error in Personal Details: $e");
//           }
//         }
//         break;

//       case 3:
//         if (_nomineeFormKey.currentState!.validate()) {
//           if (DBId == null) {
//             _showError("Service ID missing. Please complete Basic Details.");
//             return;
//           }
//           try {
//             await updateApi.ServiceTypeApi.updateServiceTypeById(
//               id: DBId!,
//               serviceId: "1",
//               //nomineeId: _nomineeIdController.text,
//               nomineeadhar:_nomineeadharController,
//               nomineepan:_nomineepanController,
//               nomineeMobile: _nomineeMobileController.text,
//               nomineeRelation: _nomineeRelationController.text,
//               status: "Pending",
//               stepStatus: "nomineeDetails",
//               token: widget.token,
//             );
//             setState(() => _currentStep++);
//           } catch (e) {
//             _showError("Error in Nominee Details: $e");
//           }
//         }
//         break;

//       case 4:
//         if (aadharFile == null || panFile == null || bankProofFile == null) {
//           _showError("Please upload mandatory documents");
//           return;
//         } else if (occupation == "JOB" && salarySlipFile == null) {
//           _showError("Please upload Salary Slip");
//           return;
//         } else if (occupation == "BUSINESS" && itrFile == null) {
//           _showError("Please upload ITR Document");
//           return;
//         } else {
//           try {
//             await updateApi.ServiceTypeApi.updateServiceTypeById(
//               id: DBId!,
//               serviceId: "1",
//               aadhaarCardFileKey: aadharFile,
//               panCardFileKey: panFile,
//               bankProofFileKey: bankProofFile,
//               salarySlipsFileKey: salarySlipFile,
//               itrDocumentsFileKey: itrFile,
//               status: "Pending",
//               stepStatus: "documentDetails",
//               token: widget.token,
//             );
//             setState(() => _currentStep++);
//           } catch (e) {
//             _showError("Error in Document Upload: $e");
//           }
//         }
//         break;

//       case 5:
//         if (!isDeclared) {
//           _showError("Please confirm declaration");
//         } else {
//           try {
//             await updateApi.ServiceTypeApi.updateServiceTypeById(
//               id: DBId!,
//               serviceId: "1",
//               isDetailsConfirmed: 1,
//               status: "Submitted",
//               stepStatus: "review",
//               token: widget.token,
//             );

//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(widget.mode == "add"
//                     ? "Investment added successfully!"
//                     : "Investment updated successfully!"),
//                 backgroundColor: Colors.green,
//               ),
//             );

//             Navigator.pop(context, DBId);
//           } catch (e) {
//             _showError("Error in Final Submit: $e");
//           }
//         }
//         break;
//     }
//   }

//   void _submitInvestment() {
//     final newInvestment = InvestmentModel(
//       id: DBId!,
//       email: _emailController.text,
//       mobile: _mobileController.text,
//       investmentType: investmentType ?? '',
//       amount: occupation == "JOB"
//           ? _annualIncomeController.text
//           : _netGrossProfitController.text,
//       aadharNumber: _aadharController.text,
//       aadhaarCardFileKey: aadharFile ?? '',
//       panNumber: _panController.text,
//       panCardFileKey: panFile ?? '',
//       bankProofFileKey: bankProofFile ?? '',
//       salarySlipsFileKey: salarySlipFile,
//       itrDocumentsFileKey: itrFile,
//       placeOfBirth: _selectedCity == null
//           ? {}
//           : {
//               "city": _selectedCity!.city,
//               "state": _selectedCity!.state,
//             },
//       income: occupation == "JOB"
//           ? _annualIncomeController.text
//           : _netGrossProfitController.text,
//       occupation: occupation ?? '',
//       nomineeId: _nomineeIdController.text,
//       nomineeMobile: _nomineeMobileController.text,
//       nomineeRelation: _nomineeRelationController.text,
//       isDetailsConfirmed: 1,
//       status: 'Pending',
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(widget.mode == "add"
//             ? "Investment added successfully!"
//             : "Investment updated successfully!"),
//         backgroundColor: Colors.green,
//       ),
//     );

//     Navigator.pop(context, newInvestment);
//   }

//   Widget buildFileLink(String label, String? fileUrl) {
//     if (fileUrl == null) return Text("$label: Not uploaded");
//     return InkWell(
//       onTap: () async {
//         final uri = Uri.parse(fileUrl);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         }
//       },
//       child: Text(
//         "$label: View File",
//         style: const TextStyle(
//           color: Colors.blue,
//           decoration: TextDecoration.underline,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.mode == "add" ? "Add Investment" : "Edit Investment",
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppColors.background,
//         foregroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Stepper(
//         type: StepperType.vertical,
//         currentStep: _currentStep,
//         onStepContinue: _onStepContinue,
//         onStepCancel: _onStepCancel,
//         controlsBuilder: (context, details) => Row(
//           children: [
//             ElevatedButton(
//               onPressed: details.onStepCancel,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(90, 40),
//                 backgroundColor: AppColors.background,
//                 foregroundColor: Colors.white,
//               ),
//               child: Text(_currentStep == 0 ? "Cancel" : "Back"),
//             ),
//             const SizedBox(width: 25),
//             ElevatedButton(
//               onPressed: details.onStepContinue,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(90, 40),
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//               child: Text(_currentStep == 5
//                   ? (widget.mode == "add" ? "Submit" : "Update")
//                   : "Next"),
//             ),
//           ],
//         ),
//         steps: [
//           Step(
//             title: const Text("Investment Type"),
//             isActive: _currentStep >= 0,
//             content: DropdownButtonFormField<String>(
//               value: investmentType,
//               decoration: _inputDecoration("Investment Type", Icons.list,
//                   required: true),
//               items: ["Mutual Funds/SIP", "Stocks"]
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                   .toList(),
//               onChanged: (val) => setState(() => investmentType = val),
//             ),
//           ),
//           Step(
//             title: const Text("Basic Details"),
//             isActive: _currentStep >= 1,
//             content: BasicDetailsSection(
//               formKey: _basicFormKey,
//               aadharController: _aadharController,
//               panController: _panController,
//               token: widget.token,
//               serviceId: "1",
//               investmentType: investmentType ?? '',
//               onServiceCreated: (id) {
//                 setState(() => DBId = id);
//                 setState(() => _currentStep++);
//               },
//             ),
//           ),
//           Step(
//             title: const Text("Personal Details"),
//             isActive: _currentStep >= 2,
//             content: PersonalDetailsSection(
//               serviceId: 1,
//               formKey: _personalFormKey,
//               emailController: _emailController,
//               mobileController: _mobileController,
//               annualIncomeController: _annualIncomeController,
//               netGrossProfitController: _netGrossProfitController,
//               occupation: occupation,
//               onOccupationChanged: (val) => setState(() => occupation = val),
//               cities: _cities,
//               selectedCity: _selectedCity,
//               loadingCities: _loadingCities,
//               onCityChanged: (val) => setState(() => _selectedCity = val),
//               DBId: DBId,
//               mode: widget.mode,
//               token: widget.token,
//               investmentType: investmentType,
//             ),
//           ),
//           Step(
//             title: const Text("Nominee Details"),
//             isActive: _currentStep >= 3,
//             content: NomineeDetailsSection(

//               serviceId: 1,
//               formKey: _nomineeFormKey,
//               //nomineeIdController: _nomineeIdController,
//               nomineeadharController:_nomineeadharController,
//               nomineepanController:_nomineepanController,
//               nomineeMobileController: _nomineeMobileController,
//               nomineeRelationController: _nomineeRelationController,
//               selectedRelation: selectedRelation,
//               selectIDType: selectIDType,
//               isOtherSelected: isOtherSelected,
//               onIDTypeChanged: (val) => setState(() => selectIDType = val),
//               onRelationChanged: (val) {
//                 setState(() {
//                   selectedRelation = val;
//                   isOtherSelected = val == "Other";
//                   _nomineeRelationController.text =
//                       (val != "Other") ? val ?? '' : '';
//                 });
//               },
//               DBId: DBId,
//               mode: widget.mode,
//               token: widget.token,
//               investmentType: investmentType,
//               email: _emailController.text,
//               mobile: _mobileController.text,
//               income: occupation == "JOB"
//                   ? _annualIncomeController.text
//                   : _netGrossProfitController.text,
//               occupation: occupation,
//               placeOfBirth: _selectedCity == null
//                   ? {}
//                   : {
//                       "city": _selectedCity!.city,
//                       "state": _selectedCity!.state,
//                     },
//             ),
//           ),
//           Step(
//             title: const Text("Upload Document"),
//             isActive: _currentStep >= 4,
//             content: UploadDocumentSection(
//               occupation: occupation,
//               existingFiles: {
//                 "aadhar": aadharFile,
//                 "pan": panFile,
//                 "bank": bankProofFile,
//                 "salary": salarySlipFile,
//                 "itr": itrFile,
//               },
//               onUploaded: (files) {
//                 setState(() {
//                   aadharFile = files["aadhar"];
//                   panFile = files["pan"];
//                   bankProofFile = files["bank"];
//                   salarySlipFile = files["salary"];
//                   itrFile = files["itr"];
//                 });
//               },
//             ),
//           ),
//           Step(
//             title: const Text("Review & Submit"),
//             isActive: _currentStep >= 5,
//             content: ReviewSection(
//               investmentType: investmentType,
//               occupation: occupation,
//               annualIncomeController: _annualIncomeController,
//               netGrossProfitController: _netGrossProfitController,
//               aadharController: _aadharController,
//               panController: _panController,
//               emailController: _emailController,
//               mobileController: _mobileController,
//               placeOfBirth: _birthController.text,
//               //nomineeIdController: _nomineeIdController,
//               nomineeadharController:_nomineeadharController,
//               nomineepanController:_nomineepanController,

//               nomineeMobileController: _nomineeMobileController,
//               nomineeRelation: selectedRelation,
//               nomineeRelationController: _nomineeRelationController,
//               aadharFile: aadharFile,
//               panFile: panFile,
//               bankProofFile: bankProofFile,
//               salarySlipFile: salarySlipFile,
//               itrFile: itrFile,
//               selectedCity: _selectedCity != null
//                   ? "${_selectedCity!.city}, ${_selectedCity!.state}"
//                   : null,
//               isDeclared: isDeclared,
//               onDeclareChanged: (val) =>
//                   setState(() => isDeclared = val ?? false),
//               onViewFile: _viewFile,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
