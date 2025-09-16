import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '/consts/appColors.dart';

class ViewInvestment extends StatelessWidget {
  final Map<String, dynamic> investment;

  const ViewInvestment({super.key, required this.investment});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "inprogress":
        return Colors.orange;
      case "pending":
        return Colors.blue;
      case "rejected":
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  void _openFile(String? url) {
    if (url == null || url.isEmpty) return;
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _buildField(BuildContext context, String label, String value,
      {IconData? icon, bool isStatus = false, String? fileUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.indigo.withOpacity(0.1),
            child: Icon(icon ?? Icons.info_outline, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (fileUrl != null) {
                  _openFile(fileUrl);
                } else {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$label copied"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87)),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: isStatus
                          ? getStatusColor(value)
                          : (fileUrl != null ? Colors.blue : Colors.black87),
                      decoration: fileUrl != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (fileUrl != null)
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => _openFile(fileUrl),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: fields),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("Active Step: ${investment['activeSteps']}");
    //print("Submit: ${investment['submit']}");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title: const Text("Investment Details",
            style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSection("ID & Status", [
                  _buildField(context, "ID", investment['id'] ?? "N/A",
                      icon: Icons.numbers),
                  _buildField(
                      context, "Status", investment['status'] ?? "Pending",
                      icon: Icons.verified, isStatus: true),
                  _buildField(
                    context,
                    "Active Step",
                    investment['activeSteps']?.toString().capitalize() ??
                        "N/A",
                    icon: Icons.flag,
                  ),
                  _buildField(
                    context,
                    "Submit Status",
                    (investment['submit']?.toString().toLowerCase() ==
                            "complete")
                        ? "Complete"
                        : "Incomplete",
                    icon: Icons.check_circle,
                    isStatus: true,
                  ),
                ]),
                _buildSection("Basic Details", [
                  _buildField(context, "Aadhar Number",
                      investment['aadharNumber'] ?? "N/A",
                      icon: Icons.credit_card),
                  _buildField(
                      context, "Pan Number", investment['panNumber'] ?? "N/A",
                      icon: Icons.credit_card_outlined),
                ]),
                _buildSection("Personal Details", [
                  _buildField(context, "Email", investment['email'] ?? "N/A",
                      icon: Icons.email),
                  _buildField(context, "Mobile", investment['mobile'] ?? "N/A",
                      icon: Icons.phone_android),
                  _buildField(
                    context,
                    "Place Of Birth",
                    (investment['placeOfBirth'] is Map &&
                            investment['placeOfBirth'] != null)
                        ? "${investment['placeOfBirth']['city']}, ${investment['placeOfBirth']['state']}"
                        : (investment['placeOfBirth']?.toString() ?? "N/A"),
                    icon: Icons.place,
                  ),
                  _buildField(
                      context, "Occupation", investment['occupation'] ?? "N/A",
                      icon: Icons.work_outline),
                  _buildField(context, "Income",
                      investment['income']?.toString() ?? "N/A",
                      icon: Icons.attach_money),
                ]),
                _buildSection("Nominee Details", [
                  _buildField(
                      context, "Nominee ID", investment['nomineeId'] ?? "N/A",
                      icon: Icons.badge),
                  _buildField(context, "Nominee Mobile",
                      investment['nomineeMobile'] ?? "N/A",
                      icon: Icons.phone),
                  _buildField(context, "Nominee Relation",
                      investment['nomineeRelation'] ?? "N/A",
                      icon: Icons.group),
                ]),
                _buildSection("Documents", [
                  _buildField(context, "Aadhaar Card File", investment['aadhaarCardFileKey'] != null ?"View Aadhaar Card":"N/A",
                      fileUrl: investment['aadhaarCardFileKey'],
                      icon: Icons.picture_as_pdf),
                  _buildField(context, "PAN Card File", investment['panCardFileKey'] != null ?"View PAN Card":"N/A",
                      fileUrl: investment['panCardFileKey'],
                      icon: Icons.picture_as_pdf),
                  _buildField(context, "Bank Proof", investment['bankProofFileKey'] != null ?"View Bank Proof":"N/A",
                      fileUrl: investment['bankProofFileKey'],
                      icon: Icons.account_balance),
                  _buildField(
                      context,
                      "Salary Slip",
                      investment['salarySlipsFileKey'] != null
                          ? "View Salary Slip"
                          : "N/A",
                      fileUrl: investment['salarySlipsFileKey'],
                      icon: Icons.receipt_long),
                  _buildField(
                      context,
                      "ITR Document",
                      investment['itrDocumentsFileKey'] != null
                          ? "View ITR Document"
                          : "N/A",
                      fileUrl: investment['itrDocumentsFileKey'],
                      icon: Icons.description),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
