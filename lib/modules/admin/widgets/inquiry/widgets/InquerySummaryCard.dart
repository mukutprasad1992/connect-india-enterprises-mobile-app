import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'inquiryIconbuttons.dart';
import '/models/inquiryModel.dart';

class InquirySummaryCard extends StatelessWidget {
  final InquiryModel row;
  final VoidCallback onStatusChanged;
  final String token;

  const InquirySummaryCard({
    super.key,
    required this.token,
    required this.row,
    required this.onStatusChanged,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase() ?? '') {
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
    final statusColor = _getStatusColor(row.status);
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
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
            // Top Row: ID and action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Inquiry ID: ${row.id ?? 'N/A'}",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  
                ),
                InquiryActionButtons(
                  token: token,
                  row: row,
                  onStatusChanged: onStatusChanged,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Aadhaar Number
            _buildLabelValueText(
              context,
              'Aadhaar Number',
              row.aadharNumber ?? '',
              Colors.teal,FontWeight.bold
            ),

            const SizedBox(height: 6),

            // PAN Number
            _buildLabelValueText(
              context,
              'PAN Number',
              row.panNumber ?? '',
              Colors.blue,FontWeight.bold
            ),
            const SizedBox(height: 6),

            _buildLabelValueText(
              context,
              'Service Id',
              row.serviceId ?? '',
              Colors.blue,FontWeight.bold
            ),
            const SizedBox(height: 6),

            // Status
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Inquiry Status: ',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: row.status ?? 'N/A',
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
    FontWeight Fontweigh,
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
            text: value.isEmpty ? 'N/A' : value,
            style: textTheme.bodyMedium?.copyWith(color: valueColor),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.fade,
    );
  }
}
