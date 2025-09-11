import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/services/serviceType/uploadDocumentApi.dart';
import '/services/serviceType/updateServiceType.dart';
//import '/routes/myapp_routes.dart';
//import '/consts/appConstants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UploadDocumentSection extends StatefulWidget {
  final String? occupation;
  final Map<String, String?>? existingFiles;
  final String? DBId;
  final String token;
  final String mode;
  final void Function(Map<String, String?> uploadedFiles)? onUploaded;

  // 🔹 Callback when done
  final Function(String dbId) onCompleted;

  const UploadDocumentSection({
    Key? key,
    required this.occupation,
    required this.existingFiles,
    required this.DBId,
    required this.token,
    required this.mode,
    required this.onCompleted,
    required this.onUploaded,
  }) : super(key: key);

  @override
  State<UploadDocumentSection> createState() => _UploadDocumentSectionState();
}

class _UploadDocumentSectionState extends State<UploadDocumentSection> {
  String? aadharFile, panFile, bankProofFile, salarySlipFile, itrFile;
  bool _isLoading = false;

  static const String baseUrl =
      "https://connect-india-upload-documents.s3.ap-south-1.amazonaws.com";

  @override
  void initState() {
    super.initState();
    if (widget.existingFiles != null) {
      aadharFile = widget.existingFiles!["aadhar"];
      panFile = widget.existingFiles!["pan"];
      bankProofFile = widget.existingFiles!["bank"];
      salarySlipFile = widget.existingFiles!["salary"];
      itrFile = widget.existingFiles!["itr"];
    }
  }

  /// 🔹 Upload single file
  Future<void> _uploadFile(String type) async {
    String token = widget.token;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    String filePath = result.files.single.path!;
    String fileName = result.files.single.name;
    String mediaType =
        fileName.toLowerCase().endsWith(".pdf") ? "document" : "image";

    // show name which file we have uploaded

    final Map<String, String> typeLabels = {
      "aadhar": "Aadhar Card",
      "pan": "PAN Card",
      "bank": "Bank Proof",
      "salary": "Salary Slip",
      "itr": "ITR Document",
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final jsonData = await ApiService.uploadDocument(
        filePath: filePath,
        fileType: mediaType,
        description: 'User document',
        folderName: type,
        token: token,
      );

      final String key = jsonData['result']['key'];
      final String uploadedUrl = '$baseUrl/$key';

      setState(() {
        switch (type) {
          case "aadhar":
            aadharFile = uploadedUrl;
            break;
          case "pan":
            panFile = uploadedUrl;
            break;
          case "bank":
            bankProofFile = uploadedUrl;
            break;
          case "salary":
            salarySlipFile = uploadedUrl;
            break;
          case "itr":
            itrFile = uploadedUrl;
            break;
        }
      });
      widget.onUploaded?.call({
        "aadhar": aadharFile,
        "pan": panFile,
        "bank": bankProofFile,
        "salary": salarySlipFile,
        "itr": itrFile,
      });

      String label = typeLabels[type] ?? "Document";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          //content: Text("$fileName uploaded successfully!"), //actual file name
          content: Text("$label uploaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Upload failed: $e"),
            backgroundColor: Colors.orangeAccent),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  /// 🔹 Final submit (after uploads)
  Future<String?> submitDetails() async {
    if (widget.DBId == null) return null;

    setState(() => _isLoading = true);

    try {
      final res = await ServiceTypeApi.updateServiceTypeById(
        id: widget.DBId!,
        token: widget.token,
        serviceId: "1",
        serviceSubType: "mutualFund",
        status: "Pending",
        activeSteps: "uploadDocuments",
        email: "",
        mobile: "",
        income: "",
        occupation: widget.occupation ?? "",
        placeOfBirth: {},
      );

      print("UpdateServiceType Response (documents): $res");

      if (res['status'] == true) {
        final data = res['data'];
        final dbId = data?['_id']?.toString() ?? data?['id']?.toString();
        if (dbId == null || dbId.isEmpty) throw Exception("No DBId returned");

        widget.onCompleted(dbId);
        return dbId;
      } else {
        throw Exception(res['message'] ?? "Upload failed");
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

  /// 🔹 View file
  ///
  void _viewFile(String fileUrl) {
    final lowerUrl = fileUrl.toLowerCase();
    final fileName = fileUrl.split('/').last;

    if (lowerUrl.endsWith(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(fileName)),
            body: SfPdfViewer.network(fileUrl),
          ),
        ),
      );
    } else if (lowerUrl.endsWith(".jpg") ||
        lowerUrl.endsWith(".jpeg") ||
        lowerUrl.endsWith(".png")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(fileName)),
            body: Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: fileUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication);
    }
  }

  // remove file fuction code

  Future<void> _deleteFile(String? fileUrl) async {
    if (fileUrl == null) return;

    final Map<String, String> typeLabel = {
      "aadhar": "Aadhar Card",
      "pan": "PAN Card",
      "bank": "Bank Proof",
      "salary": "Salary Slip",
      "itr": "ITR Document",
    };

    String label = typeLabel[fileUrl] ?? "Document";

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Remove"),
        content: Text("Are you sure you want to remove $label?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("remove"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      if (aadharFile == fileUrl) {
        aadharFile = null;
      } else if (panFile == fileUrl) {
        panFile = null;
      } else if (bankProofFile == fileUrl) {
        bankProofFile = null;
      } else if (salarySlipFile == fileUrl) {
        salarySlipFile = null;
      } else if (itrFile == fileUrl) {
        itrFile = null;
      }
    });

    // 🔹 Update parent about remove changes

    widget.onUploaded?.call({
      "aadhar": aadharFile,
      "pan": panFile,
      "bank": bankProofFile,
      "salary": salarySlipFile,
      "itr": itrFile,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label removed successfully!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _documentCard({
    required String title,
    required String type,
    required String? fileUrl,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  Status Icon
            Icon(
              fileUrl != null ? Icons.check_circle : Icons.upload_file,
              color: fileUrl != null ? Colors.green : Colors.grey,
              size: 30,
            ),
            const SizedBox(width: 12),

            //  Title + Status Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileUrl != null ? "Uploaded" : "No file uploaded",
                    style: TextStyle(
                      color:
                          fileUrl != null ? Colors.green.shade700 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            //  Actions
            if (fileUrl == null) ...[
              ElevatedButton(
                onPressed: () async => await _uploadFile(type),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              IconButton(
                onPressed: () => _viewFile(fileUrl),
                icon: const Icon(Icons.visibility, color: Colors.blue),
                tooltip: "View File",
              ),
              IconButton(
                onPressed: () => _deleteFile(fileUrl),
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: "Delete File",
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _documentCard(
            title: "Aadhar Card", type: "aadhar", fileUrl: aadharFile),
        _documentCard(title: "PAN Card", type: "pan", fileUrl: panFile),
        _documentCard(
            title: "Bank Proof", type: "bank", fileUrl: bankProofFile),
        if (widget.occupation?.toUpperCase() == "JOB")
          _documentCard(
              title: "Salary Slip", type: "salary", fileUrl: salarySlipFile),
        if (widget.occupation?.toUpperCase() == "BUSINESS")
          _documentCard(title: "ITR Document", type: "itr", fileUrl: itrFile),
      ],
    );
  }
}
