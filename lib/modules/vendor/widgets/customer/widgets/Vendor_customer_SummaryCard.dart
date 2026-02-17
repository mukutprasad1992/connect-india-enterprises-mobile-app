import 'package:flutter/material.dart';
import 'vendorcustomerIconbuttons.dart';

class VendorCustomerSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final void Function(int, Map<String, dynamic>) onUpdate;

  const VendorCustomerSummaryCard({
    super.key,
    required this.row,
    required this.index,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Expanded(
                  child: Text(
                    row['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                CustomerActionButtons(
                  row: row,
                  index: index,
                  onUpdate: onUpdate,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Info Rows with colors
            _infoRow('Email', row['email'] ?? 'N/A', Colors.teal),
            _infoRow('Phone', row['phone'] ?? 'N/A', Colors.green),
            _infoRow('Pincode', row['pincode'] ?? 'N/A', Colors.orange),
          ],
        ),
      ),
    );
  }

  /// Info row with colored value text
  Widget _infoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
