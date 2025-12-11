import 'package:flutter/material.dart';
import 'voucherIconbuttons.dart';

class VoucherSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final Function(int index, Map<String, dynamic> updatedVoucher) onUpdate;
  final Function(int index, Map<String, dynamic> updatedVoucher) onStatusToggle;
  final Function(int index) onDelete;
  final VoidCallback? onReloadParent;

  const VoucherSummaryCard({
    super.key,
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onStatusToggle,
    required this.onUpdate,
    this.onReloadParent,
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
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('assets/images/profileimg.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    row['customerName'] ?? 'No Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                VoucherActionButtons(
                  CreateVoucherModel: row,
                  row: row,
                  index: index,
                  id: row['id'] ?? 0,
                  status: row['status'] ?? 'enable',
                  onUpdate: onUpdate,
                  onStatusToggle: onStatusToggle,
                  onDelete: onDelete,
                  onReloadParent: onReloadParent,
                ),
              ],
            ),
            const SizedBox(height: 10),

            _buildLabelValueText(
              context,
              "Business Name",
              row['vendorBusinessName'] ?? '',
              Colors.green,
            ),
            const SizedBox(height: 6),
            _buildLabelValueText(
              context,
              "Voucher Code",
              row['voucherCode'] ?? '',
              Colors.blue,
            ),
            const SizedBox(height: 6),
            _buildLabelValueText(
              context,
              'Voucher Status',
              row['status']?.toString() == 'Disable'
                  ? '🎉Voucher Redeemed'
                  : '❗Unclaimed Voucher!',
              row['status']?.toString() == 'Disable'
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 12),
          ),
          TextSpan(
            text: value,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: valueColor, fontSize: 12),
          ),
        ],
      ),
      overflow: TextOverflow.fade,
    );
  }
}
