import 'package:flutter/material.dart';
import 'Vendor_Icon_buttons.dart';

class VendorSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final String token;
  final void Function(int, Map<String, dynamic>) onUpdate;
  final void Function(int, Map<String, dynamic>) onBlockToggle;
  final Function(bool isLoading)? setLoading;
  final VoidCallback? onReloadParent;
  

  const VendorSummaryCard({
    super.key,
    required this.setLoading,
    required this.token,
    required this.row,
    required this.index,
    required this.onUpdate,
    required this.onBlockToggle,
    this.onReloadParent,
  });

  /// Get color based on status
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'disable':
        return Colors.redAccent;
      case 'enable':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get icon based on status
  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'disable':
        return Icons.block;
      case 'enable':
        return Icons.lock_open;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(row['status']);
    final statusIcon = _getStatusIcon(row['status']);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Business Name + Action Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    row['businessName'] ?? 'No Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          fontSize: 14
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                VendorActionButtons(
                  row: row,
                  vendor: row,
                  id: row['id'] ?? 0,
                  status: row['status'] ?? 'enable',
                  token: token,
                  index: index,
                  onUpdate: onUpdate,
                  onBlockToggle: onBlockToggle,
                  setLoading: setLoading, 
                  onReloadParent: onReloadParent,
                ),
              ],
            ),
            const SizedBox(height: 4), 

            // Representative
            _buildInfoRow(context, 'Representative', row['businessRepresentative'] ?? '', Colors.teal),
            const SizedBox(height: 4), 
            // Vendor Code
            _buildInfoRow(context, 'Vendor Code', row['vendorCode'] ?? '', Colors.blue),
            const SizedBox(height: 4), 
            // Status Row
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: row['status'] ?? '',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Info row with black label and colored value
  Widget _buildInfoRow(BuildContext context, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
