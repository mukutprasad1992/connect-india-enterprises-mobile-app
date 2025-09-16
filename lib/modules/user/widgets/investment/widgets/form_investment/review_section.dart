// // review_section.dart
// import 'package:flutter/material.dart';
// import '/services/serviceType/updateServiceType.dart' as updateApi;

// class ReviewSection extends StatefulWidget {
//   final String? investmentType;
//   final String? occupation;
//   final String mode;
//   final String token;
//   final String? dbId;
//   final Function(String dbId) onCompleted;
//   final String? isSubmitted;
//   final String serviceId;
//   //final String serviceSubType;
//   final String activeSteps;

//   final TextEditingController annualIncomeController;
//   final TextEditingController netGrossProfitController;
//   final TextEditingController aadharController;
//   final TextEditingController panController;
//   final TextEditingController emailController;
//   final TextEditingController mobileController;
//   final Map<String, String>? placeOfBirth;
//   final TextEditingController nomineeIdController;
//   final TextEditingController nomineeMobileController;
//   final String? nomineeRelation;
//   final TextEditingController nomineeRelationController;
//   final String? aadharFile;
//   final String? panFile;
//   final String? bankProofFile;
//   final String? salarySlipFile;
//   final String? itrFile;
//   final String? selectedCity;
//   final bool isDeclared;
//   final ValueChanged<bool?> onDeclareChanged;
//   final void Function(String fileUrl) onViewFile;
//   final String? nomineeIdType;
//   final Future<String?> Function()? saveSectionCallback;

//   ReviewSection({
//     super.key,
//     required this.saveSectionCallback,
//     required this.serviceId,
//     required this.activeSteps,
//     //required this.serviceSubType,
//     required this.dbId,
//     required this.isSubmitted,
//     required this.mode,
//     required this.token,
//     required this.onCompleted,
//     required this.nomineeIdType,
//     required this.isDeclared,
//     required this.onDeclareChanged,
//     required this.investmentType,
//     required this.occupation,
//     required this.annualIncomeController,
//     required this.netGrossProfitController,
//     required this.aadharController,
//     required this.panController,
//     required this.emailController,
//     required this.mobileController,
//     required this.placeOfBirth,
//     required this.nomineeIdController,
//     required this.nomineeMobileController,
//     required this.nomineeRelation,
//     required this.nomineeRelationController,
//     required this.aadharFile,
//     required this.panFile,
//     required this.bankProofFile,
//     required this.salarySlipFile,
//     required this.itrFile,
//     required this.onViewFile,
//     required this.selectedCity,
//   });

//   @override
//   State<ReviewSection> createState() => ReviewSectionState();
// }

// /// *** Public state class name (no leading underscore) ***
// ///
// class ReviewSectionState extends State<ReviewSection> {
//   bool _isLoading = false;

//   Widget _buildSection({
//     required String title,
//     required List<Widget> children,
//     IconData? icon,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 if (icon != null) Icon(icon, size: 22, color: Colors.blueGrey),
//                 if (icon != null) const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blueGrey,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   /// This is the method you call from the parent via GlobalKey

//   Future<String?> submitDetails() async {
//     if (widget.dbId == null) {
//       if (widget.saveSectionCallback != null) {
//         final id = await widget.saveSectionCallback!();
//         if (id == null || id.isEmpty) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content:
//                       Text("⚠️ Could not create record before final submit.")),
//             );
//           }
//           return null;
//         }
//       }
//     }

//     if (!widget.isDeclared) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("⚠️ Please accept the declaration.")),
//         );
//       }
//       return null;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final res = await updateApi.ServiceTypeApi.updateServiceTypeById(
//         id: widget.dbId!,
//         token: widget.token,
//         serviceId: "1",
//         serviceSubType: widget.investmentType ?? "Mutual Funds",
//         status: "Pending",
//         activeSteps: "review",
//         isSubmitted: 1,
//       );

//       if (res['status'] == true) {
//         final dbId =
//             res['data']?['_id']?.toString() ?? res['data']?['id']?.toString();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(widget.mode == "add"
//                   ? "Investment added successfully!"
//                   : "Investment updated successfully!"),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//         widget.onCompleted(dbId!);
//         return dbId;
//       } else {
//         throw Exception(res['message'] ?? "Unknown error from server");
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Final Submit Failed: ${e.toString()}")),
//         );
//       }
//       return null;
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Widget _buildInfoRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 4,
//             child: Text(
//               "$label:",
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: Text(
//               (value != null && value.isNotEmpty) ? value : "Not Provided",
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentRow(String name, String? fileUrl) {
//     bool isUploaded = fileUrl != null && fileUrl.isNotEmpty;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(
//             isUploaded ? Icons.check_circle : Icons.upload_file,
//             color: isUploaded ? Colors.green : Colors.grey,
//             size: 20,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               name,
//               style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//             ),
//           ),
//           Text(
//             isUploaded ? "Uploaded" : "Not Uploaded",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: isUploaded ? Colors.green : Colors.red,
//             ),
//           ),
//           if (isUploaded) const SizedBox(width: 12),
//           TextButton(
//             onPressed: () => widget.onViewFile(fileUrl!),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               backgroundColor: Colors.blue.shade50,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               "View",
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSection(
//             title: "Investment Details",
//             icon: Icons.account_balance_wallet_rounded,
//             children: [
//               _buildInfoRow("Investment Type", widget.investmentType),
//               _buildInfoRow("Occupation", widget.occupation),
//               if (widget.occupation == "JOB")
//                 _buildInfoRow(
//                     "Annual Income", widget.annualIncomeController.text),
//               if (widget.occupation == "BUSINESS")
//                 _buildInfoRow(
//                     "Net Gross Profit", widget.netGrossProfitController.text),
//             ],
//           ),
//           _buildSection(
//             title: "Personal Details",
//             icon: Icons.person_rounded,
//             children: [
//               _buildInfoRow("Aadhar", widget.aadharController.text),
//               _buildInfoRow("PAN", widget.panController.text),
//               _buildInfoRow("Email", widget.emailController.text),
//               _buildInfoRow("Mobile", widget.mobileController.text),
//               _buildInfoRow(
//                 "Place of Birth",
//                 widget.placeOfBirth != null
//                     ? "${widget.placeOfBirth!['city'] ?? ''}, ${widget.placeOfBirth!['state'] ?? ''}"
//                     : (widget.selectedCity ?? "Not Provided"),
//               ),
//             ],
//           ),
//           _buildSection(
//             title: "Nominee Details",
//             icon: Icons.people_rounded,
//             children: [
//               _buildInfoRow("Nominee ID", widget.nomineeIdController.text),
//               _buildInfoRow(
//                   "Nominee Mobile", widget.nomineeMobileController.text),
//               _buildInfoRow(
//                 "Nominee Relation",
//                 widget.nomineeRelation?.isNotEmpty == true
//                     ? widget.nomineeRelation
//                     : widget.nomineeRelationController.text,
//               ),
//             ],
//           ),
//           _buildSection(
//             title: "Documents",
//             icon: Icons.folder_rounded,
//             children: [
//               _buildDocumentRow("Aadhar", widget.aadharFile),
//               _buildDocumentRow("PAN", widget.panFile),
//               _buildDocumentRow("Bank Proof", widget.bankProofFile),
//               if (widget.occupation == "JOB")
//                 _buildDocumentRow("Salary Slip", widget.salarySlipFile),
//               if (widget.occupation == "BUSINESS")
//                 _buildDocumentRow("ITR Document", widget.itrFile),
//             ],
//           ),

//           //  Declaration at bottom
//           const SizedBox(height: 16),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Checkbox(
//                 value: widget.isDeclared,
//                 onChanged: widget.onDeclareChanged,
//               ),
//               const Expanded(
//                 child: Text(
//                   "I hereby declare that the information provided above is correct.",
//                   style: TextStyle(fontSize: 13),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
