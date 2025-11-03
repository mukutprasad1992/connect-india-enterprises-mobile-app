import 'package:flutter/material.dart';
import 'inquiryIconbuttons.dart';
import '/models/inquiryModel.dart';

class InquirySummaryCard extends StatelessWidget {
  final InquiryModel row;
  final VoidCallback onStatusChanged;
  final String token;
  final Function(bool isLoading)? setLoading;


  const InquirySummaryCard({
    super.key,
    required this.setLoading,
    required this.token,
    required this.row,
    required this.onStatusChanged,
  });

  /// Status icon mapping
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.hourglass_empty;
      case "in progress":
        return Icons.autorenew;
      case "approved":
        return Icons.check_circle;
      case "rejected":
        return Icons.cancel;
      case "blocked":
        return Icons.block;
      case "active":
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  /// Status color mapping
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.blue;
      case "in progress":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "blocked":
        return Colors.redAccent;
      case "active":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _getStatusColor(row.status ?? '');
    final statusIcon = _getStatusIcon(row.status ?? '');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
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
            /// Top Row: Inquiry ID + Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Inquiry ID: ${row.id ?? 'N/A'}",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InquiryActionButtons(
                  token: token,
                  row: row,
                  onStatusChanged: onStatusChanged,
                  setLoading: setLoading, 
                ),
              ],
            ),
            const SizedBox(height: 6),

            _buildLabelValueText("Aadhaar Number", row.aadharNumber ?? '', Colors.teal),
            const SizedBox(height: 4),
            _buildLabelValueText("PAN Number", row.panNumber ?? '', Colors.blue),
            const SizedBox(height: 4),
            _buildLabelValueText("Service Id", row.serviceId ?? '', Colors.blue),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 14, color: statusColor),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: row.status ?? 'N/A',
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

  /// Label-value builder
  Widget _buildLabelValueText(String label, String value, Color valueColor) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: value.isEmpty ? 'N/A' : value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
