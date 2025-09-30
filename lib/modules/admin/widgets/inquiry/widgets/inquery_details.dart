import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';
import 'InquiryModel/inquirymodel.dart';

class InqueryDetails extends StatelessWidget {
  final InquiryModel row;

  const InqueryDetails({super.key, required this.row});

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'id':
        return Icons.badge_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'mobile':
        return Icons.phone_android;
      case 'investment type':
        return Icons.category_outlined;
      case 'amount':
        return Icons.attach_money_outlined;
      case 'aadhar number':
        return Icons.credit_card;
      case 'aadhaar card file':
      case 'pan card file':
      case 'bank proof file':
      case 'salary slips file':
      case 'itr documents file':
        return Icons.insert_drive_file_outlined;
      case 'pan number':
        return Icons.credit_card_outlined;
      case 'place of birth':
        return Icons.location_city_outlined;
      case 'income':
        return Icons.account_balance_wallet_outlined;
      case 'occupation':
        return Icons.work_outline;
      case 'nominee id':
      case 'nominee id type':
      case 'nominee mobile':
        return Icons.contact_phone_outlined;
      case 'nominee relation':
        return Icons.family_restroom;
      case 'status':
        return Icons.toggle_on_outlined;
      case 'submit':
        return Icons.done_all_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return const Color.fromARGB(255, 173, 156, 3);
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  @override
  Widget build(BuildContext context) {
    // Prepare data map for display
    final Map<String, String> displayData = {
      'ID': row.id,
      'Email': row.email,
      'Mobile': row.mobile,
      'Investment Type': row.investmentType,
      'Amount': row.amount,
      'Aadhar Number': row.aadharNumber,
      'Aadhaar Card File': row.aadhaarCardFileKey,
      'PAN Number': row.panNumber,
      'PAN Card File': row.panCardFileKey,
      'Bank Proof File': row.bankProofFileKey,
      'Salary Slips File': row.salarySlipsFileKey ?? 'N/A',
      'ITR Documents File': row.itrDocumentsFileKey ?? 'N/A',
      'Place of Birth': row.placeOfBirth.isNotEmpty
          ? "${row.placeOfBirth['city'] ?? ''}, ${row.placeOfBirth['state'] ?? ''}"
          : 'N/A',
      'Income': row.income,
      'Occupation': row.occupation,
      'Nominee ID': row.nomineeId ?? 'N/A',
      'Nominee ID Type': row.nomineeIdType ?? 'N/A',
      'Nominee Mobile': row.nomineeMobile ?? 'N/A',
      'Nominee Relation': row.nomineeRelation ?? 'N/A',
      'Status': row.status,
      'Submit': row.submit.toString(),
    };

    final sortedEntries = displayData.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title:
            const Text('Inquiry Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sortedEntries.map((entry) {
                  final icon = _getIconForKey(entry.key);
                  final isStatusField = entry.key.toLowerCase() == 'status';
                  final isFileField = entry.key.toLowerCase().contains('file');

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: Colors.indigo, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalize(entry.key),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: entry.value));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${capitalize(entry.key)} copied'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: isFileField && entry.value != 'N/A'
                                    ? Text(
                                        entry.value,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      )
                                    : Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isStatusField
                                              ? getStatusColor(entry.value)
                                              : Colors.black54,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
