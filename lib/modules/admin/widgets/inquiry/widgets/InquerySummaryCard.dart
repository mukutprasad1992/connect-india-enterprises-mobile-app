import 'package:flutter/material.dart';
import 'inquiryIconbuttons.dart';

class InquirySummaryCard extends StatelessWidget {
  final Map<String, String> row;
  final VoidCallback onStatusChanged;

  const InquirySummaryCard({
    super.key,
    required this.row,
    required this.onStatusChanged,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return const Color.fromARGB(255, 173, 156, 3);
      case 'blocked':
        return Colors.red;
      case 'active':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(row['Status']);
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // Handle card tap here if needed
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Name and action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${row['First Name'] ?? ''} ${row['Last Name'] ?? ''}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                InquiryActionButtons(
                  row: row,
                  onStatusChanged: onStatusChanged,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Email
            _buildLabelValueText(
              context,
              'Email',
              row['Email'] ?? '',
              Colors.teal,
            ),

            const SizedBox(height: 6),

            // Mobile Number
            _buildLabelValueText(
              context,
              'Mobile No',
              row['Mobile No'] ?? '',
              Colors.blue,
            ),

            const SizedBox(height: 6),

            // Status with color
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Inquiry Status: ',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: row['Status'] ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValueText(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: textTheme.bodyMedium?.copyWith(color: valueColor),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.fade,
    );
  }
}
