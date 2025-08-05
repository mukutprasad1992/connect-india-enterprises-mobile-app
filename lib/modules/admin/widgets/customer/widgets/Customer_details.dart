import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';

class Customer_Details extends StatelessWidget {
  final Map<String, String> row;

  const Customer_Details({super.key, required this.row});

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'id':
        return Icons.badge;
      case 'name':
        return Icons.person;
      case 'address':
        return Icons.location_on;
      case 'phone':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'pincode':
        return Icons.pin_drop;
      case 'business name':
      case 'businessrepresentative':
        return Icons.business;
      case 'status':
        return Icons.toggle_on_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String capitalizeWords(String text) {
    return text
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

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
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Customer Details ', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Only take height of content
              children: sortedEntries.map((entry) {
                final icon = _getIconForKey(entry.key);
                final label = capitalizeWords(entry.key);
                final value = entry.value.isNotEmpty ? entry.value : 'N/A';
                final isStatus = entry.key.toLowerCase() == 'status';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                        child: Icon(icon, color: Colors.indigo, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: value));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$label copied'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isStatus
                                      ? getStatusColor(value)
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
