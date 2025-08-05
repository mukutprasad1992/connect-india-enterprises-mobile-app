import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';

class InqueryDetails extends StatelessWidget {
  final Map<String, String> row;

  const InqueryDetails({super.key, required this.row});

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'id':
        return Icons.badge_outlined;
      case 'first name':
      case 'last name':
        return Icons.person_outline;
      case 'email':
        return Icons.email_outlined;
      case 'mobile no':
        return Icons.phone_android;
      case 'type':
        return Icons.category_outlined;
      case 'amount':
        return Icons.attach_money_outlined;
      case 'duration':
        return Icons.timer_outlined;
      case 'from time':
        return Icons.access_time_outlined;
      case 'to time':
        return Icons.access_time;
      case 'status':
        return Icons.toggle_on_outlined;
      case 'comment':
        return Icons.comment_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

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

  @override
  Widget build(BuildContext context) {
    final sortedEntries = row.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title:Text('Inquiry Details', style: TextStyle(color: Colors.white)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sortedEntries.map((entry) {
                final icon = _getIconForKey(entry.key);
                final isStatusField = entry.key.toLowerCase() == 'status';

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
                                Clipboard.setData(ClipboardData(text: entry.value));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${capitalize(entry.key)} copied'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                entry.value.isEmpty ? 'N/A' : entry.value,
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
    );
  }
}

