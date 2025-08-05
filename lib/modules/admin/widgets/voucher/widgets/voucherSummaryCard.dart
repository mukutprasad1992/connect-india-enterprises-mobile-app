import 'package:flutter/material.dart';
import 'voucherIconbuttons.dart';

class VoucherSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final VoidCallback onBlockToggle;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onDelete;

  const VoucherSummaryCard({
    super.key,
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onBlockToggle,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add detail view navigation if needed
      },
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
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    row['customer'] ?? 'No Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                VoucherActionButtons(
                  row: row,
                  index: index,
                  onUpdate: onUpdate,
                  onBlockToggle: onBlockToggle,
                  onDelete: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),

            _buildLabelValueText(
              context,
              "Vendor Name",
              row['vendor'] ?? '',
              Colors.green,
            ),
            const SizedBox(height: 6),
            _buildLabelValueText(
              context,
              "Voucher Code",
              row['code'] ?? '',
              Colors.blue,
            ),
            const SizedBox(height: 6),
            _buildLabelValueText(
              context,
              'Voucher Status',
              row['Redeemed']?.toString() == 'true'
                  ? '🎉 Voucher Redeemed'
                  : '❗ Unclaimed Voucher!',
              row['Redeemed']?.toString() == 'true'
                  ? const Color(0xFF4CAF50)
                  : Colors.orange,
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
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                ),
          ),
        ],
      ),
      overflow: TextOverflow.fade,
    );
  }
}
