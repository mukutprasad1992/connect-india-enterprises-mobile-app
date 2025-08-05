import 'package:flutter/material.dart';
import 'customerIconbuttons.dart';

class CustomerSummaryCard extends StatelessWidget {
  final Map<String, String> row;
  final int index;

  const CustomerSummaryCard({
    super.key,
    required this.row,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {}, // You can add navigation or actions here
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    row['Name'] ?? 'No Name',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                CustomerActionButtons(row: row, index: index),
              ],
            ),
            const SizedBox(height: 10),
            _buildLabelValueText(context, 'Email', row['Email'] ?? '', Colors.green),
            const SizedBox(height: 4),
            _buildLabelValueText(context, 'Phone', row['Phone'] ?? '', Colors.blue),
            const SizedBox(height: 4),
            _buildLabelValueText(context, 'Pin Code', row['Pin Code'] ?? '', Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValueText(BuildContext context, String label, String value, Color color) {
    final textTheme = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: value,
            style: textTheme.bodyMedium?.copyWith(color: color),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.fade,
    );
  }
}
