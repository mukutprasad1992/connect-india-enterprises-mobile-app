import 'package:flutter/material.dart';
import 'investmentIcon.dart';

class InvestmentSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final String token;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onDelete;

  const InvestmentSummaryCard({
    super.key,
    required this.token,
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3),
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
                    row['occupation'] ?? 'No Occupation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InvestmentActionButtons(
                  token:token,
                  investment: row,
                  index: index,
                  onUpdate: onUpdate,
                  onDelete: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildLabelValueText(context, "Aadhaar", row['aadharNumber'] ?? '', Colors.orange),
            const SizedBox(height: 6),
            _buildLabelValueText(context, "PAN", row['panNumber'] ?? '', Colors.purple),
            const SizedBox(height: 6),
            _buildLabelValueText(
                context, "Email", row['email'] ?? '', Colors.green),

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
      overflow: TextOverflow.ellipsis,
    );
  }
}
