import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';

class VendorDetailPage extends StatelessWidget {
  final Map<String, String> row;

  const VendorDetailPage({super.key, required this.row});

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'business name':
        return Icons.business;
      case 'business representative':
        return Icons.person_outline;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_android;
      case 'vendor code':
        return Icons.code;
      case 'address':
        return Icons.location_on_outlined;
      case 'created at':
      case 'create at':
        return Icons.calendar_today_outlined;
      case 'status':
        return Icons.toggle_on_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
      case 'blocked':
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = row.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title: Text("Vendor Details",style: TextStyle(fontSize: 18, color: Colors.white),
          //row['Business name'] ?? 'Vendor Details',
          //style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: sortedEntries.map((entry) {
                final icon = _getIconForKey(entry.key);
                final isStatusField = entry.key.toLowerCase() == 'status';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                        child: Icon(icon, color: Colors.indigo),
                      ),
                      const SizedBox(width: 16),
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
                              child: Text(
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
    );
  }
}
