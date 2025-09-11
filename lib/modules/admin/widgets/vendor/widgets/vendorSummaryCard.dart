import 'package:flutter/material.dart';
import 'vendorIconbuttons.dart';

class VendorSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final void Function(int, Map<String, dynamic>) onUpdate;
  final void Function(int, Map<String, dynamic>) onBlockToggle;
  final void Function(int) onDelete;

  const VendorSummaryCard({
    super.key,
    required this.row,
    required this.index,
    required this.onUpdate,
    required this.onBlockToggle,
    required this.onDelete,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'blocked':
        return Colors.redAccent;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(row['Status']);

    return InkWell(
      onTap: () {
        // Optional: handle tap if needed
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Business Name and Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    row['businessName'] ?? 'No Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                VendorActionButtons(
                  row: row,
                  index: index,
                  onUpdate: onUpdate,
                  onBlockToggle: onBlockToggle,
                  onDelete: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildLabelValueText(context, 'Representative', row['businessRepresentative'] ?? '', Colors.teal),
            _buildLabelValueText(context, 'Vendor Code', row['vendorCode'] ?? '', Colors.blue),
            _buildLabelValueText(context, 'Vendor Status', row['status'] ?? '', statusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValueText(BuildContext context, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
            ),
          ],
        ),
        overflow: TextOverflow.fade,
        maxLines: 1,
      ),
    );
  }
}
