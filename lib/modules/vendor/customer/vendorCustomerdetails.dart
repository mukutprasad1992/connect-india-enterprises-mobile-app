import 'package:flutter/material.dart';
import '/consts/appColors.dart';

class VendorDetailPage extends StatelessWidget {
  final Map<String, String> row;

  const VendorDetailPage({super.key, required this.row});

  Icon _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'business name':
        return const Icon(Icons.business, color: Colors.indigo);
      case 'business representative':
        return const Icon(Icons.person_outline, color: Colors.indigo);
      case 'email':
        return const Icon(Icons.email_outlined, color: Colors.indigo);
      case 'phone':
        return const Icon(Icons.phone_android, color: Colors.indigo);
      case 'vendor code':
        return const Icon(Icons.code, color: Colors.indigo);
      case 'address':
        return const Icon(Icons.location_on_outlined, color: Colors.indigo);
      case 'created at':
        return const Icon(Icons.calendar_today_outlined, color: Colors.indigo);
      case 'status':
        return const Icon(Icons.toggle_on_outlined, color: Colors.indigo);
      default:
        return const Icon(Icons.info_outline, color: Colors.indigo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 700.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > maxWidth;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        title: Text(
          row['Business name'] ?? 'Vendor Details',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: isWide ? maxWidth : double.infinity,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: row.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getIconForKey(entry.key),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
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
      ),
    );
  }
}
