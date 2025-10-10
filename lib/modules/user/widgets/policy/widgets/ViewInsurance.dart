import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdfx/pdfx.dart';

import '/consts/appColors.dart';
import 'package:http/http.dart' as http;

class ViewInsurance extends StatelessWidget {
  final Map<String, dynamic> insurance;

  const ViewInsurance({super.key, required this.insurance});

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

  /// 📌 Field UI Builder
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
                if (fileUrl != null && fileUrl.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DocumentViewerPage(fileUrl: fileUrl, title: label),
                    ),
                  );
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
          if (isValidFile(fileUrl))
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DocumentViewerPage(fileUrl: fileUrl!, title: label),
                  ),
                );
              },
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

  // String? _checkFile(dynamic value, String label) {
  //   if (value != null && value.toString().isNotEmpty) {
  //     return "View $label";
  //   }
  //   return null;
  // }

  // String? _getValidFileUrl(dynamic value) {
  //   if (value == null) return null;
  //   final str = value.toString().trim();
  //   if (str.isEmpty || str == "N/A") return null;
  //   return str;
  // }

  bool isValidFile(dynamic value) {
    if (value == null) return false;
    final str = value.toString().trim().toLowerCase();
    if (str.isEmpty || str == "n/a" || str == "null") return false;
    return true;
  }

  String _safeValue(dynamic value) {
    if (value == null) return "N/A";
    final str = value.toString().trim();
    return str.isEmpty ? "N/A" : str;
  }

  String _formatPlaceOfBirth(dynamic place) {
    if (place is Map) {
      final city = place['city']?.toString().trim();
      final state = place['state']?.toString().trim();
      if (city != null &&
          city.isNotEmpty &&
          state != null &&
          state.isNotEmpty) {
        return "$city, $state";
      }
    }
    return "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title: const Text("Insurance Details",
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
                  _buildField(context, "ID", insurance['id'] ?? "N/A",
                      icon: Icons.numbers),
                  _buildField(
                      context, "Status", insurance['status'] ?? "Pending",
                      icon: Icons.verified, isStatus: true),
                  _buildField(
                    context,
                    "Active Step",
                    insurance['activeSteps']?.toString().capitalize() ?? "N/A",
                    icon: Icons.flag,
                  ),
                  _buildField(
                    context,
                    "Submit Status",
                    (insurance['activeSteps']?.toString().toLowerCase() ==
                            "review")
                        ? "Complete"
                        : "Incomplete",
                    icon: Icons.check_circle,
                    isStatus: true,
                  ),
                ]),

                // Basic details

                _buildSection("Basic Details", [
                  _buildField(context, "Aadhar Number",
                      insurance['aadharNumber'] ?? "N/A",
                      icon: Icons.credit_card),
                  _buildField(
                      context, "Pan Number", insurance['panNumber'] ?? "N/A",
                      icon: Icons.credit_card_outlined),
                ]),

                // Personal details

                _buildSection("Personal Details", [
                  _buildField(
                    context,
                    "Place Of Birth",
                    _formatPlaceOfBirth(insurance['placeOfBirth']),
                    icon: Icons.place,
                  ),
                  _buildField(
                    context,
                    "MotherName",
                    _safeValue(insurance['motherName']),
                    icon: Icons.email,
                  ),
                  _buildField(
                    context,
                    "Weight",
                    _safeValue(insurance['weightKG']),
                    icon: Icons.phone_android,
                  ),
                  _buildField(
                    context,
                    "Height",
                    _safeValue(insurance['heightCM']),
                    icon: Icons.phone_android,
                  ),
                  _buildField(
                    context,
                    "Smoker",
                    _safeValue(insurance['smoker']),
                    icon: Icons.phone_android,
                  ),
                  _buildField(
                    context,
                    "Alcohol",
                    _safeValue(insurance['alcohol']),
                    icon: Icons.phone_android,
                  ),
                  
                  _buildField(
                    context,
                    "Occupation",
                    _safeValue(insurance['occupation']),
                    icon: Icons.work_outline,
                  ),
                  _buildField(
                    context,
                    "Income",
                    _safeValue(insurance['income']),
                    icon: Icons.attach_money,
                  ),
                ]),

                // Nominee details

                _buildSection("Nominee Details", [
                  _buildField(
                      context, "Nominee Name", insurance['nomineeName'] ?? "N/A",
                      icon: Icons.badge),
                  _buildField(context, "Nominee DOB",
                      insurance['nomineeDOB'] ?? "N/A",
                      icon: Icons.phone),
                  _buildField(context, "Nominee Relation",
                      insurance['nomineeRelation'] ?? "N/A",
                      icon: Icons.group),
                ]),

                // Documents Section

                _buildSection("Documents", [
                  _buildField(
                    context,
                    "Adhar Card File",
                    isValidFile(insurance['aadharCardFileKey'])
                        ? "View Adhar Card"
                        : "N/A",
                    fileUrl: isValidFile(insurance['aadharCardFileKey'])
                        ? insurance['aadharCardFileKey']
                        : null,
                    icon: Icons.picture_as_pdf,
                  ),
                  _buildField(
                    context,
                    "PAN Card File",
                    isValidFile(insurance['panCardFileKey'])
                        ? "View Adhar Card"
                        : "N/A",
                    fileUrl: isValidFile(insurance['panCardFileKey'])
                        ? insurance['panCardFileKey']
                        : null,
                    icon: Icons.picture_as_pdf,
                  ),
                  _buildField(
                    context,
                    "Bank Proof",
                    isValidFile(insurance['bankProofFileKey'])
                        ? "View Bank proof"
                        : "N/A",
                    fileUrl: isValidFile(insurance['bankProofFileKey'])
                        ? insurance['bankProofFileKey']
                        : null,
                    icon: Icons.account_balance,
                  ),
                  _buildField(
                    context,
                    "Salary Slip",
                    isValidFile(insurance['salarySlipsFileKey'])
                        ? "View Salary Slip"
                        : "N/A",
                    fileUrl: isValidFile(insurance['salarySlipsFileKey'])
                        ? insurance['salarySlipsFileKey']
                        : null,
                    icon: Icons.receipt_long,
                  ),
                  _buildField(
                    context,
                    "ITR Document",
                    isValidFile(insurance['itrDocumentsFileKey'])
                        ? "View ITR document"
                        : "N/A",
                    fileUrl: isValidFile(insurance['itrDocumentsFileKey'])
                        ? insurance['itrDocumentsFileKey']
                        : null,
                    icon: Icons.description,
                  ),
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

/// 📌 Document Viewer Page

class DocumentViewerPage extends StatefulWidget {
  final String fileUrl;
  final String title;

  const DocumentViewerPage(
      {super.key, required this.fileUrl, required this.title});

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  PdfControllerPinch? pdfController;
  bool isPdf = false;
  bool isImage = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final lowerUrl = widget.fileUrl.toLowerCase();
    if (lowerUrl.endsWith(".pdf")) {
      isPdf = true;
      _loadPdf(widget.fileUrl);
    } else if (lowerUrl.endsWith(".jpg") ||
        lowerUrl.endsWith(".jpeg") ||
        lowerUrl.endsWith(".png")) {
      isImage = true;
      isLoading = false;
    } else {
      isLoading = false;
    }
  }

  Future<void> _loadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        pdfController = PdfControllerPinch(
          document: PdfDocument.openData(response.bodyBytes),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load PDF");
      }
    } catch (e) {
      //print("❌ Error loading PDF: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.background),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isPdf
              ? PdfViewPinch(controller: pdfController!)
              : isImage
                  ? Center(
                      child: InteractiveViewer(
                        child: Image.network(widget.fileUrl),
                      ),
                    )
                  : const Center(child: Text("Unsupported file format")),
    );
  }
}
